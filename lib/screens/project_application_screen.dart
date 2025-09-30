import 'package:eurohive/core/constants/app_colors.dart';
import 'package:eurohive/models/project_application_model.dart' as model;
import 'package:eurohive/models/user_application.dart';
import 'package:eurohive/services/user_application_service.dart';
import 'package:eurohive/routes/app_routes.dart';
import 'package:eurohive/screens/application_method_choice_screen.dart';
import 'package:eurohive/services/groq_service.dart';
import 'package:eurohive/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:async';

class ProjectApplicationScreen extends StatefulWidget {
  final String projectId;
  final ApplicationMode applicationMode;

  const ProjectApplicationScreen({
    super.key,
    required this.projectId,
    this.applicationMode = ApplicationMode.manual,
  });

  @override
  State<ProjectApplicationScreen> createState() =>
      _ProjectApplicationScreenState();
}

class _ProjectApplicationScreenState extends State<ProjectApplicationScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late model.ProjectApplicationModel _project;
  int _currentStep = 0;
  final Map<String, dynamic> _formData = {};
  final Map<String, GlobalKey<FormState>> _formKeys = {};

  // Estados para animações mágicas
  bool _showMagicLoading = false;
  
  // Estados para animação de gravação de áudio
  late AnimationController _pulsingController;
  late Animation<double> _pulsingAnimation;

  // Estados para speech-to-text
  final SpeechToText _speechToText = SpeechToText();
  final Map<String, bool> _isListeningByField = {};
  final Map<String, String> _recognizedTextByField = {};
  final Map<String, double> _confidenceByField = {};
  final Map<String, Timer?> _silenceTimers = {};

  // Estados para animação de digitação
  final Map<String, TextEditingController> _textControllers = {};
  final Map<String, bool> _isTypingAnimation = {};
  final Map<String, String> _typingText = {};

  @override
  void initState() {
    super.initState();
    _project = model.ProjectApplicationData.getProjectById(widget.projectId)!;
    _pageController = PageController();

    // Initialize animation controller for pulsing effect
    _pulsingController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulsingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulsingController,
      curve: Curves.easeInOut,
    ));

    // Initialize form keys for each step
    for (int i = 0; i < _project.steps.length; i++) {
      _formKeys['step_$i'] = GlobalKey<FormState>();
    }

    // Initialize text controllers for each field
    for (final step in _project.steps) {
      for (final field in step.fields) {
        if (field.type == model.FieldType.text ||
            field.type == model.FieldType.textArea) {
          _textControllers[field.id] = TextEditingController(
            text: _formData[field.id] ?? '',
          );
          _isTypingAnimation[field.id] = false;
          _typingText[field.id] = '';
        }
      }
    }

    // Initialize speech-to-text
    if (widget.applicationMode == ApplicationMode.audio) {
      _initSpeech();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pulsingController.dispose();
    // Dispose text controllers
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    // Cancelar todos os timers de silêncio
    for (final timer in _silenceTimers.values) {
      timer?.cancel();
    }
    AudioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        title: Text(
          _project.projectName,
          style: TextStyle(color: AppColors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => _showExitDialog(),
        ),
      ),
      body: Stack(
        children: [
          Column(
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
                  itemCount: _project.steps.length,
                  itemBuilder: (context, index) {
                    return _buildStepContent(index);
                  },
                ),
              ),
              _buildNavigationButtons(),
            ],
          ),
          // Overlay de loading mágico
          _buildMagicLoadingOverlay(),
          // Overlay de gravação de áudio
          _buildAudioRecordingOverlay(),
        ],
      ),
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
                'Passo ${_currentStep + 1} de ${_project.steps.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${((_currentStep + 1) / _project.steps.length * 100).round()}%',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              LinearProgressIndicator(
                value: (_currentStep + 1) / _project.steps.length,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.darkOrange,
                ),
                minHeight: 20,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(int stepIndex) {
    final step = _project.steps[stepIndex];

    return Form(
      key: _formKeys['step_$stepIndex'],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              step.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              step.description,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            if (step.fields.isEmpty)
              _buildReviewStep()
            else
              ...step.fields.map((field) => _buildFormField(field)),
          ],
        ),
      ),
    );
  }

  // Método para animação de digitação
  Future<void> _typeTextAnimation(String fieldId, String text) async {
    setState(() {
      _isTypingAnimation[fieldId] = true;
      _typingText[fieldId] = '';
    });

    for (int i = 0; i <= text.length; i++) {
      if (!_isTypingAnimation[fieldId]!) break;

      setState(() {
        _typingText[fieldId] = text.substring(0, i);
      });

      // Atualizar o controller do campo
      if (_textControllers.containsKey(fieldId)) {
        _textControllers[fieldId]!.text = _typingText[fieldId]!;
        _formData[fieldId] = _typingText[fieldId]!;
      }

      await Future.delayed(const Duration(milliseconds: 10));
    }

    setState(() {
      _isTypingAnimation[fieldId] = false;
    });
  }

  // Widget para animação mágica de loading
  Widget _buildMagicLoadingOverlay() {
    if (!_showMagicLoading) return const SizedBox.shrink();

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
              // Ícone mágico animado
              TweenAnimationBuilder<double>(
                duration: const Duration(seconds: 2),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.rotate(
                    angle: value * 2 * 3.14159,
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
              // Texto animado
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 1500),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: const Text(
                      'IA trabalhando...',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkOrange,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              // Indicador de progresso
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
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

  // Widget para animação de gravação de áudio
  Widget _buildAudioRecordingOverlay() {
    // Verificar se há algum campo sendo gravado
    bool isAnyFieldRecording = _isListeningByField.values.any((isRecording) => isRecording);
    if (!isAnyFieldRecording) return const SizedBox.shrink();

    // Iniciar animação pulsante se estiver gravando
    if (isAnyFieldRecording && !_pulsingController.isAnimating) {
      _pulsingController.repeat(reverse: true);
    }

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
              // Ícone de microfone animado com pulsação contínua
              AnimatedBuilder(
                animation: _createPulsingAnimation(),
                builder: (context, child) {
                  return Transform.scale(
                    scale: 0.8 + (0.4 * _createPulsingAnimation().value),
                    child: Container(
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
                            color: AppColors.darkOrange.withValues(alpha: 0.3 + (0.2 * _createPulsingAnimation().value)),
                            blurRadius: 20 + (10 * _createPulsingAnimation().value),
                            spreadRadius: 5 + (3 * _createPulsingAnimation().value),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.mic,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Texto animado
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 1500),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: const Text(
                      'Gravando áudio...',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkOrange,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              // Indicador de progresso pulsante
              SizedBox(
                width: 200,
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1000),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return LinearProgressIndicator(
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.yellow,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Verifica se o campo deve ter o botão da IA
  bool _shouldShowAIButton(model.FormField field) {
    // Apenas campos de texto e textArea podem ter IA
    if (field.type != model.FieldType.text &&
        field.type != model.FieldType.textArea) {
      return false;
    }

    // Lista de campos que não devem ter IA (informações pessoais e campos específicos)
    final excludedFields = [
      'cargo_unidade',
      'publico_beneficiado',
      'duracao_periodicidade',
      'stack_tecnologia',
      'aplicabilidade_trl',
      'tema_desafio',
      'tema_imersao',
      'tema_multiplicar',
      'area_cientifica',
      'tipo_ideia',
      'tema_curso',
      'tema_talk',
      'tipo_evento',
      'formato',
      'duracao_formato',
    ];

    // Verifica se o campo está na lista de exclusão
    if (excludedFields.contains(field.id)) {
      return false;
    }

    // Verifica se o label contém palavras que indicam informações pessoais
    final personalInfoKeywords = [
      'cargo',
      'unidade',
      'nome',
      'email',
      'telefone',
      'endereço',
      'cpf',
      'rg',
      'matrícula',
      'funcionário',
      'colaborador',
      'pessoa',
      'individual',
    ];

    final labelLower = field.label.toLowerCase();
    for (final keyword in personalInfoKeywords) {
      if (labelLower.contains(keyword)) {
        return false;
      }
    }

    return true;
  }

  // Verifica se o campo deve ter o botão de áudio
  bool _shouldShowAudioButton(model.FormField field) {
    // Apenas campos de texto e textArea podem ter gravação de áudio
    if (field.type != model.FieldType.text &&
        field.type != model.FieldType.textArea) {
      return false;
    }

    // Lista de campos que não devem ter gravação de áudio (informações pessoais e campos específicos)
    final excludedFields = [
      'cargo_unidade',
      'publico_beneficiado',
      'duracao_periodicidade',
      'stack_tecnologia',
      'aplicabilidade_trl',
      'tema_desafio',
      'tema_imersao',
      'tema_multiplicar',
      'area_cientifica',
      'tipo_ideia',
      'tema_curso',
      'tema_talk',
      'tipo_evento',
      'formato',
      'duracao_formato',
    ];

    // Verifica se o campo está na lista de exclusão
    if (excludedFields.contains(field.id)) {
      return false;
    }

    // Verifica se o label contém palavras que indicam informações pessoais
    final personalInfoKeywords = [
      'cargo',
      'unidade',
      'nome',
      'email',
      'telefone',
      'endereço',
      'cpf',
      'rg',
      'matrícula',
      'funcionário',
      'colaborador',
      'pessoa',
      'individual',
    ];

    final labelLower = field.label.toLowerCase();
    for (final keyword in personalInfoKeywords) {
      if (labelLower.contains(keyword)) {
        return false;
      }
    }

    return true;
  }

  Widget _buildFormField(model.FormField field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${field.label}${field.isRequired ? ' *' : ''}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Botão da IA como lanterna no canto superior direito
              if (widget.applicationMode == ApplicationMode.aiAssisted &&
                  _shouldShowAIButton(field))
                _buildAIFlashlightButton(field),
              // Botão de áudio como lanterna no canto superior direito
              if (widget.applicationMode == ApplicationMode.audio &&
                  _shouldShowAudioButton(field))
                _buildAudioFlashlightButton(field),
            ],
          ),
          const SizedBox(height: 8),
          _buildFieldInput(field),
        ],
      ),
    );
  }

  Widget _buildFieldInput(model.FormField field) {
    switch (field.type) {
      case model.FieldType.text:
        return Column(
          children: [
            TextFormField(
              controller: _textControllers[field.id],
              onChanged: (value) {
                _formData[field.id] = value;
                // Forçar rebuild para atualizar o botão da IA
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: field.placeholder,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.blue),
                ),
                suffixIcon: _buildSuffixIcons(field),
              ),
              validator: field.isRequired
                  ? (value) {
                      if (value == null || value.isEmpty) {
                        return field.validationMessage ??
                            'Este campo é obrigatório';
                      }
                      return null;
                    }
                  : null,
            ),
          ],
        );

      case model.FieldType.textArea:
        return Column(
          children: [
            TextFormField(
              controller: _textControllers[field.id],
              onChanged: (value) {
                _formData[field.id] = value;
                // Forçar rebuild para atualizar o botão da IA
                setState(() {});
              },
              maxLines: 4,
              maxLength: field.maxLength,
              decoration: InputDecoration(
                hintText: field.placeholder,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.blue),
                ),
                suffixIcon: _buildSuffixIcons(field),
              ),
              validator: field.isRequired
                  ? (value) {
                      if (value == null || value.isEmpty) {
                        return field.validationMessage ??
                            'Este campo é obrigatório';
                      }
                      return null;
                    }
                  : null,
            ),
          ],
        );

      case model.FieldType.dropdown:
        return DropdownButtonFormField<String>(
          value: _formData[field.id],
          onChanged: (value) => _formData[field.id] = value,
          decoration: InputDecoration(
            hintText: field.placeholder,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.blue),
            ),
          ),
          items: field.options?.map((option) {
            return DropdownMenuItem(value: option, child: Text(option));
          }).toList(),
          validator: field.isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return field.validationMessage ??
                        'Este campo é obrigatório';
                  }
                  return null;
                }
              : null,
        );

      case model.FieldType.number:
        return TextFormField(
          initialValue: _formData[field.id] ?? '',
          onChanged: (value) => _formData[field.id] = value,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: field.placeholder,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.blue),
            ),
          ),
          validator: field.isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return field.validationMessage ??
                        'Este campo é obrigatório';
                  }
                  return null;
                }
              : null,
        );

      case model.FieldType.file:
        final fileName = _formData[field.id];
        return Container(
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: fileName != null ? AppColors.darkOrange : Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: () => _selectFile(field.id),
            borderRadius: BorderRadius.circular(8),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    fileName != null ? Icons.attach_file : Icons.attach_file,
                    size: 32,
                    color: fileName != null ? AppColors.darkOrange : Colors.grey[600],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    fileName != null
                        ? fileName
                        : 'Toque para anexar arquivo',
                    style: TextStyle(
                      color: fileName != null ? AppColors.darkOrange : Colors.grey[600],
                      fontSize: 14,
                      fontWeight: fileName != null ? FontWeight.w500 : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildReviewStep() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header moderno
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.darkOrange.withValues(alpha: 0.1), AppColors.darkOrange.withValues(alpha: 0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.darkOrange.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.darkOrange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.checklist_rounded,
                    color: AppColors.darkOrange,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Revisão Final',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Confirme todas as informações antes de enviar',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Lista de informações com design moderno
          ..._formData.entries.map((entry) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 4,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.darkOrange,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatFieldName(entry.key),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Text(
                            entry.value?.toString() ?? 'Não informado',
                            style: TextStyle(
                              fontSize: 15,
                              color: entry.value?.toString().isNotEmpty == true 
                                  ? AppColors.black 
                                  : Colors.grey[500],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          
          const SizedBox(height: 24),
          
          // Card de resumo
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.darkOrange.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.darkOrange,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Todas as informações foram preenchidas corretamente. Você pode prosseguir com o envio da aplicação.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatFieldName(String fieldName) {
    // Converte snake_case para Title Case
    return fieldName
        .split('_')
        .map((word) => word.isNotEmpty 
            ? '${word[0].toUpperCase()}${word.substring(1)}' 
            : '')
        .join(' ');
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Voltar',
                  style: TextStyle(color: AppColors.black),
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _currentStep == _project.steps.length - 1
                  ? _submitApplication
                  : _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.black,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                _currentStep == _project.steps.length - 1
                    ? 'Enviar'
                    : 'Próximo',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      if (_currentStep < _project.steps.length - 1) {
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

  void _selectFile(String fieldId) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.single.name.isNotEmpty) {
        setState(() {
          _formData[fieldId] = result.files.single.name;
        });
      }
    } catch (e) {
      // Em caso de erro, mostrar mensagem
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao selecionar arquivo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _submitApplication() async {
    if (_validateCurrentStep()) {
      try {
        // Criar aplicação usando o serviço
        final application = await UserApplicationService().createApplication(
          projectId: widget.projectId,
          formData: _formData,
        );

        // Navegar para tela de sucesso
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ApplicationSuccessScreen(
                projectName: _project.projectName,
                protocolNumber: application.protocolNumber,
                application: application,
              ),
            ),
          );
        }
      } catch (e) {
        // Em caso de erro, mostrar mensagem
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao enviar aplicação: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da aplicação'),
        content: const Text(
          'Tem certeza que deseja sair? Todas as informações preenchidas serão perdidas.',
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

  // Métodos para IA
  Future<void> _getAISuggestions(model.FormField field) async {
    if (widget.applicationMode != ApplicationMode.aiAssisted) return;

    // Mostrar animação mágica
    setState(() {
      _showMagicLoading = true;
    });

    try {
      // Gerar sugestões rápidas para o campo
      final suggestions = await GroqService.generateQuickSuggestions(
        projectType: _project.projectName,
        stepTitle: _project.steps[_currentStep].title,
        fieldLabel: field.label,
        previousAnswers: _formData.isNotEmpty ? _formData : null,
        maxLength: field.maxLength,
      );

      await Future.delayed(const Duration(milliseconds: 1000));

      // Esconder animação mágica
      setState(() {
        _showMagicLoading = false;
      });

      // Fechar o teclado primeiro
      if (mounted) {
        FocusScope.of(context).unfocus();
      }

      // Aguardar um pouco para o teclado fechar completamente
      await Future.delayed(const Duration(milliseconds: 300));

      // Verificar se o widget ainda está montado antes de mostrar o diálogo
      if (mounted) {
        // Mostrar sugestões em um balão
        _showAISuggestionsTooltip(field, suggestions);
      }
    } catch (e) {
      setState(() {
        _showMagicLoading = false;
      });
      _showErrorDialog('Erro ao obter sugestões da IA: $e');
    }
  }

  Future<void> _improveTextWithAI(String fieldId, String currentText) async {
    if (widget.applicationMode != ApplicationMode.aiAssisted) return;

    // Mostrar animação mágica
    setState(() {
      _showMagicLoading = true;
    });

    try {
      final field = _project.steps[_currentStep].fields.firstWhere(
        (f) => f.id == fieldId,
      );

      final improvedText = await GroqService.improveText(
        originalText: currentText,
        fieldLabel: field.label,
        projectType: _project.projectName,
        maxLength: field.maxLength,
      );

      // Esconder animação mágica
      setState(() {
        _showMagicLoading = false;
      });

      // Fechar o teclado primeiro
      if (mounted) {
        FocusScope.of(context).unfocus();
      }

      // Aguardar um pouco para o teclado fechar completamente
      await Future.delayed(const Duration(milliseconds: 300));

      // Verificar se o widget ainda está montado antes de mostrar o diálogo
      if (mounted) {
        // Mostrar card de melhoria
        _showTextImprovementCard(field, currentText, improvedText.trim().replaceAll('"', ''));
      }
    } catch (e) {
      setState(() {
        _showMagicLoading = false;
      });
      _showErrorDialog('Erro ao melhorar texto: $e');
    }
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

  void _showAISuggestionsTooltip(
    model.FormField field,
    List<String> suggestions,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: Container(
          constraints: const BoxConstraints(
            maxWidth: 400,
            maxHeight: 600,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.darkOrange.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.darkOrange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sugestões da IA',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkOrange,
                            ),
                          ),
                          Text(
                            'Campo: ${field.label}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, size: 20),
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),

              // Sugestões
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: suggestions.asMap().entries.map((entry) {
                      final index = entry.key;
                      final suggestion = entry.value;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.pop(context);
                              _applySuggestion(field.id, suggestion);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: AppColors.darkOrange.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          color: AppColors.darkOrange,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      suggestion,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: Colors.grey[400],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Footer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey[600], size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Toque em uma sugestão para preencher o campo',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _applySuggestion(String fieldId, String suggestion) {
    if (_textControllers.containsKey(fieldId)) {
      // Usar animação de digitação
      _typeTextAnimation(fieldId, suggestion);
    }
  }

  void _showTextImprovementCard(
    model.FormField field,
    String originalText,
    String improvedText,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: Container(
          constraints: const BoxConstraints(
            maxWidth: 400,
            maxHeight: 600,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.darkOrange.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.darkOrange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.auto_fix_high,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Melhoria de Texto',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkOrange,
                            ),
                          ),
                          Text(
                            'Campo: ${field.label}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, size: 20),
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),

              // Conteúdo
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Texto original
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: Colors.red[600],
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Texto atual:',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              originalText,
                              style: const TextStyle(fontSize: 14, height: 1.3),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Texto melhorado
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.auto_awesome,
                                  color: Colors.green[600],
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Sugestão melhorada:',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              improvedText,
                              style: const TextStyle(fontSize: 14, height: 1.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Botões de ação
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.grey[400]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Manter original',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _applySuggestion(field.id, improvedText);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkOrange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Aplicar melhoria'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Métodos para speech-to-text
  void _initSpeech() async {
    await _speechToText.initialize();
    setState(() {});
  }


  Widget _buildAIFlashlightButton(model.FormField field) {
    final isEmpty = (_formData[field.id] ?? '').isEmpty;

    return Container(
      margin: const EdgeInsets.only(left: 8),
      child: IconButton(
        style: IconButton.styleFrom(
          backgroundColor: AppColors.darkOrange,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: AppColors.darkOrange),
          ),
        ),
        icon: Icon(
          isEmpty ? Icons.auto_awesome : Icons.auto_fix_high,
          size: 20,
        ),
        onPressed: () {
          if (isEmpty) {
            _getAISuggestions(field);
          } else {
            _improveTextWithAI(field.id, _formData[field.id] ?? '');
          }
        },
      ),
    );
  }

  Widget _buildAudioFlashlightButton(model.FormField field) {
    final isRecording = _isListeningByField[field.id] ?? false;

    return Container(
      margin: const EdgeInsets.only(left: 8),
      child: IconButton(
        style: IconButton.styleFrom(
          backgroundColor: isRecording ? AppColors.darkOrange : AppColors.darkOrange.withValues(alpha: 0.8),
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: isRecording ? AppColors.darkOrange : AppColors.darkOrange.withValues(alpha: 0.8)),
          ),
        ),
        icon: Icon(
          isRecording ? Icons.stop : Icons.mic,
          size: 20,
        ),
        onPressed: () => _startAudioRecording(field),
      ),
    );
  }

  Widget? _buildSuffixIcons(model.FormField field) {
    List<Widget> icons = [];

    // Remover botão de microfone do suffix quando estiver no modo áudio
    // pois agora temos o botão de áudio no topo do campo
    // if (widget.applicationMode == ApplicationMode.audio) {
    //   // Botão removido - usando apenas o botão de cima
    // }

    return icons.isNotEmpty
        ? Row(mainAxisSize: MainAxisSize.min, children: icons)
        : null;
  }


  void _startSilenceTimer(String fieldId) {
    _silenceTimers[fieldId]?.cancel();
    _silenceTimers[fieldId] = Timer(const Duration(seconds: 2), () {
      // Auto-pausar após 2 segundos de silêncio
      _stopAudioRecording(fieldId);
    });
  }

  void _resetSilenceTimer(String fieldId) {
    _silenceTimers[fieldId]?.cancel();
    _startSilenceTimer(fieldId);
  }

  // Criar animação pulsante
  Animation<double> _createPulsingAnimation() {
    return _pulsingAnimation;
  }

  // Método para iniciar gravação de áudio com animação
  void _startAudioRecording(model.FormField field) async {
    final fieldId = field.id;
    final isCurrentlyRecording = _isListeningByField[fieldId] ?? false;

    if (!isCurrentlyRecording) {
      // Iniciar gravação
      setState(() {});

      // Inicializar speech-to-text
      bool available = await _speechToText.initialize(
        onStatus: (status) {
          // Debug: Speech-to-text status
          if (status == 'done' || status == 'notListening') {
            _stopAudioRecording(fieldId);
          }
        },
        onError: (error) {
          // Debug: Speech-to-text error
          _stopAudioRecording(fieldId);
        },
      );

      if (available) {
        setState(() {
          _isListeningByField[fieldId] = true;
          _recognizedTextByField[fieldId] = '';
          _confidenceByField[fieldId] = 1.0;
        });

        // Iniciar animação pulsante
        _pulsingController.repeat(reverse: true);

        // Iniciar timer de silêncio
        _startSilenceTimer(fieldId);

        _speechToText.listen(
          onResult: (result) {
            // Resetar timer a cada resultado (nova fala detectada)
            _resetSilenceTimer(fieldId);

            setState(() {
              _recognizedTextByField[fieldId] = result.recognizedWords;
              if (result.hasConfidenceRating && result.confidence > 0) {
                _confidenceByField[fieldId] = result.confidence;
              }

              // Atualizar o campo de input em tempo real
              if (_textControllers.containsKey(fieldId)) {
                _textControllers[fieldId]!.text = _recognizedTextByField[fieldId]!;
                _formData[fieldId] = _recognizedTextByField[fieldId]!;
              }
            });
          },
        );
      } else {
        // Se não conseguir inicializar, limpar estado
        setState(() {});
        _showErrorDialog('Não foi possível acessar o microfone');
      }
    } else {
      _stopAudioRecording(fieldId);
    }
  }

  // Método para parar gravação de áudio
  void _stopAudioRecording(String fieldId) {
    _speechToText.stop();
    _silenceTimers[fieldId]?.cancel();
    _silenceTimers[fieldId] = null;
    
    // Parar animação pulsante
    _pulsingController.stop();
    
    setState(() {
      _isListeningByField[fieldId] = false;
    });
  }
}

class ApplicationSuccessScreen extends StatefulWidget {
  final String projectName;
  final String protocolNumber;
  final UserApplication application;

  const ApplicationSuccessScreen({
    super.key,
    required this.projectName,
    required this.protocolNumber,
    required this.application,
  });

  @override
  State<ApplicationSuccessScreen> createState() => _ApplicationSuccessScreenState();
}

class _ApplicationSuccessScreenState extends State<ApplicationSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              
              // Ícone animado de sucesso
              AnimatedBuilder(
                animation: Listenable.merge([_scaleAnimation, _pulseAnimation]),
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value * _pulseAnimation.value,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green[400]!,
                            Colors.green[600]!,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 70,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 40),
              
              // Título principal
              const Text(
                'Aplicação Enviada!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Subtítulo
              Text(
                'Sua aplicação para o projeto foi enviada com sucesso',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 40),
              
              // Card do protocolo com design moderno
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.darkOrange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.receipt_long_rounded,
                        color: AppColors.darkOrange,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Número do Protocolo',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Text(
                        widget.protocolNumber,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              const Spacer(),
              
              // Botões de ação
              Column(
                children: [
                  // Botão para ver perfil
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, AppRoutes.profile);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.black,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        shadowColor: Colors.transparent,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_rounded, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Ver Meu Perfil',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Botão para voltar ao home
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, AppRoutes.main);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        foregroundColor: AppColors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                        shadowColor: Colors.transparent,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.home_rounded, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Voltar ao Home',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
