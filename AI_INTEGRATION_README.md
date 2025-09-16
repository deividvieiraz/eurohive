# Eurohive - Integração com IA

## Configuração da API OpenAI

Para usar as funcionalidades de IA no aplicativo, você precisa configurar sua chave da API OpenAI:

### 1. Obter Chave da API
1. Acesse [OpenAI Platform](https://platform.openai.com/)
2. Faça login ou crie uma conta
3. Vá para "API Keys" no menu lateral
4. Clique em "Create new secret key"
5. Copie a chave gerada

### 2. Configurar no Aplicativo
1. Abra o arquivo `lib/config/api_config.dart`
2. Substitua `YOUR_OPENAI_API_KEY_HERE` pela sua chave real:

```dart
static const String openaiApiKey = 'sk-sua-chave-aqui';
```

### 3. Funcionalidades Disponíveis

#### Modo Manual
- Preenchimento tradicional dos formulários
- Sem assistência de IA

#### Modo Assistido por IA
- **Sugestões Inteligentes**: Clique no ícone de lâmpada para obter sugestões específicas para cada campo
- **Melhoria de Texto**: Clique no ícone de varinha mágica para melhorar textos já escritos
- **Contexto Inteligente**: A IA considera o projeto e informações já preenchidas

#### Modo de Gravação de Áudio
- **Gravação**: Grave suas respostas em áudio
- **Transcrição**: A IA converte automaticamente o áudio em texto
- **Reprodução**: Ouça suas gravações antes de enviar

### 4. Permissões Necessárias

O aplicativo solicitará as seguintes permissões:
- **Microfone**: Para gravação de áudio
- **Armazenamento**: Para salvar arquivos de áudio temporários

### 5. Custos da API

- **GPT-3.5-turbo**: ~$0.002 por 1K tokens
- **Whisper**: ~$0.006 por minuto de áudio

### 6. Troubleshooting

#### Erro: "Chave da API não configurada"
- Verifique se a chave foi inserida corretamente em `api_config.dart`
- Certifique-se de que a chave não está vazia

#### Erro: "Permissões não concedidas"
- Vá para as configurações do dispositivo
- Ative as permissões de microfone e armazenamento para o aplicativo

#### Erro de conectividade
- Verifique sua conexão com a internet
- Confirme se a chave da API está ativa na OpenAI

### 7. Segurança

- **NUNCA** commite sua chave da API no controle de versão
- Mantenha sua chave segura e não a compartilhe
- Considere usar variáveis de ambiente em produção

### 8. Exemplo de Uso

```dart
// Obter sugestões para um campo
final suggestions = await GroqService.generateSuggestions(
  projectType: 'Vem Crescer',
  stepTitle: 'Informações Básicas',
  fieldLabel: 'Objetivo da proposta',
  previousAnswers: {'cargo_unidade': 'Analista de TI'},
);

// Melhorar texto existente
final improvedText = await GroqService.improveText(
  originalText: 'Quero aprender mais sobre desenvolvimento',
  fieldLabel: 'Objetivo da proposta',
  projectType: 'Vem Crescer',
);

// Transcrever áudio
final transcription = await GroqService.transcribeAudio('/path/to/audio.m4a');
```
