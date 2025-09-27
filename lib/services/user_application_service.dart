import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eurohive/models/user_application.dart';
import 'package:eurohive/models/project_application_model.dart';

class UserApplicationService {
  static const String _applicationsKey = 'user_applications';
  
  // Singleton pattern
  static final UserApplicationService _instance = UserApplicationService._internal();
  factory UserApplicationService() => _instance;
  UserApplicationService._internal();

  // Mock data para demonstração
  static final List<UserApplication> _mockApplications = [
    UserApplication(
      id: 'app_001',
      projectId: 'vem_crescer',
      projectName: 'Vem Crescer',
      description: 'Programa de capacitação e desenvolvimento profissional interno',
      status: ApplicationStatus.underReview,
      submittedAt: DateTime.now().subtract(const Duration(days: 5)),
      protocolNumber: 'PROT-20241201-001',
      formData: {
        'cargo_unidade': 'Analista de TI - Unidade São Paulo',
        'objetivo_proposta': 'Desenvolver habilidades em desenvolvimento mobile para melhorar a qualidade dos produtos da empresa',
        'tipo_acao': 'Curso',
        'publico_beneficiado': '25',
        'recursos_custo': 'Custo estimado de R\$ 5.000 para cursos online e certificações',
        'resultado_esperado': 'Aumentar em 40% a produtividade da equipe de desenvolvimento mobile',
      },
      reviewerNotes: 'Aplicação em análise pela equipe de RH. Aguardando aprovação do orçamento.',
      steps: ProjectApplicationData.getProjectById('vem_crescer')!.steps,
    ),
    UserApplication(
      id: 'app_002',
      projectId: 'kaizen_blitz',
      projectName: 'Kaizen Blitz',
      description: 'Evento de melhoria rápida em times multifuncionais',
      status: ApplicationStatus.approved,
      submittedAt: DateTime.now().subtract(const Duration(days: 15)),
      reviewedAt: DateTime.now().subtract(const Duration(days: 10)),
      protocolNumber: 'PROT-20241115-002',
      formData: {
        'area_processo': 'Processo de atendimento ao cliente',
        'problema_atual': 'Tempo médio de resposta muito alto (48h) causando insatisfação dos clientes',
        'proposta_acao': 'Implementar sistema de triagem automática e chatbot para respostas rápidas',
        'impacto_estimado': 'Redução de 60% no tempo de resposta e aumento de 30% na satisfação',
        'participantes': 'Equipe de TI, Atendimento e Product Owner',
        'risco_impedimentos': 'Necessidade de treinamento da equipe e possível resistência à mudança',
      },
      reviewerNotes: 'Aplicação aprovada! Equipe será formada em 2 semanas.',
      steps: ProjectApplicationData.getProjectById('kaizen_blitz')!.steps,
    ),
    UserApplication(
      id: 'app_003',
      projectId: 'clic',
      projectName: 'CLIC (Programa de Inovação Interna)',
      description: 'Programa de inovação interna da empresa',
      status: ApplicationStatus.inProgress,
      submittedAt: DateTime.now().subtract(const Duration(days: 30)),
      reviewedAt: DateTime.now().subtract(const Duration(days: 25)),
      protocolNumber: 'PROT-20241101-003',
      formData: {
        'area_envolvida': 'TI',
        'tipo_inovacao': 'Digital',
        'pitch_curto': 'Sistema de gestão inteligente para otimizar processos internos',
        'descricao_detalhada': 'Desenvolvimento de uma plataforma que utiliza IA para automatizar e otimizar processos internos da empresa',
        'potencial_escala': 'Pode ser expandido para outras áreas da empresa e até comercializado externamente',
      },
      reviewerNotes: 'Projeto em desenvolvimento. Equipe formada e cronograma definido.',
      steps: ProjectApplicationData.getProjectById('clic')!.steps,
    ),
    UserApplication(
      id: 'app_004',
      projectId: 'formacao_lideres',
      projectName: 'Formação de Líderes de Operações',
      description: 'Programa de desenvolvimento de habilidades de liderança',
      status: ApplicationStatus.completed,
      submittedAt: DateTime.now().subtract(const Duration(days: 60)),
      reviewedAt: DateTime.now().subtract(const Duration(days: 55)),
      completedAt: DateTime.now().subtract(const Duration(days: 10)),
      protocolNumber: 'PROT-20241001-004',
      formData: {
        'habilidade_desenvolver': 'Feedback e comunicação',
        'publico_alvo': 'Gerentes e supervisores de operações (15 pessoas)',
        'formato_sugerido': 'Workshop',
        'duracao_periodicidade': '16 horas, 4 sessões de 4 horas',
        'objetivos_aprendizagem': 'Melhorar comunicação, desenvolver habilidades de feedback e liderança situacional',
        'materiais_apoio': 'Materiais didáticos, casos práticos e avaliação 360 graus',
      },
      reviewerNotes: 'Programa concluído com sucesso! 90% dos participantes avaliaram positivamente.',
      steps: ProjectApplicationData.getProjectById('formacao_lideres')!.steps,
    ),
  ];

  // Obter todas as aplicações do usuário
  Future<List<UserApplication>> getUserApplications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final applicationsJson = prefs.getStringList(_applicationsKey);
      
