import 'package:flutter/material.dart';
import 'package:eurohive/core/constants/app_colors.dart';
import 'package:eurohive/data/projects_data.dart';
import 'package:eurohive/services/groq_service.dart';

class IntelligentQuestionnaireScreen extends StatefulWidget {
  const IntelligentQuestionnaireScreen({super.key});

  @override
  State<IntelligentQuestionnaireScreen> createState() =>
      _IntelligentQuestionnaireScreenState();
}

class _IntelligentQuestionnaireScreenState
    extends State<IntelligentQuestionnaireScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentStep = 0;
  final Map<String, dynamic> _formData = {};
  final Map<String, GlobalKey<FormState>> _formKeys = {};
  final Map<String, TextEditingController> _textControllers = {};

  // Estados para animação de loading
  bool _showLoading = false;
  late AnimationController _loadingController;
  late Animation<double> _loadingAnimation;

  // Resultado do questionário
  List<Map<String, dynamic>> _recommendedProjects = [];
  bool _showResult = false;

  final List<Map<String, dynamic>> _questions = <Map<String, dynamic>>[
    {
      'id': 'idea_description',
      'title': 'Descreva sua ideia',
      'description':
          'Conte-nos sobre sua ideia: o que é, qual problema resolve e como funciona',
      'type': 'textArea',
      'placeholder':
          'Ex: Uma solução para automatizar o processo de... que resolve o problema de... funcionando através de...',
      'isRequired': true,
      'maxLength': 800,
    },
    {
      'id': 'target_audience',
      'title': 'Público beneficiado',
      'description': 'Quem será beneficiado com sua ideia?',
      'type': 'dropdown',
      'options': [
        'Colaboradores internos',
        'Clientes externos',
        'Fornecedores',
        'Comunidade',
        'Todos os stakeholders',
        'Outros',
      ],
      'isRequired': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Inicializar controladores de animação
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _loadingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.easeInOut),
    );

    // Inicializar form keys e text controllers
    for (int i = 0; i < _questions.length; i++) {
      _formKeys['step_$i'] = GlobalKey<FormState>();
    }

    for (final question in _questions) {
      if (question['type'] == 'textArea') {
        _textControllers[question['id']] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _loadingController.dispose();
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => _showExitDialog(),
        ),
        title: const Text(
          'Questionário Inteligente',
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          if (!_showResult) _buildQuestionnaireContent(),
          if (_showResult) _buildResultContent(),
          _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildQuestionnaireContent() {
    return Column(
      children: [
        _buildProgressBar(),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentStep = index;
              });
            },
            itemCount: _questions.length,
            itemBuilder: (context, index) {
              return _buildQuestionContent(index);
            },
          ),
        ),
        _buildNavigationButtons(),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pergunta ${_currentStep + 1} de ${_questions.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${((_currentStep + 1) / _questions.length * 100).round()}%',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (_currentStep + 1) / _questions.length,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.darkOrange,
            ),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionContent(int questionIndex) {
    final question = _questions[questionIndex];

    return Form(
      key: _formKeys['step_$questionIndex'],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ícone da pergunta
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.darkOrange,
                    AppColors.darkOrange.withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.darkOrange.withValues(alpha: 0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 40,
              ),
            ),

            const SizedBox(height: 24),

            // Título da pergunta
            Text(
              question['title'],
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),

            const SizedBox(height: 12),

            // Descrição da pergunta
            Text(
              question['description'],
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),

            const SizedBox(height: 32),

            // Campo de input
            _buildQuestionInput(question),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionInput(Map<String, dynamic> question) {
    final String questionType = question['type'] as String;
    switch (questionType) {
      case 'textArea':
        return TextFormField(
          controller: _textControllers[question['id'] as String],
          onChanged: (value) {
            _formData[question['id'] as String] = value;
          },
          maxLines: 4,
          maxLength: question['maxLength'] as int?,
          decoration: InputDecoration(
            hintText: question['placeholder'] as String,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.darkOrange,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.all(16),
          ),
          validator: (question['isRequired'] as bool)
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo é obrigatório';
                  }
                  return null;
                }
              : null,
        );

      case 'dropdown':
        return DropdownButtonFormField<String>(
          value: _formData[question['id'] as String],
          onChanged: (value) => _formData[question['id'] as String] = value,
          decoration: InputDecoration(
            hintText: 'Selecione uma opção',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.darkOrange,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.all(16),
          ),
          items: (question['options'] as List<String>)
              .map<DropdownMenuItem<String>>((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              })
              .toList(),
          validator: (question['isRequired'] as bool)
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo é obrigatório';
                  }
                  return null;
                }
              : null,
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: SizedBox(
                height: 56,
                child: OutlinedButton(
                  onPressed: _previousStep,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Voltar',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _currentStep == _questions.length - 1
                    ? _analyzeAndRecommend
                    : _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  _currentStep == _questions.length - 1
                      ? 'Analisar e Recomendar'
                      : 'Próximo',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultContent() {
    if (_recommendedProjects.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header do resultado
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.darkOrange.withValues(alpha: 0.1),
                  AppColors.darkOrange.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.darkOrange.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.darkOrange,
                        AppColors.darkOrange.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.darkOrange.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _recommendedProjects.length == 1
                      ? 'Projeto Recomendado'
                      : 'Projetos Recomendados',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _recommendedProjects.length == 1
                      ? 'Com base nas suas respostas, encontramos o projeto ideal para sua ideia!'
                      : 'Com base nas suas respostas, encontramos ${_recommendedProjects.length} projetos ideais para sua ideia!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Lista de projetos recomendados
          ..._recommendedProjects.map(
            (project) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildProjectCard(project),
            ),
          ),

          const SizedBox(height: 24),

          // Botão de voltar
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: AppColors.black
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Voltar para Discovery',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Ícone do projeto
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    project['color'],
                    project['color'].withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: project['color'].withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                project['icon'],
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            // Informações do projeto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    project['description'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: project['color'].withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          project['category'],
                          style: TextStyle(
                            color: project['color'],
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(Icons.star, size: 14, color: Colors.amber[600]),
                          const SizedBox(width: 2),
                          Text(
                            project['rating'],
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    if (!_showLoading) return const SizedBox.shrink();

    return Container(
      color: Colors.black.withValues(alpha: 0.3),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ícone animado
              AnimatedBuilder(
                animation: _loadingAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _loadingAnimation.value * 2 * 3.14159,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.darkOrange,
                            AppColors.darkOrange.withValues(alpha: 0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.darkOrange.withValues(alpha: 0.3),
                            blurRadius: 15,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Analisando suas respostas...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkOrange,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.darkOrange,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      if (_currentStep < _questions.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        FocusScope.of(context).unfocus();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateCurrentStep() {
    final formKey = _formKeys['step_$_currentStep'];
    if (formKey?.currentState?.validate() ?? true) {
      return true;
    }
    return false;
  }

  Future<void> _analyzeAndRecommend() async {
    if (!_validateCurrentStep()) return;

    setState(() {
      _showLoading = true;
    });

    _loadingController.repeat();

    try {
      // Preparar dados para análise
      final ideaDescription = _formData['idea_description'] ?? '';
      final targetAudience = _formData['target_audience'] ?? '';

      // Criar prompt para análise
      final projectsInfo = projects
          .map(
            (p) => '${p['id']}: ${p['longDescription']}',
          )
          .join('\n\n');

      final prompt =
          '''
Você é um especialista em análise de projetos corporativos. Analise a ideia do usuário e recomende os projetos mais adequados.

IDEA DO USUÁRIO: $ideaDescription
PÚBLICO BENEFICIADO: $targetAudience

PROJETOS DISPONÍVEIS:
$projectsInfo

INSTRUÇÕES CRÍTICAS:
1. Analise a ideia e identifique apenas os projetos que tenham relação com a ideia do usuário
2. Considere diferentes aspectos: inovação, melhoria, desenvolvimento, eventos, etc.
3. Retorne no mínimo 1 e no máximo 3 projetos diferentes, separados por vírgula
5. Use apenas os IDs: vem_crescer, kaizen_blitz, clic, simplifica, formacao_lideres, oficina_digital, fabrica_software, hackathon, challenge, imersoes, multiplicadores, intraempreendedorismo, cientista_empreendedor, euron_hub, euron_academy, euron_news, euron_talks, eventos
6. Sua resposta deve conter apenas os IDs dos projetos, nenhum texto explicativo antes ou depois.

EXEMPLO DE RESPOSTA: clic, oficina_digital, hackathon
OUTRO EXEMPLO DE RESPOSTA: fabrica_software

RESPOSTA (de 1 a 3 IDs diferentes separados por vírgula):
''';

      final response = await GroqService.generateText(
        prompt: prompt,
        maxTokens: 150,
        temperature: 0.7,
      );

      // Processar resposta da IA
      String cleanResponse = response.trim().toLowerCase();

      // Remover possíveis prefixos como "resposta:" ou "projetos:"
      cleanResponse = cleanResponse.replaceAll(
        RegExp(r'^(resposta|projetos?):\s*'),
        '',
      );

      // Dividir por vírgula e limpar espaços
      final recommendedIds = cleanResponse
          .split(',')
          .map((id) => id.trim())
          .where((id) => id.isNotEmpty)
          .toList();

      // Simular delay para melhor UX
      await Future.delayed(const Duration(seconds: 2));

      // Encontrar os projetos recomendados
      final recommendedProjects = <Map<String, dynamic>>[];
      final foundIds = <String>{};

      for (final id in recommendedIds) {
        if (id != 'nenhum' && !foundIds.contains(id)) {
          try {
            final project = projects.firstWhere(
              (project) => project['id'] == id,
            );
            recommendedProjects.add(project);
            foundIds.add(id);
          } catch (e) {
            // Projeto não encontrado, continuar
            continue;
          }
        }
      }

      setState(() {
        _recommendedProjects = recommendedProjects;
        _showResult = true;
        _showLoading = false;
      });

      _loadingController.stop();
    } catch (e) {
      setState(() {
        _showLoading = false;
      });
      _loadingController.stop();

      _showErrorDialog('Erro ao analisar suas respostas: $e');
    }
  }



  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair do questionário'),
        content: const Text(
          'Tem certeza que deseja sair? Todas as respostas serão perdidas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fecha o dialog
              Navigator.pop(context); // Volta para a tela anterior
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
