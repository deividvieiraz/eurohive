import 'package:eurohive/models/project_application_model.dart';

enum ApplicationStatus {
  submitted,
  underReview,
  approved,
  rejected,
  inProgress,
  completed,
}

class UserApplication {
  final String id;
  final String projectId;
  final String projectName;
  final String description;
  final ApplicationStatus status;
  final DateTime submittedAt;
  final DateTime? reviewedAt;
  final DateTime? completedAt;
  final String protocolNumber;
  final Map<String, dynamic> formData;
  final String? reviewerNotes;
  final List<ApplicationStep> steps;

  UserApplication({
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.description,
    required this.status,
    required this.submittedAt,
    this.reviewedAt,
    this.completedAt,
    required this.protocolNumber,
    required this.formData,
    this.reviewerNotes,
    required this.steps,
  });

  UserApplication copyWith({
    String? id,
    String? projectId,
    String? projectName,
    String? description,
    ApplicationStatus? status,
    DateTime? submittedAt,
    DateTime? reviewedAt,
    DateTime? completedAt,
    String? protocolNumber,
    Map<String, dynamic>? formData,
    String? reviewerNotes,
    List<ApplicationStep>? steps,
  }) {
    return UserApplication(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      description: description ?? this.description,
      status: status ?? this.status,
      submittedAt: submittedAt ?? this.submittedAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      completedAt: completedAt ?? this.completedAt,
      protocolNumber: protocolNumber ?? this.protocolNumber,
      formData: formData ?? this.formData,
      reviewerNotes: reviewerNotes ?? this.reviewerNotes,
      steps: steps ?? this.steps,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'projectName': projectName,
      'description': description,
      'status': status.name,
      'submittedAt': submittedAt.toIso8601String(),
      'reviewedAt': reviewedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'protocolNumber': protocolNumber,
      'formData': formData,
      'reviewerNotes': reviewerNotes,
      'steps': steps.map((step) => {
        'stepNumber': step.stepNumber,
        'title': step.title,
        'description': step.description,
        'fields': step.fields.map((field) => {
          'id': field.id,
          'label': field.label,
          'type': field.type.name,
          'isRequired': field.isRequired,
          'placeholder': field.placeholder,
          'options': field.options,
          'maxLength': field.maxLength,
          'validationMessage': field.validationMessage,
        }).toList(),
      }).toList(),
    };
  }

  factory UserApplication.fromJson(Map<String, dynamic> json) {
    return UserApplication(
      id: json['id'],
      projectId: json['projectId'],
      projectName: json['projectName'],
      description: json['description'],
      status: ApplicationStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => ApplicationStatus.submitted,
      ),
      submittedAt: DateTime.parse(json['submittedAt']),
      reviewedAt: json['reviewedAt'] != null 
          ? DateTime.parse(json['reviewedAt']) 
          : null,
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt']) 
          : null,
      protocolNumber: json['protocolNumber'],
      formData: Map<String, dynamic>.from(json['formData']),
      reviewerNotes: json['reviewerNotes'],
      steps: (json['steps'] as List).map((stepJson) {
        return ApplicationStep(
          stepNumber: stepJson['stepNumber'],
          title: stepJson['title'],
          description: stepJson['description'],
          fields: (stepJson['fields'] as List).map((fieldJson) {
            return FormField(
              id: fieldJson['id'],
              label: fieldJson['label'],
              type: FieldType.values.firstWhere(
                (type) => type.name == fieldJson['type'],
                orElse: () => FieldType.text,
              ),
              isRequired: fieldJson['isRequired'] ?? false,
              placeholder: fieldJson['placeholder'],
              options: fieldJson['options'] != null 
                  ? List<String>.from(fieldJson['options']) 
                  : null,
              maxLength: fieldJson['maxLength'],
              validationMessage: fieldJson['validationMessage'],
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}

class ApplicationStepStatus {
  final int stepNumber;
  final String title;
  final bool isCompleted;
  final bool isCurrent;
  final DateTime? completedAt;

  ApplicationStepStatus({
    required this.stepNumber,
    required this.title,
    required this.isCompleted,
    required this.isCurrent,
    this.completedAt,
  });
}

extension ApplicationStatusExtension on ApplicationStatus {
  String get displayName {
    switch (this) {
      case ApplicationStatus.submitted:
        return 'Enviada';
      case ApplicationStatus.underReview:
        return 'Em Análise';
      case ApplicationStatus.approved:
        return 'Aprovada';
      case ApplicationStatus.rejected:
        return 'Rejeitada';
      case ApplicationStatus.inProgress:
        return 'Em Andamento';
      case ApplicationStatus.completed:
        return 'Concluída';
    }
  }

  String get description {
    switch (this) {
      case ApplicationStatus.submitted:
        return 'Sua aplicação foi enviada e está aguardando análise';
      case ApplicationStatus.underReview:
        return 'Sua aplicação está sendo analisada pela equipe responsável';
      case ApplicationStatus.approved:
        return 'Parabéns! Sua aplicação foi aprovada e está sendo implementada';
      case ApplicationStatus.rejected:
        return 'Sua aplicação não foi aprovada. Entre em contato para mais detalhes';
      case ApplicationStatus.inProgress:
        return 'Sua aplicação está sendo implementada';
      case ApplicationStatus.completed:
        return 'Sua aplicação foi concluída com sucesso';
    }
  }
}