      if (applicationsJson == null || applicationsJson.isEmpty) {
        // Se não há aplicações salvas, usar dados mock
        return _mockApplications;
      }
      
      return applicationsJson
          .map((json) => UserApplication.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      // Em caso de erro, retornar dados mock
      return _mockApplications;
    }
  }

  // Salvar aplicação do usuário
  Future<void> saveUserApplication(UserApplication application) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final applications = await getUserApplications();
      
      // Remover aplicação existente se houver (para atualizações)
      applications.removeWhere((app) => app.id == application.id);
      
      // Adicionar nova aplicação
      applications.add(application);
      
      // Salvar no SharedPreferences
      final applicationsJson = applications
          .map((app) => jsonEncode(app.toJson()))
          .toList();
      
      await prefs.setStringList(_applicationsKey, applicationsJson);
    } catch (e) {
      // Em caso de erro, apenas logar (em produção seria melhor usar um logger)
      // print('Erro ao salvar aplicação: $e');
    }
  }

  // Criar nova aplicação
  Future<UserApplication> createApplication({
    required String projectId,
    required Map<String, dynamic> formData,
  }) async {
    final project = ProjectApplicationData.getProjectById(projectId);
    if (project == null) {
      throw Exception('Projeto não encontrado');
    }

    final application = UserApplication(
      id: 'app_${DateTime.now().millisecondsSinceEpoch}',
      projectId: projectId,
      projectName: project.projectName,
      description: project.description,
      status: ApplicationStatus.submitted,
      submittedAt: DateTime.now(),
      protocolNumber: 'PROT-${DateTime.now().millisecondsSinceEpoch}',
      formData: formData,
      steps: project.steps,
    );

    await saveUserApplication(application);
    return application;
  }

  // Obter aplicação por ID
  Future<UserApplication?> getApplicationById(String id) async {
    final applications = await getUserApplications();
    try {
      return applications.firstWhere((app) => app.id == id);
    } catch (e) {
      return null;
    }
  }

  // Obter aplicações por status
  Future<List<UserApplication>> getApplicationsByStatus(ApplicationStatus status) async {
    final applications = await getUserApplications();
    return applications.where((app) => app.status == status).toList();
  }

  // Atualizar status da aplicação
  Future<void> updateApplicationStatus({
    required String applicationId,
    required ApplicationStatus newStatus,
    String? reviewerNotes,
  }) async {
    final application = await getApplicationById(applicationId);
    if (application == null) return;

    final updatedApplication = application.copyWith(
      status: newStatus,
      reviewedAt: newStatus != ApplicationStatus.submitted ? DateTime.now() : application.reviewedAt,
      completedAt: newStatus == ApplicationStatus.completed ? DateTime.now() : application.completedAt,
      reviewerNotes: reviewerNotes ?? application.reviewerNotes,
    );

    await saveUserApplication(updatedApplication);
  }

  // Obter estatísticas das aplicações
  Future<Map<String, int>> getApplicationStats() async {
    final applications = await getUserApplications();
    
    return {
      'total': applications.length,
      'submitted': applications.where((app) => app.status == ApplicationStatus.submitted).length,
      'underReview': applications.where((app) => app.status == ApplicationStatus.underReview).length,
      'approved': applications.where((app) => app.status == ApplicationStatus.approved).length,
      'rejected': applications.where((app) => app.status == ApplicationStatus.rejected).length,
      'inProgress': applications.where((app) => app.status == ApplicationStatus.inProgress).length,
      'completed': applications.where((app) => app.status == ApplicationStatus.completed).length,
    };
  }

  // Obter etapas de status para uma aplicação
  List<ApplicationStepStatus> getApplicationStepStatuses(UserApplication application) {
    final steps = application.steps;
    final statuses = <ApplicationStepStatus>[];
    
    for (int i = 0; i < steps.length; i++) {
      final step = steps[i];
      bool isCompleted = false;
      bool isCurrent = false;
      
      // Lógica para determinar se a etapa está completa ou é a atual
      switch (application.status) {
        case ApplicationStatus.submitted:
          isCompleted = i < 1; // Apenas a primeira etapa está completa
          isCurrent = i == 1;
          break;
        case ApplicationStatus.underReview:
          isCompleted = i < 2; // Duas primeiras etapas completas
          isCurrent = i == 2;
          break;
        case ApplicationStatus.approved:
          isCompleted = i < 3; // Três primeiras etapas completas
          isCurrent = i == 3;
          break;
        case ApplicationStatus.inProgress:
          isCompleted = i < steps.length - 1; // Todas exceto a última
          isCurrent = i == steps.length - 1;
          break;
        case ApplicationStatus.completed:
          isCompleted = true; // Todas as etapas completas
          isCurrent = false;
          break;
        case ApplicationStatus.rejected:
          isCompleted = i < 2; // Apenas as primeiras etapas completas
          isCurrent = false;
          break;
      }
      
      statuses.add(ApplicationStepStatus(
        stepNumber: step.stepNumber,
        title: step.title,
        isCompleted: isCompleted,
        isCurrent: isCurrent,
        completedAt: isCompleted ? application.submittedAt.add(Duration(days: i)) : null,
      ));
    }
    
    return statuses;
  }

  // Limpar todas as aplicações (para testes)
  Future<void> clearAllApplications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_applicationsKey);
  }
}
