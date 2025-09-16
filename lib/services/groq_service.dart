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

  // Nota: Groq não oferece serviço de transcrição de áudio como o Whisper da OpenAI
  // Se precisar de transcrição, considere usar uma API alternativa ou manter o serviço OpenAI apenas para isso
  static Future<String> transcribeAudio(String audioFilePath) async {
    throw Exception(
      'Groq não oferece serviço de transcrição de áudio. Use uma API alternativa como OpenAI Whisper.',
    );
  }

  // Método específico para ajudar com aplicações de projeto
  static Future<String> generateProjectApplicationHelp({
    required String projectType,
    required String stepTitle,
    required String fieldLabel,
    String? currentValue,
    String? context,
  }) async {
    String prompt =
        '''
Você é um assistente especializado em ajudar funcionários a preencher formulários de aplicação para projetos corporativos.

Contexto:
- Projeto: $projectType
- Etapa: $stepTitle
- Campo: $fieldLabel
${currentValue != null ? '- Valor atual: $currentValue' : ''}
${context != null ? '- Contexto adicional: $context' : ''}

Por favor, forneça:
1. Uma sugestão específica e profissional para este campo
2. Dicas sobre o que incluir
3. Exemplos práticos relevantes

Mantenha o tom profissional e corporativo. Seja específico e útil.
''';

    return await generateText(prompt: prompt, maxTokens: 300, temperature: 0.6);
  }

  // Método para melhorar texto existente
  static Future<String> improveText({
    required String originalText,
    required String fieldLabel,
    required String projectType,
  }) async {
    String prompt =
        '''
Você é um assistente especializado em melhorar textos corporativos.

Contexto:
- Projeto: $projectType
- Campo: $fieldLabel
- Texto original: $originalText

Por favor, melhore este texto mantendo:
1. O significado original
2. Tom profissional e corporativo
3. Clareza e objetividade
4. Relevância para o contexto do projeto

Retorne apenas o texto melhorado, sem explicações adicionais.
''';

    return await generateText(prompt: prompt, maxTokens: 400, temperature: 0.5);
  }

  // Método para gerar sugestões de preenchimento baseadas no contexto
  static Future<List<String>> generateSuggestions({
    required String projectType,
    required String stepTitle,
    required String fieldLabel,
    Map<String, dynamic>? previousAnswers,
  }) async {
    String contextInfo = '';
    if (previousAnswers != null && previousAnswers.isNotEmpty) {
      contextInfo = '\nInformações já preenchidas:\n';
      previousAnswers.forEach((key, value) {
        contextInfo += '- $key: $value\n';
      });
    }

    String prompt =
        '''
Você é um assistente especializado em formulários corporativos.

Contexto:
- Projeto: $projectType
- Etapa: $stepTitle
- Campo: $fieldLabel
$contextInfo

Forneça 3 sugestões específicas e práticas para este campo. Cada sugestão deve ser:
1. Profissional e corporativa
2. Específica para o contexto
3. Útil e acionável

Retorne apenas as 3 sugestões, uma por linha, sem numeração.
''';

    final response = await generateText(
      prompt: prompt,
      maxTokens: 200,
      temperature: 0.7,
    );

    return response
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .take(3)
        .toList();
  }
}
