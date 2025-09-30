import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:eurohive/config/api_config.dart';

class GroqService {
  static const String _baseUrl = ApiConfig.groqBaseUrl;
  static const String _apiKey = ApiConfig.groqApiKey;

  // Método para gerar texto usando Groq
  static Future<String> generateText({
    required String prompt,
    String model = ApiConfig.defaultModel,
    int maxTokens = ApiConfig.defaultMaxTokens,
    double temperature = ApiConfig.defaultTemperature,
  }) async {
    if (!ApiConfig.isApiKeyConfigured) {
      throw Exception(
        'Chave da API Groq não configurada. Verifique o arquivo api_config.dart',
      );
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': model,
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
          'max_tokens': maxTokens,
          'temperature': temperature,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception(
          'Erro na API: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Erro ao conectar com Groq: $e');
    }
  }

  // Método para melhorar texto existente
  static Future<String> improveText({
    required String originalText,
    required String fieldLabel,
    required String projectType,
    int? maxLength,
  }) async {
    String lengthConstraint = '';
    if (maxLength != null) {
      lengthConstraint =
          '\nIMPORTANTE: Este campo tem limite de $maxLength caracteres. O texto melhorado deve respeitar este limite.';
    }

    String prompt =
        '''
Você é um assistente especializado em melhorar textos corporativos.

Contexto:
- Projeto: $projectType
- Campo: $fieldLabel
- Texto original: $originalText$lengthConstraint

Por favor, melhore este texto mantendo:
1. O significado original
2. Tom profissional e corporativo
3. Clareza e objetividade
4. Relevância para o contexto do projeto
5. Respeitar o limite de caracteres (se aplicável)

Retorne apenas o texto melhorado, sem explicações adicionais.
''';

    return await generateText(prompt: prompt, maxTokens: 400, temperature: 0.5);
  }

  static Future<List<String>> generateQuickSuggestions({
    required String projectType,
    required String stepTitle,
    required String fieldLabel,
    Map<String, dynamic>? previousAnswers,
    int? maxLength,
  }) async {
    String contextInfo = '';
    if (previousAnswers != null && previousAnswers.isNotEmpty) {
      contextInfo = '\nInformações já preenchidas:\n';
      previousAnswers.forEach((key, value) {
        contextInfo += '- $key: $value\n';
      });
    }

    String lengthConstraint = '';
    if (maxLength != null) {
      lengthConstraint =
          '\nIMPORTANTE: Este campo tem limite de $maxLength caracteres.';
    }

    String prompt =
        '''
Você é um assistente amigável que ajuda funcionários a preencher formulários corporativos.

Contexto:
- Projeto: $projectType
- Etapa: $stepTitle
- Campo: $fieldLabel
$contextInfo$lengthConstraint

Forneça EXATAMENTE 3 sugestões específicas e práticas para este campo. Cada sugestão deve ser:
1. Profissional e corporativa
2. Específica para o contexto
3. Útil e acionável
4. Respeitar o limite de caracteres (se aplicável)
5. Concisas (máximo 2-3 linhas cada)

IMPORTANTE: Retorne APENAS as 3 sugestões, uma por linha, sem numeração, sem introdução, sem explicações adicionais. Comece diretamente com a primeira sugestão.
''';

    final response = await generateText(
      prompt: prompt,
      maxTokens: 200,
      temperature: 0.7,
    );

    return _parseSuggestions(response).toList();
  }

  // Método auxiliar para processar e filtrar sugestões da IA
  static List<String> _parseSuggestions(String response) {
    List<String> lines = response.split('\n');
    List<String> suggestions = [];

    for (String line in lines) {
      String trimmedLine = line.trim();

      // Pular linhas vazias
      if (trimmedLine.isEmpty) continue;

      // Pular linhas que começam com números (numeração)
      if (RegExp(r'^\d+[\.\)]\s*').hasMatch(trimmedLine)) {
        trimmedLine = trimmedLine
            .replaceFirst(RegExp(r'^\d+[\.\)]\s*'), '')
            .trim();
      }

      // Pular linhas muito curtas (provavelmente não são sugestões)
      if (trimmedLine.length < 10) continue;

      // Pular linhas que são apenas pontuação ou símbolos
      if (RegExp(r'^[^\w\s]+$').hasMatch(trimmedLine)) continue;

      // Se não é explicativo e tem conteúdo suficiente, é uma sugestão válida
      if (trimmedLine.isNotEmpty) {
        suggestions.add(trimmedLine);
      }
    }

    return suggestions;
  }
}
