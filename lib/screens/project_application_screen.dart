import 'package:eurohive/core/constants/app_colors.dart';
import 'package:eurohive/models/project_application_model.dart' as model;
import 'package:eurohive/routes/app_routes.dart';
import 'package:eurohive/screens/application_method_choice_screen.dart';
import 'package:eurohive/services/groq_service.dart';
import 'package:eurohive/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:avatar_glow/avatar_glow.dart';
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

class _ProjectApplicationScreenState extends State<ProjectApplicationScreen> {
  late PageController _pageController;
  late model.ProjectApplicationModel _project;
  int _currentStep = 0;
  final Map<String, dynamic> _formData = {};
  final Map<String, GlobalKey<FormState>> _formKeys = {};

  // Estados para animações mágicas
  bool _showMagicLoading = false;

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
        return Container(
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: () => _selectFile(field.id),
            borderRadius: BorderRadius.circular(8),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.attach_file, size: 32, color: Colors.grey[600]),
                  const SizedBox(height: 8),
                  Text(
                    _formData[field.id] != null
                        ? 'Arquivo selecionado'
                        : 'Toque para anexar arquivo',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Revise suas informações:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ..._formData.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        '${entry.key}:',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      child: Text(entry.value?.toString() ?? 'Não informado'),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
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

  void _selectFile(String fieldId) {
    // Simular seleção de arquivo
    setState(() {
      _formData[fieldId] = 'arquivo_selecionado.pdf';
    });
  }

  void _submitApplication() {
    if (_validateCurrentStep()) {
      // Simular envio da aplicação
      final protocolNumber = 'PROT-${DateTime.now().millisecondsSinceEpoch}';

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ApplicationSuccessScreen(
            projectName: _project.projectName,
            protocolNumber: protocolNumber,
          ),
        ),
      );
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
      FocusScope.of(context).unfocus();

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
      FocusScope.of(context).unfocus();

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
          constraints: const BoxConstraints(maxWidth: 400),
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
              Padding(
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
          constraints: const BoxConstraints(maxWidth: 400),
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
              Padding(
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

  void _stopListeningForField(String fieldId) {
    _speechToText.stop();
    _silenceTimers[fieldId]?.cancel();
    _silenceTimers[fieldId] = null;
    setState(() {
      _isListeningByField[fieldId] = false;
    });
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

  Widget? _buildSuffixIcons(model.FormField field) {
    List<Widget> icons = [];

    // Botão de microfone para modo áudio
    if (widget.applicationMode == ApplicationMode.audio) {
      final isListening = _isListeningByField[field.id] ?? false;
      icons.add(
        AvatarGlow(
          animate: isListening,
          glowColor: Colors.blue,
          duration: const Duration(milliseconds: 2000),
          repeat: true,
          child: IconButton(
            icon: Icon(
              isListening ? Icons.stop : Icons.mic,
              color: isListening ? Colors.red : Colors.blue,
              size: 20,
            ),
            onPressed: () => _listenToSpeech(field),
            tooltip: isListening ? 'Parar gravação' : 'Gravar áudio',
          ),
        ),
      );
    }

    return icons.isNotEmpty
        ? Row(mainAxisSize: MainAxisSize.min, children: icons)
        : null;
  }

  void _listenToSpeech(model.FormField field) async {
    final fieldId = field.id;
    final isCurrentlyListening = _isListeningByField[fieldId] ?? false;

    if (!isCurrentlyListening) {
      bool available = await _speechToText.initialize(
        onStatus: (status) => print('onStatus: $status'),
        onError: (error) => print('onError: $error'),
      );
      if (available) {
        setState(() {
          _isListeningByField[fieldId] = true;
          _recognizedTextByField[fieldId] = '';
          _confidenceByField[fieldId] = 1.0;
        });

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
                _textControllers[fieldId]!.text =
                    _recognizedTextByField[fieldId]!;
                _formData[fieldId] = _recognizedTextByField[fieldId]!;
              }
            });
          },
        );
      }
    } else {
      _stopListeningForField(fieldId);
    }
  }

  void _startSilenceTimer(String fieldId) {
    _silenceTimers[fieldId]?.cancel();
    _silenceTimers[fieldId] = Timer(const Duration(seconds: 2), () {
      // Auto-pausar após 2 segundos de silêncio
      _stopListeningForField(fieldId);
    });
  }

  void _resetSilenceTimer(String fieldId) {
    _silenceTimers[fieldId]?.cancel();
    _startSilenceTimer(fieldId);
  }
}

class ApplicationSuccessScreen extends StatelessWidget {
  final String projectName;
  final String protocolNumber;

  const ApplicationSuccessScreen({
    super.key,
    required this.projectName,
    required this.protocolNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        title: const Text('Aplicação Enviada'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 80,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Aplicação Enviada com Sucesso!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Sua aplicação para o projeto $projectName foi enviada com sucesso.',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.darkOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.blue),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Número do Protocolo',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      protocolNumber,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.main);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Voltar ao Início',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
