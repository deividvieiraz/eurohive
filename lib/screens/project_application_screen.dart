import 'package:eurohive/core/constants/app_colors.dart';
import 'package:eurohive/models/project_application_model.dart' as model;
import 'package:eurohive/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProjectApplicationScreen extends StatefulWidget {
  final String projectId;

  const ProjectApplicationScreen({super.key, required this.projectId});

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

  @override
  void initState() {
    super.initState();
    _project = model.ProjectApplicationData.getProjectById(widget.projectId)!;
    _pageController = PageController();

    // Initialize form keys for each step
    for (int i = 0; i < _project.steps.length; i++) {
      _formKeys['step_$i'] = GlobalKey<FormState>();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
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
          LinearProgressIndicator(
            value: (_currentStep + 1) / _project.steps.length,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.darkOrange),
            minHeight: 20,
            borderRadius: BorderRadius.all(Radius.circular(30)),
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
          Text(
            '${field.label}${field.isRequired ? ' *' : ''}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
        return TextFormField(
          initialValue: _formData[field.id] ?? '',
          onChanged: (value) => _formData[field.id] = value,
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

      case model.FieldType.textArea:
        return TextFormField(
          initialValue: _formData[field.id] ?? '',
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
