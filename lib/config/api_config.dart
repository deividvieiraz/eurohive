class ApiConfig {
  // IMPORTANTE: Substitua pela sua chave real do Groq
  static const String groqApiKey = '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';
  
  // Configurações da API Groq
  static const String groqBaseUrl = 'https://api.groq.com/openai/v1';
  
  // Configurações de modelo (usando o modelo do Groq)
  static const String defaultModel = 'meta-llama/llama-4-scout-17b-16e-instruct';
  // Nota: Groq não tem serviço de transcrição de áudio como Whisper
  // static const String whisperModel = 'whisper-1';
  
  // Configurações de requisição
  static const int defaultMaxTokens = 500;
  static const double defaultTemperature = 0.7;
  
  // Validação da chave
  static bool get isApiKeyConfigured => 
      groqApiKey != 'YOUR_GROQ_API_KEY_HERE' && 
      groqApiKey.isNotEmpty;
}
