# Exemplo de Uso - Integração IA no Eurohive

## Como Usar as Novas Funcionalidades

### 1. Fluxo de Aplicação Atualizado

Quando o usuário clica em "Aplicar" em um projeto, agora ele será direcionado para uma tela de escolha com três opções:

```dart
// Navegação atualizada no discovery_screen.dart
Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        ApplicationMethodChoiceScreen(projectId: project['id']),
    // ... transições
  ),
);
```

### 2. Três Modos de Aplicação

#### Modo Manual (Tradicional)
```dart
ProjectApplicationScreen(
  projectId: 'vem_crescer',
  applicationMode: ApplicationMode.manual,
)
```

#### Modo Assistido por IA
```dart
ProjectApplicationScreen(
  projectId: 'vem_crescer',
  applicationMode: ApplicationMode.aiAssisted,
)
```

#### Modo de Gravação de Áudio
```dart
ProjectApplicationScreen(
  projectId: 'vem_crescer',
  applicationMode: ApplicationMode.audio,
)
```

### 3. Funcionalidades da IA

#### Sugestões Inteligentes
- Clique no ícone de lâmpada 💡 ao lado de cada campo
- A IA analisa o contexto do projeto e campos já preenchidos
- Retorna 3 sugestões específicas e profissionais

#### Melhoria de Texto
- Clique no ícone de varinha mágica ✨ nos campos de texto
- A IA melhora o texto mantendo o significado original
- Aplica tom profissional e corporativo

#### Transcrição de Áudio
- Grave suas respostas usando o microfone
- A IA converte automaticamente para texto
- Reproduza o áudio antes de enviar

### 4. Configuração Necessária

#### Arquivo de Configuração
```dart
// lib/config/api_config.dart
class ApiConfig {
  static const String openaiApiKey = 'sk-sua-chave-aqui';
  // ... outras configurações
}
```

#### Permissões Android
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

#### Permissões iOS
```xml
<!-- ios/Runner/Info.plist -->
<key>NSMicrophoneUsageDescription</key>
<string>Este aplicativo precisa acessar o microfone para gravação de áudio.</string>
```

### 5. Exemplo de Uso Completo

```dart
// 1. Usuário escolhe "Assistente de IA"
ApplicationMethodChoiceScreen(projectId: 'vem_crescer')

// 2. Navega para aplicação com IA
ProjectApplicationScreen(
  projectId: 'vem_crescer',
  applicationMode: ApplicationMode.aiAssisted,
)

// 3. Na tela de aplicação:
// - Usuário clica no ícone de lâmpada
// - IA retorna sugestões baseadas no contexto
// - Usuário seleciona uma sugestão
// - Usuário pode melhorar o texto com IA
// - Processo continua normalmente
```

### 6. Tratamento de Erros

```dart
try {
  final suggestions = await GroqService.generateSuggestions(
    projectType: 'Vem Crescer',
    stepTitle: 'Informações Básicas',
    fieldLabel: 'Objetivo da proposta',
    previousAnswers: {'cargo_unidade': 'Analista de TI'},
  );
} catch (e) {
  // Mostrar erro para o usuário
  _showErrorDialog('Erro ao obter sugestões da IA: $e');
}
```

### 7. Estados da Interface

```dart
// Estados para controle da UI
bool _isLoadingAI = false;        // Carregando sugestões/melhorias
bool _isRecording = false;        // Gravando áudio
String? _currentAudioPath;       // Caminho do áudio atual
List<String> _aiSuggestions = []; // Sugestões da IA
```

### 8. Indicadores Visuais

- **Carregamento da IA**: Indicador circular na barra de progresso
- **Gravação**: Botão vermelho "Parar" durante gravação
- **Sugestões**: Container laranja com sugestões clicáveis
- **Controles de Áudio**: Container verde com botões de gravar/reproduzir

### 9. Benefícios para o Usuário

1. **Eficiência**: Preenchimento mais rápido com sugestões inteligentes
2. **Qualidade**: Textos melhorados automaticamente pela IA
3. **Acessibilidade**: Opção de gravação para quem prefere falar
4. **Flexibilidade**: Três modos diferentes para diferentes preferências
5. **Contexto**: IA considera o projeto específico e informações já preenchidas

### 10. Próximos Passos

1. Configure sua chave da API OpenAI
2. Teste os três modos de aplicação
3. Ajuste os prompts da IA conforme necessário
4. Monitore o uso e custos da API
5. Colete feedback dos usuários
