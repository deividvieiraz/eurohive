class ProjectApplicationModel {
  final String projectId;
  final String projectName;
  final List<ApplicationStep> steps;
  final String description;

  ProjectApplicationModel({
    required this.projectId,
    required this.projectName,
    required this.steps,
    required this.description,
  });
}

class ApplicationStep {
  final int stepNumber;
  final String title;
  final String description;
  final List<FormField> fields;

  ApplicationStep({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.fields,
  });
}

class FormField {
  final String id;
  final String label;
  final FieldType type;
  final bool isRequired;
  final String? placeholder;
  final List<String>? options;
  final int? maxLength;
  final String? validationMessage;

  FormField({
    required this.id,
    required this.label,
    required this.type,
    this.isRequired = false,
    this.placeholder,
    this.options,
    this.maxLength,
    this.validationMessage,
  });
}

enum FieldType {
  text,
  textArea,
  dropdown,
  file,
  number,
  date,
}

class ProjectApplicationData {
  static List<ProjectApplicationModel> getProjects() {
    return [
      ProjectApplicationModel(
        projectId: 'vem_crescer',
        projectName: 'Vem Crescer',
        description: 'Programa de capacitação e desenvolvimento profissional interno',
        steps: [
          ApplicationStep(
            stepNumber: 1,
            title: 'Informações Básicas',
            description: 'Dados sobre seu cargo e objetivo da proposta',
            fields: [
              FormField(
                id: 'cargo_unidade',
                label: 'Qual seu cargo / unidade',
                type: FieldType.text,
                isRequired: true,
                placeholder: 'Ex: Analista de TI - Unidade São Paulo',
              ),
              FormField(
                id: 'objetivo_proposta',
                label: 'Objetivo da proposta (curta)',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Por que isso ajuda no desenvolvimento profissional?',
                maxLength: 200,
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 2,
            title: 'Tipo de Ação',
            description: 'Defina o tipo de capacitação desejada',
            fields: [
              FormField(
                id: 'tipo_acao',
                label: 'Tipo de ação',
                type: FieldType.dropdown,
                isRequired: true,
                options: ['Curso', 'Mentoria', 'Job-shadowing', 'Trilha'],
              ),
              FormField(
                id: 'publico_beneficiado',
                label: 'Público beneficiado (número estimado)',
                type: FieldType.number,
                placeholder: 'Ex: 15 pessoas',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 3,
            title: 'Recursos e Custos',
            description: 'Informações sobre recursos necessários',
            fields: [
              FormField(
                id: 'recursos_custo',
                label: 'Recursos necessários / custo estimado',
                type: FieldType.textArea,
                placeholder: 'Descreva os recursos e custos estimados',
              ),
              FormField(
                id: 'anexos',
                label: 'Anexos (slides, PDF)',
                type: FieldType.file,
                placeholder: 'Anexe documentos relevantes',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 4,
            title: 'Resultados Esperados',
            description: 'Defina as métricas de sucesso',
            fields: [
              FormField(
                id: 'resultado_esperado',
                label: 'Resultado esperado / métricas de sucesso',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Descreva os resultados esperados e como serão medidos',
                maxLength: 300,
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 5,
            title: 'Revisão',
            description: 'Revise suas informações antes de enviar',
            fields: [],
          ),
        ],
      ),
      ProjectApplicationModel(
        projectId: 'kaizen_blitz',
        projectName: 'Kaizen Blitz',
        description: 'Evento de melhoria rápida em times multifuncionais',
        steps: [
          ApplicationStep(
            stepNumber: 1,
            title: 'Área e Problema',
            description: 'Identifique a área e problema atual',
            fields: [
              FormField(
                id: 'area_processo',
                label: 'Área/processo alvo',
                type: FieldType.text,
                isRequired: true,
                placeholder: 'Ex: Processo de atendimento ao cliente',
              ),
              FormField(
                id: 'problema_atual',
                label: 'Descrição do problema atual',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Evidências: tempo, retrabalho, custo',
                maxLength: 400,
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 2,
            title: 'Proposta de Ação',
            description: 'Descreva a proposta de melhoria',
            fields: [
              FormField(
                id: 'proposta_acao',
                label: 'Proposta de ação rápida',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Passos sugeridos para melhoria',
                maxLength: 300,
              ),
              FormField(
                id: 'impacto_estimado',
                label: 'Impacto estimado',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Tempo / custo / qualidade',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 3,
            title: 'Participantes e Evidências',
            description: 'Defina quem participará e anexe evidências',
            fields: [
              FormField(
                id: 'participantes',
                label: 'Quem precisa participar (papéis)',
                type: FieldType.textArea,
                placeholder: 'Liste os papéis necessários',
              ),
              FormField(
                id: 'fotos_prints',
                label: 'Fotos ou prints do processo',
                type: FieldType.file,
                isRequired: true,
                placeholder: 'Anexe fotos ou prints do processo atual',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 4,
            title: 'Riscos e Revisão',
            description: 'Identifique riscos e revise a proposta',
            fields: [
              FormField(
                id: 'risco_impedimentos',
                label: 'Risco / impedimentos',
                type: FieldType.textArea,
                placeholder: 'Identifique possíveis riscos e impedimentos',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 5,
            title: 'Revisão Final',
            description: 'Revise todas as informações antes de enviar',
            fields: [],
          ),
        ],
      ),
      ProjectApplicationModel(
        projectId: 'formacao_lideres',
        projectName: 'Formação de Líderes de Operações',
        description: 'Programa de desenvolvimento de habilidades de liderança',
        steps: [
          ApplicationStep(
            stepNumber: 1,
            title: 'Habilidade e Público',
            description: 'Defina a habilidade e público-alvo',
            fields: [
              FormField(
                id: 'habilidade_desenvolver',
                label: 'Habilidade a desenvolver',
                type: FieldType.text,
                isRequired: true,
                placeholder: 'Ex: feedback, resolução de problemas',
              ),
              FormField(
                id: 'publico_alvo',
                label: 'Público-alvo',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Nível hierárquico, quantidade',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 2,
            title: 'Formato e Duração',
            description: 'Defina o formato e duração do programa',
            fields: [
              FormField(
                id: 'formato_sugerido',
                label: 'Formato sugerido',
                type: FieldType.dropdown,
                isRequired: true,
                options: ['Workshop', 'Trilha EAD', 'Coaching', 'Mentoria'],
              ),
              FormField(
                id: 'duracao_periodicidade',
                label: 'Duração e periodicidade',
                type: FieldType.text,
                placeholder: 'Ex: 8 horas, semanal',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 3,
            title: 'Objetivos de Aprendizagem',
            description: 'Defina os objetivos específicos',
            fields: [
              FormField(
                id: 'objetivos_aprendizagem',
                label: 'Objetivos de aprendizagem',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Liste 3 objetivos principais',
                maxLength: 300,
              ),
              FormField(
                id: 'materiais_apoio',
                label: 'Materiais de apoio / referências',
                type: FieldType.textArea,
                placeholder: 'Materiais necessários para o programa',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 4,
            title: 'Revisão',
            description: 'Revise as informações antes de enviar',
            fields: [],
          ),
        ],
      ),
      ProjectApplicationModel(
        projectId: 'simplifica',
        projectName: 'Simplifica',
        description: 'Programa de simplificação de processos',
        steps: [
          ApplicationStep(
            stepNumber: 1,
            title: 'Processo Atual',
            description: 'Descreva o processo atual e gargalos',
            fields: [
              FormField(
                id: 'processo_atual',
                label: 'Processo atual',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Descrição breve do processo atual',
                maxLength: 300,
              ),
              FormField(
                id: 'gargalos_identificados',
                label: 'Gargalos identificados',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Liste os principais gargalos',
                maxLength: 300,
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 2,
            title: 'Sugestão de Simplificação',
            description: 'Proponha o novo fluxo simplificado',
            fields: [
              FormField(
                id: 'sugestao_simplificacao',
                label: 'Sugestão de simplificação',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Fluxo passo-a-passo simplificado',
                maxLength: 400,
              ),
              FormField(
                id: 'ganho_estimado',
                label: 'Ganho estimado',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Tempo / etapas eliminadas',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 3,
            title: 'Dependências e Anexos',
            description: 'Identifique dependências e anexe documentos',
            fields: [
              FormField(
                id: 'dependencias_tecnicas',
                label: 'Dependências técnicas / autorizações',
                type: FieldType.textArea,
                placeholder: 'Liste as dependências necessárias',
              ),
              FormField(
                id: 'anexos_formularios',
                label: 'Anexos (prints/formulários)',
                type: FieldType.file,
                placeholder: 'Anexe prints ou formulários do processo',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 4,
            title: 'Revisão',
            description: 'Revise a proposta antes de enviar',
            fields: [],
          ),
        ],
      ),
      ProjectApplicationModel(
        projectId: 'clic',
        projectName: 'CLIC (Programa de Inovação Interna)',
        description: 'Programa de inovação interna da empresa',
        steps: [
          ApplicationStep(
            stepNumber: 1,
            title: 'Área e Tipo de Inovação',
            description: 'Defina a área e tipo de inovação',
            fields: [
              FormField(
                id: 'area_envolvida',
                label: 'Área envolvida',
                type: FieldType.text,
                isRequired: true,
                placeholder: 'Ex: TI, Operações, Marketing',
              ),
              FormField(
                id: 'tipo_inovacao',
                label: 'Tipo de inovação',
                type: FieldType.dropdown,
                isRequired: true,
                options: ['Produto', 'Processo', 'Digital'],
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 2,
            title: 'Pitch e Descrição',
            description: 'Crie seu pitch e descreva a inovação',
            fields: [
              FormField(
                id: 'pitch_curto',
                label: 'Pitch curto',
                type: FieldType.text,
                isRequired: true,
                placeholder: 'Uma frase que resume sua ideia',
                maxLength: 100,
              ),
              FormField(
                id: 'descricao_detalhada',
                label: 'Descrição detalhada',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Descrição completa da inovação',
                maxLength: 500,
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 3,
            title: 'Protótipo e Potencial',
            description: 'Anexe protótipo e avalie o potencial',
            fields: [
              FormField(
                id: 'prototipo_mockup',
                label: 'Protótipo / mockup',
                type: FieldType.file,
                placeholder: 'Anexe arquivo do protótipo',
              ),
              FormField(
                id: 'potencial_escala',
                label: 'Potencial de escala / monetização',
                type: FieldType.textArea,
                placeholder: 'Descreva o potencial de escala',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 4,
            title: 'Revisão',
            description: 'Revise sua proposta de inovação',
            fields: [],
          ),
        ],
      ),
      ProjectApplicationModel(
        projectId: 'clic_desafios',
        projectName: 'CLIC Desafios',
        description: 'Desafios específicos do programa de inovação',
        steps: [
          ApplicationStep(
            stepNumber: 1,
            title: 'Escolha do Desafio',
            description: 'Selecione o desafio e explique sua solução',
            fields: [
              FormField(
                id: 'desafio_escolhido',
                label: 'Escolha o desafio',
                type: FieldType.dropdown,
                isRequired: true,
                options: ['Desafio 1', 'Desafio 2', 'Desafio 3', 'Desafio 4'],
              ),
              FormField(
                id: 'como_responde',
                label: 'Como a ideia responde ao desafio',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Resumo de como sua ideia resolve o desafio',
                maxLength: 300,
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 2,
            title: 'Solução e Métricas',
            description: 'Descreva a solução e métricas de impacto',
            fields: [
              FormField(
                id: 'solucao_proposta',
                label: 'Solução proposta',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Tecnologia/recursos utilizados',
                maxLength: 400,
              ),
              FormField(
                id: 'metricas_impacto',
                label: 'Métricas de impacto',
                type: FieldType.textArea,
                placeholder: 'Como será medido o sucesso',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 3,
            title: 'Anexos',
            description: 'Anexe documentos relevantes',
            fields: [
              FormField(
                id: 'anexos',
                label: 'Anexos',
                type: FieldType.file,
                placeholder: 'Anexe documentos, protótipos ou referências',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 4,
            title: 'Revisão',
            description: 'Revise sua proposta antes de enviar',
            fields: [],
          ),
        ],
      ),
      ProjectApplicationModel(
        projectId: 'kaizen',
        projectName: 'Kaizen (Contínuo)',
        description: 'Melhoria contínua em processos e rotinas',
        steps: [
          ApplicationStep(
            stepNumber: 1,
            title: 'Processo e Problema',
            description: 'Identifique o processo e problema',
            fields: [
              FormField(
                id: 'processo_rotina',
                label: 'Processo / rotina',
                type: FieldType.text,
                isRequired: true,
                placeholder: 'Ex: Processo de aprovação de pedidos',
              ),
              FormField(
                id: 'problema_identificado',
                label: 'Problema identificado',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Descreva o problema encontrado',
                maxLength: 300,
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 2,
            title: 'Sugestão de Melhoria',
            description: 'Proponha uma melhoria contínua',
            fields: [
              FormField(
                id: 'sugestao_melhoria',
                label: 'Sugestão de melhoria contínua',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Pequeno experimento para melhoria',
                maxLength: 400,
              ),
              FormField(
                id: 'frequencia_medicao',
                label: 'Frequência de medição e KPI(s)',
                type: FieldType.textArea,
                placeholder: 'Como e quando será medido',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 3,
            title: 'Evidências',
            description: 'Anexe fotos e evidências',
            fields: [
              FormField(
                id: 'fotos_evidencias',
                label: 'Fotos/evidências',
                type: FieldType.file,
                placeholder: 'Anexe fotos ou evidências do problema',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 4,
            title: 'Revisão',
            description: 'Revise sua proposta de melhoria',
            fields: [],
          ),
        ],
      ),
      ProjectApplicationModel(
        projectId: 'agilidade',
        projectName: 'Agilidade Organizacional',
        description: 'Implementação de práticas ágeis na organização',
        steps: [
          ApplicationStep(
            stepNumber: 1,
            title: 'Time e Problema',
            description: 'Identifique o time e problema de coordenação',
            fields: [
              FormField(
                id: 'time_squad',
                label: 'Time / squad envolvido',
                type: FieldType.text,
                isRequired: true,
                placeholder: 'Ex: Squad de Desenvolvimento Frontend',
              ),
              FormField(
                id: 'problema_entrega',
                label: 'Problema de entrega ou coordenação',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Descreva o problema atual',
                maxLength: 300,
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 2,
            title: 'Proposta de Mudança',
            description: 'Proponha mudanças nas práticas ágeis',
            fields: [
              FormField(
                id: 'proposta_mudanca',
                label: 'Proposta de mudança',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Cerimônias, rituais, papéis',
                maxLength: 400,
              ),
              FormField(
                id: 'beneficio_time_cliente',
                label: 'Benefício para time/cliente',
                type: FieldType.textArea,
                placeholder: 'Como isso beneficiará o time e cliente',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 3,
            title: 'Riscos e Dependências',
            description: 'Identifique riscos e dependências',
            fields: [
              FormField(
                id: 'riscos_dependencias',
                label: 'Riscos e dependências',
                type: FieldType.textArea,
                placeholder: 'Liste os riscos e dependências',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 4,
            title: 'Revisão',
            description: 'Revise sua proposta de agilidade',
            fields: [],
          ),
        ],
      ),
      ProjectApplicationModel(
        projectId: 'oficina_digital',
        projectName: 'Oficina Digital',
        description: 'Desenvolvimento de soluções digitais',
        steps: [
          ApplicationStep(
            stepNumber: 1,
            title: 'Tipo de Solução',
            description: 'Defina o tipo de solução digital',
            fields: [
              FormField(
                id: 'tipo_solucao',
                label: 'Tipo de solução digital',
                type: FieldType.dropdown,
                isRequired: true,
                options: ['App', 'Bot', 'Automação', 'Dashboard', 'API'],
              ),
              FormField(
                id: 'problema_resolve',
                label: 'Problema que resolve',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Descreva o problema que será resolvido',
                maxLength: 300,
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 2,
            title: 'Usuário e Requisitos',
            description: 'Defina o usuário final e requisitos',
            fields: [
              FormField(
                id: 'usuario_final',
                label: 'Usuário final / jornada',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Quem usará e como será a jornada',
                maxLength: 300,
              ),
              FormField(
                id: 'requisitos_minimos',
                label: 'Requisitos mínimos (features)',
                type: FieldType.textArea,
                placeholder: 'Liste as funcionalidades essenciais',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 3,
            title: 'Protótipo',
            description: 'Anexe protótipo ou telas',
            fields: [
              FormField(
                id: 'prototipo_telas',
                label: 'Protótipo / telas / API',
                type: FieldType.file,
                placeholder: 'Anexe protótipo, telas ou documentação da API',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 4,
            title: 'Revisão',
            description: 'Revise sua proposta digital',
            fields: [],
          ),
        ],
      ),
      ProjectApplicationModel(
        projectId: 'fabrica_software',
        projectName: 'Fábrica de Software',
        description: 'Desenvolvimento de soluções de software',
        steps: [
          ApplicationStep(
            stepNumber: 1,
            title: 'Tipo de Entrega',
            description: 'Defina o tipo de entrega e tecnologia',
            fields: [
              FormField(
                id: 'tipo_entrega',
                label: 'Tipo de entrega',
                type: FieldType.dropdown,
                isRequired: true,
                options: ['MVP', 'Integração', 'Melhoria', 'Nova funcionalidade'],
              ),
              FormField(
                id: 'stack_tecnologia',
                label: 'Stack/tecnologia preferida',
                type: FieldType.text,
                placeholder: 'Ex: React, Node.js, Python',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 2,
            title: 'Escopo e Critérios',
            description: 'Defina o escopo e critérios de aceitação',
            fields: [
              FormField(
                id: 'escopo_minimo',
                label: 'Escopo mínimo viável',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Lista das funcionalidades essenciais',
                maxLength: 400,
              ),
              FormField(
                id: 'criterios_aceitacao',
                label: 'Critérios de aceitação',
                type: FieldType.textArea,
                placeholder: 'Como será validado o sucesso',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 3,
            title: 'Recursos',
            description: 'Defina os recursos necessários',
            fields: [
              FormField(
                id: 'recursos_necessarios',
                label: 'Recursos necessários',
                type: FieldType.textArea,
                placeholder: 'Devs, tempo, infraestrutura',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 4,
            title: 'Revisão',
            description: 'Revise sua proposta de software',
            fields: [],
          ),
        ],
      ),
      ProjectApplicationModel(
        projectId: 'hackathon',
        projectName: 'Hackathon',
        description: 'Eventos de prototipagem rápida de soluções',
        steps: [
          ApplicationStep(
            stepNumber: 1,
            title: 'Tema e Ideia',
            description: 'Defina o tema e sua ideia',
            fields: [
              FormField(
                id: 'tema_desafio',
                label: 'Tema / desafio do hackathon',
                type: FieldType.text,
                placeholder: 'Ex: Sustentabilidade, IA, Mobile',
              ),
              FormField(
                id: 'descricao_ideia',
                label: 'Descrição da ideia/solução',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Descreva sua ideia ou solução',
                maxLength: 400,
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 2,
            title: 'Equipe e Tecnologias',
            description: 'Defina a equipe e tecnologias',
            fields: [
              FormField(
                id: 'equipe_proposta',
                label: 'Equipe proposta (roles)',
                type: FieldType.textArea,
                placeholder: 'Ex: 1 Dev Frontend, 1 Dev Backend, 1 Designer',
              ),
              FormField(
                id: 'tecnologias_apis',
                label: 'Tecnologias / APIs a usar',
                type: FieldType.textArea,
                placeholder: 'Liste as tecnologias e APIs',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 3,
            title: 'Protótipo',
            description: 'Anexe o protótipo entregável',
            fields: [
              FormField(
                id: 'prototipo_entregavel',
                label: 'Protótipo entregável',
                type: FieldType.file,
                placeholder: 'Link ou anexo do protótipo/MVP',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 4,
            title: 'Revisão',
            description: 'Revise sua proposta de hackathon',
            fields: [],
          ),
        ],
      ),
      ProjectApplicationModel(
        projectId: 'challenge',
        projectName: 'Challenge',
        description: 'Desafios específicos para equipes',
        steps: [
          ApplicationStep(
            stepNumber: 1,
            title: 'Desafio e Solução',
            description: 'Defina o desafio e sua solução',
            fields: [
              FormField(
                id: 'desafio_atacado',
                label: 'Desafio que será atacado',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Descreva o desafio específico',
                maxLength: 300,
              ),
              FormField(
                id: 'solucao_proposta',
                label: 'Solução proposta',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Resumo da solução',
                maxLength: 300,
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 2,
            title: 'Critérios e Recursos',
            description: 'Defina critérios de sucesso e recursos',
            fields: [
              FormField(
                id: 'criterios_sucesso',
                label: 'Critérios de sucesso',
                type: FieldType.textArea,
                placeholder: 'Como será medido o sucesso',
              ),
              FormField(
                id: 'recursos_prazos',
                label: 'Recursos e prazos',
                type: FieldType.textArea,
                placeholder: 'Recursos necessários e cronograma',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 3,
            title: 'Revisão',
            description: 'Revise sua proposta de challenge',
            fields: [],
          ),
        ],
      ),
      ProjectApplicationModel(
        projectId: 'imersoes',
        projectName: 'Imersões',
        description: 'Programas de imersão e aprendizado intensivo',
        steps: [
          ApplicationStep(
            stepNumber: 1,
            title: 'Tema e Objetivo',
            description: 'Defina o tema e objetivo da imersão',
            fields: [
              FormField(
                id: 'tema_imersao',
                label: 'Tema da imersão',
                type: FieldType.text,
                isRequired: true,
                placeholder: 'Ex: Inteligência Artificial, Design Thinking',
              ),
              FormField(
                id: 'objetivo_aprendizado',
                label: 'Objetivo de aprendizado',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'O que os participantes aprenderão',
                maxLength: 300,
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 2,
            title: 'Público e Formato',
            description: 'Defina o público e formato',
            fields: [
              FormField(
                id: 'publico_tamanho',
                label: 'Público e tamanho',
                type: FieldType.textArea,
                placeholder: 'Quantos participarão e perfil',
              ),
              FormField(
                id: 'formato',
                label: 'Formato',
                type: FieldType.dropdown,
                options: ['Presencial', 'Virtual', 'Híbrido'],
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 3,
            title: 'Materiais e Logística',
            description: 'Defina materiais e logística',
            fields: [
              FormField(
                id: 'materiais_logistica',
                label: 'Materiais e logística',
                type: FieldType.textArea,
                placeholder: 'Materiais necessários e aspectos logísticos',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 4,
            title: 'Revisão',
            description: 'Revise sua proposta de imersão',
            fields: [],
          ),
        ],
      ),
      ProjectApplicationModel(
        projectId: 'multiplicadores',
        projectName: 'Multiplicadores',
        description: 'Programa de multiplicação de conhecimento',
        steps: [
          ApplicationStep(
            stepNumber: 1,
            title: 'Tema e Multiplicador',
            description: 'Defina o tema e perfil do multiplicador',
            fields: [
              FormField(
                id: 'tema_multiplicar',
                label: 'Tema a ser multiplicado',
                type: FieldType.text,
                isRequired: true,
                placeholder: 'Ex: Metodologias Ágeis, Liderança',
              ),
              FormField(
                id: 'perfil_multiplicador',
                label: 'Perfil do multiplicador',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Quem vai treinar e suas qualificações',
                maxLength: 300,
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 2,
            title: 'Plano de Disseminação',
            description: 'Defina o plano de disseminação',
            fields: [
              FormField(
                id: 'plano_disseminacao',
                label: 'Plano de disseminação',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Passos para disseminar o conhecimento',
                maxLength: 400,
              ),
              FormField(
                id: 'indicadores_adesao',
                label: 'Indicadores de adesão',
                type: FieldType.textArea,
                placeholder: 'Como será medida a adesão',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 3,
            title: 'Revisão',
            description: 'Revise sua proposta de multiplicação',
            fields: [],
          ),
        ],
      ),
      ProjectApplicationModel(
        projectId: 'intraempreendedorismo',
        projectName: 'Intraempreendedorismo',
        description: 'Programa de empreendedorismo interno',
        steps: [
          ApplicationStep(
            stepNumber: 1,
            title: 'Problema e Pitch',
            description: 'Identifique o problema e crie seu pitch',
            fields: [
              FormField(
                id: 'problema_negocio',
                label: 'Problema de negócio / oportunidade',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Descreva o problema ou oportunidade',
                maxLength: 300,
              ),
              FormField(
                id: 'pitch_solucao',
                label: 'Pitch: solução em 1 frase',
                type: FieldType.text,
                isRequired: true,
                placeholder: 'Uma frase que resume sua solução',
                maxLength: 100,
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 2,
            title: 'Modelo de Valor',
            description: 'Defina o modelo de valor',
            fields: [
              FormField(
                id: 'modelo_valor',
                label: 'Modelo de valor',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Como gera valor para a empresa',
                maxLength: 300,
              ),
              FormField(
                id: 'publico_mercado',
                label: 'Público/mercado interno ou externo',
                type: FieldType.textArea,
                placeholder: 'Quem será o público-alvo',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 3,
            title: 'MVP e Próximos Passos',
            description: 'Defina o MVP e próximos passos',
            fields: [
              FormField(
                id: 'mvp_next_steps',
                label: 'MVP / next steps',
                type: FieldType.textArea,
                placeholder: '3 marcos principais',
                maxLength: 400,
              ),
              FormField(
                id: 'anexos_business_case',
                label: 'Anexos (business case, protótipo)',
                type: FieldType.file,
                placeholder: 'Anexe business case ou protótipo',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 4,
            title: 'Revisão',
            description: 'Revise sua proposta de intraempreendedorismo',
            fields: [],
          ),
        ],
      ),
      ProjectApplicationModel(
        projectId: 'cientista_empreendedor',
        projectName: 'Cientista Empreendedor',
        description: 'Programa para cientistas empreendedores',
        steps: [
          ApplicationStep(
            stepNumber: 1,
            title: 'Área e Hipótese',
            description: 'Defina a área científica e hipótese',
            fields: [
              FormField(
                id: 'area_cientifica',
                label: 'Área científica / pesquisa',
                type: FieldType.text,
                isRequired: true,
                placeholder: 'Ex: Biotecnologia, Física, Química',
              ),
              FormField(
                id: 'hipotese_descoberta',
                label: 'Hipótese ou descoberta',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Resumo da hipótese ou descoberta',
                maxLength: 300,
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 2,
            title: 'Aplicabilidade e Validação',
            description: 'Defina aplicabilidade e necessidades',
            fields: [
              FormField(
                id: 'aplicabilidade_trl',
                label: 'Aplicabilidade / TRL',
                type: FieldType.text,
                placeholder: 'Nível de maturidade tecnológica (1-9)',
              ),
              FormField(
                id: 'necessidades_validacao',
                label: 'Necessidades para validação',
                type: FieldType.textArea,
                placeholder: 'Laboratório, testes, recursos',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 3,
            title: 'Publicações e Referências',
            description: 'Anexe publicações e referências',
            fields: [
              FormField(
                id: 'publicacoes_referencias',
                label: 'Publicações / referências / anexos',
                type: FieldType.file,
                placeholder: 'Anexe publicações e referências',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 4,
            title: 'Revisão',
            description: 'Revise sua proposta científica',
            fields: [],
          ),
        ],
      ),
      ProjectApplicationModel(
        projectId: 'euron_hub',
        projectName: 'Euron Hub',
        description: 'Hub de inovação e colaboração',
        steps: [
          ApplicationStep(
            stepNumber: 1,
            title: 'Tipo de Ideia',
            description: 'Defina o tipo de ideia',
            fields: [
              FormField(
                id: 'tipo_ideia',
                label: 'Tipo de ideia',
                type: FieldType.dropdown,
                isRequired: true,
                options: ['Produto', 'Serviço', 'Colaboração'],
              ),
              FormField(
                id: 'objetivo_estrategico',
                label: 'Objetivo estratégico',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Por que encaixa no Hub',
                maxLength: 300,
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 2,
            title: 'Impacto e Arquivos',
            description: 'Defina o impacto e anexe arquivos',
            fields: [
              FormField(
                id: 'impacto_esperado',
                label: 'Impacto esperado',
                type: FieldType.textArea,
                placeholder: 'Mercado interno/externo',
              ),
              FormField(
                id: 'arquivos_suporte',
                label: 'Arquivos de suporte',
                type: FieldType.file,
                placeholder: 'Pitch, produto, documentação',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 3,
            title: 'Revisão',
            description: 'Revise sua proposta para o Hub',
            fields: [],
          ),
        ],
      ),
      ProjectApplicationModel(
        projectId: 'euron_academy',
        projectName: 'Euron Academy',
        description: 'Programa de educação corporativa',
        steps: [
          ApplicationStep(
            stepNumber: 1,
            title: 'Tema e Público',
            description: 'Defina o tema e público-alvo',
            fields: [
              FormField(
                id: 'tema_curso',
                label: 'Tema do curso / skill',
                type: FieldType.text,
                isRequired: true,
                placeholder: 'Ex: Python, Design Thinking, Liderança',
              ),
              FormField(
                id: 'publico_alvo',
                label: 'Público-alvo',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Perfil dos participantes',
                maxLength: 200,
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 2,
            title: 'Formato e Objetivos',
            description: 'Defina formato e objetivos',
            fields: [
              FormField(
                id: 'formato_duracao',
                label: 'Formato e duração',
                type: FieldType.text,
                placeholder: 'Ex: Online, 40 horas, 8 semanas',
              ),
              FormField(
                id: 'objetivos_avaliacao',
                label: 'Objetivos de aprendizagem e avaliação',
                type: FieldType.textArea,
                placeholder: 'O que será aprendido e como será avaliado',
                maxLength: 400,
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 3,
            title: 'Materiais e Instrutores',
            description: 'Defina materiais e instrutores',
            fields: [
              FormField(
                id: 'materiais_instrutores',
                label: 'Materiais e instrutores sugeridos',
                type: FieldType.textArea,
                placeholder: 'Materiais necessários e instrutores',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 4,
            title: 'Revisão',
            description: 'Revise sua proposta de curso',
            fields: [],
          ),
        ],
      ),
      ProjectApplicationModel(
        projectId: 'euron_news',
        projectName: 'Euron News',
        description: 'Programa de conteúdo interno',
        steps: [
          ApplicationStep(
            stepNumber: 1,
            title: 'Título e Formato',
            description: 'Defina o título e formato do conteúdo',
            fields: [
              FormField(
                id: 'titulo_conteudo',
                label: 'Título da sugestão de conteúdo',
                type: FieldType.text,
                isRequired: true,
                placeholder: 'Título chamativo para o conteúdo',
              ),
              FormField(
                id: 'formato',
                label: 'Formato',
                type: FieldType.dropdown,
                isRequired: true,
                options: ['Artigo', 'Vídeo', 'Entrevista', 'Podcast'],
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 2,
            title: 'Conteúdo e Público',
            description: 'Descreva o conteúdo e público',
            fields: [
              FormField(
                id: 'resumo_conteudo',
                label: 'Resumo do conteúdo',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: '3-4 linhas sobre o conteúdo',
                maxLength: 300,
              ),
              FormField(
                id: 'publico_alvo',
                label: 'Público-alvo',
                type: FieldType.textArea,
                placeholder: 'Quem deve consumir este conteúdo',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 3,
            title: 'Materiais',
            description: 'Anexe materiais de apoio',
            fields: [
              FormField(
                id: 'materiais_anexos',
                label: 'Materiais anexos',
                type: FieldType.file,
                placeholder: 'Texto, imagem, referências',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 4,
            title: 'Revisão',
            description: 'Revise sua sugestão de conteúdo',
            fields: [],
          ),
        ],
      ),
      ProjectApplicationModel(
        projectId: 'euron_talks',
        projectName: 'Euron Talks',
        description: 'Programa de palestras e talks',
        steps: [
          ApplicationStep(
            stepNumber: 1,
            title: 'Tema e Palestrante',
            description: 'Defina o tema e palestrante',
            fields: [
              FormField(
                id: 'tema_talk',
                label: 'Tema do talk',
                type: FieldType.text,
                isRequired: true,
                placeholder: 'Ex: Futuro da IA, Sustentabilidade',
              ),
              FormField(
                id: 'palestrante_sugerido',
                label: 'Palestrante sugerido',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Interno/externo e qualificações',
                maxLength: 200,
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 2,
            title: 'Duração e Objetivo',
            description: 'Defina duração e objetivo',
            fields: [
              FormField(
                id: 'duracao_formato',
                label: 'Duração e formato',
                type: FieldType.dropdown,
                options: ['Painel', 'Palestra', 'Workshop', 'Debate'],
              ),
              FormField(
                id: 'objetivo_talk',
                label: 'Objetivo do talk',
                type: FieldType.textArea,
                placeholder: 'O que se espera alcançar',
                maxLength: 300,
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 3,
            title: 'Materiais de Apoio',
            description: 'Anexe materiais de apoio',
            fields: [
              FormField(
                id: 'materiais_apoio',
                label: 'Materiais de apoio / slides',
                type: FieldType.file,
                placeholder: 'Slides, referências, materiais',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 4,
            title: 'Revisão',
            description: 'Revise sua proposta de talk',
            fields: [],
          ),
        ],
      ),
      ProjectApplicationModel(
        projectId: 'eventos',
        projectName: 'Eventos',
        description: 'Programa de eventos corporativos',
        steps: [
          ApplicationStep(
            stepNumber: 1,
            title: 'Tipo e Objetivo',
            description: 'Defina o tipo de evento e objetivo',
            fields: [
              FormField(
                id: 'tipo_evento',
                label: 'Tipo de evento',
                type: FieldType.dropdown,
                isRequired: true,
                options: ['Interna', 'Externa', 'Híbrida'],
              ),
              FormField(
                id: 'objetivo_publico',
                label: 'Objetivo e público',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Objetivo do evento e público-alvo',
                maxLength: 300,
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 2,
            title: 'Programação',
            description: 'Defina a programação proposta',
            fields: [
              FormField(
                id: 'programacao_cronograma',
                label: 'Programação proposta',
                type: FieldType.textArea,
                isRequired: true,
                placeholder: 'Cronograma detalhado do evento',
                maxLength: 500,
              ),
              FormField(
                id: 'orcamento_estimado',
                label: 'Orçamento estimado',
                type: FieldType.textArea,
                placeholder: 'Custos estimados do evento',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 3,
            title: 'Logística',
            description: 'Defina aspectos logísticos',
            fields: [
              FormField(
                id: 'logistica',
                label: 'Logística',
                type: FieldType.textArea,
                placeholder: 'Local, AV, segurança, alimentação',
              ),
            ],
          ),
          ApplicationStep(
            stepNumber: 4,
            title: 'Revisão',
            description: 'Revise sua proposta de evento',
            fields: [],
          ),
        ],
      ),
    ];
  }

  static ProjectApplicationModel? getProjectById(String projectId) {
    return getProjects().firstWhere(
      (project) => project.projectId == projectId,
      orElse: () => throw Exception('Projeto não encontrado'),
    );
  }
}
