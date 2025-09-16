import 'package:eurohive/core/constants/app_colors.dart';
import 'package:eurohive/models/project_application_model.dart' as model;
import 'package:eurohive/routes/app_routes.dart';
import 'package:eurohive/screens/application_method_choice_screen.dart';
import 'package:eurohive/services/groq_service.dart';
import 'package:eurohive/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  
  // Estados para IA e áudio
  bool _isLoadingAI = false;
  bool _isRecording = false;
  String? _currentAudioPath;
  
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
        if (field.type == model.FieldType.text || field.type == model.FieldType.textArea) {
          _textControllers[field.id] = TextEditingController(text: _formData[field.id] ?? '');
          _isTypingAnimation[field.id] = false;
          _typingText[field.id] = '';
        }
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    // Dispose text controllers
    for (final controller in _textControllers.values) {
      controller.dispose();
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
      body: Column(
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
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.darkOrange),
                minHeight: 20,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              if (_isLoadingAI)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.darkOrange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(3),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
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
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildFieldInput(field),
          if (widget.applicationMode == ApplicationMode.audio)
            _buildAudioControls(field),
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
              onChanged: (value) => _formData[field.id] = value,
              decoration: InputDecoration(
                hintText: field.placeholder,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.blue),
                ),
                suffixIcon: widget.applicationMode == ApplicationMode.aiAssisted
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if ((_formData[field.id] ?? '').isEmpty)
                            IconButton(
                              icon: _isLoadingAI 
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Icon(Icons.psychology, size: 20),
                              onPressed: _isLoadingAI ? null : () => _getAISuggestions(field),
                              tooltip: 'Obter ajuda da IA',
                            ),
                          if ((_formData[field.id] ?? '').isNotEmpty)
                            IconButton(
                              icon: _isLoadingAI 
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Icon(Icons.auto_fix_high, size: 20),
                              onPressed: _isLoadingAI ? null : () => _improveTextWithAI(field.id, _formData[field.id] ?? ''),
                              tooltip: 'Melhorar com IA',
                            ),
                        ],
                      )
                    : null,
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
        return TextFormField(
          controller: _textControllers[field.id],
          onChanged: (value) => _formData[field.id] = value,
          maxLines: 4,
          maxLength: field.maxLength,
          decoration: InputDecoration(
            hintText: field.placeholder,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.blue),
            ),
            suffixIcon: widget.applicationMode == ApplicationMode.aiAssisted
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if ((_formData[field.id] ?? '').isEmpty)
                        IconButton(
                          icon: _isLoadingAI 
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.psychology, size: 20),
                          onPressed: _isLoadingAI ? null : () => _getAISuggestions(field),
                          tooltip: 'Obter ajuda da IA',
                        ),
                      if ((_formData[field.id] ?? '').isNotEmpty)
                        IconButton(
                          icon: _isLoadingAI 
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.auto_fix_high, size: 20),
                          onPressed: _isLoadingAI ? null : () => _improveTextWithAI(field.id, _formData[field.id] ?? ''),
                          tooltip: 'Melhorar com IA',
                        ),
                    ],
                  )
                : null,
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

  // Método para animação de digitação
  Future<void> _typeTextAnimation(String fieldId, String text) async {
    if (!_textControllers.containsKey(fieldId)) return;
    
    setState(() {
      _isTypingAnimation[fieldId] = true;
      _typingText[fieldId] = '';
    });
    
    final controller = _textControllers[fieldId]!;
    controller.clear();
    
    for (int i = 0; i <= text.length; i++) {
      if (!_isTypingAnimation[fieldId]!) break; // Cancelar se necessário
      
      final currentText = text.substring(0, i);
      controller.text = currentText;
      _formData[fieldId] = currentText;
      
      await Future.delayed(const Duration(milliseconds: 30));
    }
    
    setState(() {
      _isTypingAnimation[fieldId] = false;
    });
  }

  // Métodos para IA
  Future<void> _getAISuggestions(model.FormField field) async {
    if (widget.applicationMode != ApplicationMode.aiAssisted) return;

    setState(() {
      _isLoadingAI = true;
    });

    try {
      // Gerar sugestão específica para o campo
      final suggestion = await GroqService.generateText(
        prompt: '''
Você é um assistente especializado em ajudar funcionários a preencher formulários de aplicação para projetos corporativos.

Contexto:
- Projeto: ${_project.projectName}
- Etapa: ${_project.steps[_currentStep].title}
- Campo: ${field.label}
${_formData.isNotEmpty ? '- Informações já preenchidas: ${_formData.entries.map((e) => '${e.key}: ${e.value}').join(', ')}' : ''}

Por favor, forneça uma sugestão específica e profissional para este campo. Seja direto e prático, fornecendo um texto que pode ser usado diretamente no campo.

Retorne apenas o texto sugerido, sem explicações adicionais.
''',
        maxTokens: 200,
        temperature: 0.6,
      );

      setState(() {
        _isLoadingAI = false;
      });

      // Aplicar sugestão com animação de digitação
      await _typeTextAnimation(field.id, suggestion.replaceAll('"', '').trim());
      
    } catch (e) {
      setState(() {
        _isLoadingAI = false;
      });
      _showErrorDialog('Erro ao obter sugestão da IA: $e');
    }
  }

  Future<void> _improveTextWithAI(String fieldId, String currentText) async {
    if (widget.applicationMode != ApplicationMode.aiAssisted) return;

    setState(() {
      _isLoadingAI = true;
    });

    try {
      final field = _project.steps[_currentStep].fields.firstWhere(
        (f) => f.id == fieldId,
      );

      final improvedText = await GroqService.improveText(
        originalText: currentText,
        fieldLabel: field.label,
        projectType: _project.projectName,
      );

      setState(() {
        _isLoadingAI = false;
      });

      // Aplicar texto melhorado com animação de digitação
      await _typeTextAnimation(fieldId, improvedText.trim());
      
    } catch (e) {
      setState(() {
        _isLoadingAI = false;
      });
      _showErrorDialog('Erro ao melhorar texto: $e');
    }
  }

  // Métodos para áudio
  Future<void> _startRecording() async {
    try {
      final success = await AudioService.startRecording();
      if (success) {
        setState(() {
          _isRecording = true;
        });
      }
    } catch (e) {
      _showErrorDialog('Erro ao iniciar gravação: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await AudioService.stopRecording();
      setState(() {
        _isRecording = false;
        _currentAudioPath = path;
      });

      if (path != null) {
        _transcribeAudio(path);
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      _showErrorDialog('Erro ao parar gravação: $e');
    }
  }

  Future<void> _transcribeAudio(String audioPath) async {
    setState(() {
      _isLoadingAI = true;
    });

    try {
      final transcription = await GroqService.transcribeAudio(audioPath);
      
      // Aplicar transcrição ao campo atual
      final currentStep = _project.steps[_currentStep];
      if (currentStep.fields.isNotEmpty) {
        final firstField = currentStep.fields.first;
        setState(() {
          _formData[firstField.id] = transcription;
          _isLoadingAI = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingAI = false;
      });
      _showErrorDialog('Erro ao transcrever áudio: $e');
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


  Widget _buildAudioControls(model.FormField field) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.mic, color: Colors.green, size: 16),
              const SizedBox(width: 8),
              Text(
                'Gravação de Áudio:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isRecording)
                ElevatedButton.icon(
                  onPressed: _startRecording,
                  icon: const Icon(Icons.mic, size: 18),
                  label: const Text('Gravar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                )
              else
                ElevatedButton.icon(
                  onPressed: _stopRecording,
                  icon: const Icon(Icons.stop, size: 18),
                  label: const Text('Parar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              if (_currentAudioPath != null) ...[
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => AudioService.playAudio(_currentAudioPath!),
                  icon: const Icon(Icons.play_arrow, size: 18),
                  label: const Text('Reproduzir'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ],
            ],
          ),
          if (_isRecording)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Gravando...',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
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
