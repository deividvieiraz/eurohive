import 'package:eurohive/core/constants/app_assets.dart';
import 'package:eurohive/core/constants/app_colors.dart';
import 'package:eurohive/screens/application_method_choice_screen.dart';
import 'package:flutter/material.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  String _selectedCategory = 'Todos';

  final List<String> _categories = [
    'Todos',
    'Desenvolvimento',
    'Melhoria',
    'Liderança',
    'Processos',
    'Inovação',
    'Agilidade',
    'Digital',
    'Software',
    'Eventos',
    'Desafios',
  ];

 
  final List<Map<String, dynamic>> _projects = [
    {
      'id': 'vem_crescer',
      'title': 'Vem Crescer',
      'description': 'Programa de capacitação e desenvolvimento profissional interno',
      'longDescription': 'Programa de desenvolvimento profissional voltado para estagiários da Eurofarma. Oferece oportunidades de aprendizado prático e teórico, visando o crescimento e a integração dos participantes à cultura organizacional. Inclui mentorias, workshops e projetos práticos.',
      'category': 'Desenvolvimento',
      'icon': Icons.trending_up,
      'color': AppColors.blue,
      'rating': '4.8',
      'likes': '234',
    },
    {
      'id': 'kaizen_blitz',
      'title': 'Kaizen Blitz',
      'description': 'Evento de melhoria rápida em times multifuncionais',
      'longDescription': 'Evento de melhoria rápida e focada em processos específicos da empresa. Reúne equipes multifuncionais para identificar e implementar melhorias em um curto período, visando ganhos imediatos em eficiência e redução de desperdícios.',
      'category': 'Melhoria',
      'icon': Icons.flash_on,
      'color': AppColors.lightBlue,
      'rating': '4.6',
      'likes': '189',
    },
    {
      'id': 'formacao_lideres',
      'title': 'Formação de Líderes',
      'description': 'Programa de desenvolvimento de habilidades de liderança',
      'longDescription': 'Programa de capacitação para desenvolver habilidades de liderança em operações. Inclui workshops, trilhas de aprendizado e coaching, com foco em competências como feedback, resolução de problemas e gestão de equipes.',
      'category': 'Liderança',
      'icon': Icons.people,
      'color': Colors.purple,
      'rating': '4.9',
      'likes': '456',
    },
    {
      'id': 'simplifica',
      'title': 'Simplifica',
      'description': 'Programa de simplificação de processos',
      'longDescription': 'Iniciativa voltada para a simplificação de processos internos. Identifica gargalos e propõe soluções para otimizar fluxos de trabalho, eliminando etapas desnecessárias e melhorando a eficiência operacional.',
      'category': 'Processos',
      'icon': Icons.tune,
      'color': Colors.orange,
      'rating': '4.7',
      'likes': '312',
    },
    {
      'id': 'clic',
      'title': 'CLIC',
      'description': 'Programa de inovação interna da empresa',
      'longDescription': 'Programa que estimula a inovação dentro da empresa. Envolve colaboradores no desenvolvimento de soluções criativas para desafios internos, promovendo uma cultura de inovação contínua.',
      'category': 'Inovação',
      'icon': Icons.lightbulb,
      'color': Colors.green,
      'rating': '4.5',
      'likes': '178',
    },
    {
      'id': 'clic_desafios',
      'title': 'CLIC Desafios',
      'description': 'Desafios específicos do programa de inovação',
      'longDescription': 'Parte do programa CLIC, foca na identificação e solução de desafios específicos enfrentados pela empresa. Colaboradores propõem ideias inovadoras que são avaliadas e implementadas conforme viabilidade.',
      'category': 'Inovação',
      'icon': Icons.emoji_events,
      'color': Colors.red,
      'rating': '4.4',
      'likes': '567',
    },
    {
      'id': 'kaizen',
      'title': 'Kaizen',
      'description': 'Melhoria contínua em processos e rotinas',
      'longDescription': 'Aplicação contínua da filosofia Kaizen para melhoria de processos. Envolve a equipe na identificação constante de oportunidades de melhoria, promovendo ajustes incrementais que resultam em ganhos sustentáveis ao longo do tempo.',
      'category': 'Melhoria',
      'icon': Icons.refresh,
      'color': AppColors.blue,
      'rating': '4.6',
      'likes': '245',
    },
    {
      'id': 'agilidade',
      'title': 'Agilidade Organizacional',
      'description': 'Implementação de práticas ágeis na organização',
      'longDescription': 'Iniciativa para aumentar a agilidade da organização. Revisa e ajusta práticas e estruturas internas, implementando cerimônias, rituais e papéis que favoreçam uma resposta rápida e eficaz às mudanças do mercado.',
      'category': 'Agilidade',
      'icon': Icons.speed,
      'color': AppColors.lightBlue,
      'rating': '4.7',
      'likes': '398',
    },
    {
      'id': 'oficina_digital',
      'title': 'Oficina Digital',
      'description': 'Desenvolvimento de soluções digitais',
      'longDescription': 'Desenvolvimento de soluções digitais para otimizar processos internos. Inclui a criação de aplicativos, bots e automações que atendem a necessidades específicas da empresa, melhorando a eficiência e a experiência do usuário.',
      'category': 'Digital',
      'icon': Icons.computer,
      'color': Colors.purple,
      'rating': '4.8',
      'likes': '289',
    },
    {
      'id': 'fabrica_software',
      'title': 'Fábrica de Software',
      'description': 'Desenvolvimento de soluções de software',
      'longDescription': 'Estrutura dedicada ao desenvolvimento ágil de software. Foca na entrega de MVPs, integrações e melhorias contínuas, utilizando stacks e tecnologias preferidas pela empresa, com critérios de aceitação bem definidos.',
      'category': 'Software',
      'icon': Icons.code,
      'color': Colors.orange,
      'rating': '4.5',
      'likes': '423',
    },
    {
      'id': 'hackathon',
      'title': 'Hackathon',
      'description': 'Eventos de prototipagem rápida de soluções',
      'longDescription': 'Evento intensivo de inovação, onde equipes multidisciplinares desenvolvem soluções para desafios específicos em um curto período. Envolve o uso de tecnologias e APIs, resultando em protótipos ou MVPs aplicáveis à empresa.',
      'category': 'Eventos',
      'icon': Icons.event,
      'color': Colors.green,
      'rating': '4.3',
      'likes': '156',
    },
    {
      'id': 'challenge',
      'title': 'Challenge',
      'description': 'Desafios específicos para equipes',
      'longDescription': 'Iniciativa que propõe desafios internos para estimular a inovação. Colaboradores apresentam soluções, que são avaliadas com base em critérios de sucesso, recursos disponíveis e prazos estabelecidos.',
      'category': 'Desafios',
      'icon': Icons.psychology,
      'color': Colors.red,
      'rating': '4.6',
      'likes': '334',
    },
    {
      'id': 'imersoes',
      'title': 'Imersões',
      'description': 'Programas de imersão e aprendizado intensivo',
      'longDescription': 'Programas de aprendizado intensivo sobre temas específicos. Podem ser presenciais, virtuais ou híbridos, com foco em proporcionar uma compreensão profunda e prática sobre o assunto abordado.',
      'category': 'Desenvolvimento',
      'icon': Icons.school,
      'color': Colors.teal,
      'rating': '4.7',
      'likes': '278',
    },
    {
      'id': 'multiplicadores',
      'title': 'Multiplicadores',
      'description': 'Programa de multiplicação de conhecimento',
      'longDescription': 'Estratégia para disseminar conhecimento internamente. Identifica colaboradores com perfil de liderança para treinar e capacitar outros, ampliando o impacto de programas e iniciativas dentro da empresa.',
      'category': 'Desenvolvimento',
      'icon': Icons.share,
      'color': Colors.indigo,
      'rating': '4.5',
      'likes': '198',
    },
    {
      'id': 'intraempreendedorismo',
      'title': 'Intraempreendedorismo',
      'description': 'Programa de empreendedorismo interno',
      'longDescription': 'Iniciativa que incentiva colaboradores a desenvolverem soluções inovadoras para a empresa. Inclui a identificação de problemas ou oportunidades, desenvolvimento de propostas de valor e implementação de MVPs, com acompanhamento dos resultados.',
      'category': 'Inovação',
      'icon': Icons.business,
      'color': Colors.deepOrange,
      'rating': '4.8',
      'likes': '345',
    },
    {
      'id': 'cientista_empreendedor',
      'title': 'Cientista Empreendedor',
      'description': 'Programa para cientistas empreendedores',
      'longDescription': 'Programa que apoia a transformação de descobertas científicas em soluções aplicáveis. Foca no desenvolvimento de hipóteses ou descobertas, avaliando sua aplicabilidade e nível de maturidade tecnológica, com suporte para validação e publicações.',
      'category': 'Inovação',
      'icon': Icons.science,
      'color': Colors.cyan,
      'rating': '4.6',
      'likes': '167',
    },
    {
      'id': 'euron_hub',
      'title': 'Euron Hub',
      'description': 'Hub de inovação e colaboração',
      'longDescription': 'Plataforma de inovação que conecta ideias, produtos e serviços. Visa integrar diferentes iniciativas digitais e de inovação da Eurofarma, promovendo colaboração e aceleração de soluções dentro do ecossistema da empresa.',
      'category': 'Inovação',
      'icon': Icons.hub,
      'color': Colors.amber,
      'rating': '4.4',
      'likes': '289',
    },
    {
      'id': 'euron_academy',
      'title': 'Euron Academy',
      'description': 'Programa de educação corporativa',
      'longDescription': 'Plataforma de aprendizado corporativo. Oferece cursos e treinamentos focados no desenvolvimento de habilidades específicas, com objetivos de aprendizagem claros, avaliação de desempenho e materiais de apoio atualizados.',
      'category': 'Desenvolvimento',
      'icon': Icons.school,
      'color': Colors.lightGreen,
      'rating': '4.7',
      'likes': '312',
    },
    {
      'id': 'euron_news',
      'title': 'Euron News',
      'description': 'Programa de conteúdo interno',
      'longDescription': 'Canal de comunicação interna que compartilha conteúdos relevantes. Inclui artigos, vídeos e entrevistas sobre temas de interesse para os colaboradores, promovendo o engajamento e a disseminação de informações importantes.',
      'category': 'Desenvolvimento',
      'icon': Icons.newspaper,
      'color': Colors.brown,
      'rating': '4.3',
      'likes': '156',
    },
    {
      'id': 'euron_talks',
      'title': 'Euron Talks',
      'description': 'Programa de palestras e talks',
      'longDescription': 'Eventos que promovem discussões sobre temas atuais. Inclui palestras e painéis com especialistas internos ou externos, com o objetivo de ampliar o conhecimento e estimular o pensamento crítico entre os colaboradores.',
      'category': 'Eventos',
      'icon': Icons.mic,
      'color': Colors.pink,
      'rating': '4.5',
      'likes': '234',
    },
    {
      'id': 'eventos',
      'title': 'Eventos',
      'description': 'Programa de eventos corporativos',
      'longDescription': 'Organização de eventos internos ou externos com objetivos específicos. Inclui a definição de público-alvo, programação detalhada, orçamento estimado e logística necessária, visando promover a integração e o aprendizado dentro da empresa.',
      'category': 'Eventos',
      'icon': Icons.event_note,
      'color': Colors.deepPurple,
      'rating': '4.6',
      'likes': '267',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredProjects = _selectedCategory == 'Todos'
        ? _projects
        : _projects.where((p) => p['category'] == _selectedCategory).toList();

    return Scaffold(
      body: Column(
        children: [
          _buildAppBar(),
          _buildCategoryFilter(),
          Expanded(child: _buildProjectsGrid(filteredProjects)),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              selectedColor: AppColors.blue,
              checkmarkColor: AppColors.white,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.white : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(color: AppColors.black),
      height: 200,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Descubra onde sua\nideia pode fazer\na diferença!",
                style: TextStyle(color: AppColors.white, fontSize: 24),
              ),
              Image.asset(AppAssets.eurofarmaWorld, height: 75),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectsGrid(List<Map<String, dynamic>> projects) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        return _buildProjectCard(projects[index]);
      },
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> projectData) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.white,
      child: InkWell(
        onTap: () => _showProjectDetails(projectData),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    projectData['color'],
                    projectData['color'].withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        projectData['category'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Icon(projectData['icon'], size: 40, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      projectData['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Expanded(
                      child: Text(
                        projectData['description'],
                        style: const TextStyle(color: Colors.grey, fontSize: 11),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.amber[600]),
                        const SizedBox(width: 3),
                        Text(
                          projectData['rating'],
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Icon(Icons.favorite_border, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 3),
                        Text(
                          projectData['likes'],
                          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProjectDetails(Map<String, dynamic> project) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    project['color'],
                    project['color'].withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    right: 20,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Center(
                    child: Icon(project['icon'], size: 80, color: Colors.white),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project['title'],
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    project['description'],
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: project['color'].withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          project['category'],
                          style: TextStyle(
                            color: project['color'],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber[600]),
                          const SizedBox(width: 4),
                          Text(
                            project['rating'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Sobre o Projeto',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    project['longDescription'],
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                ApplicationMethodChoiceScreen(projectId: project['id']),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const begin = Offset(0.0, 1.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;

                              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);

                              return SlideTransition(
                                position: offsetAnimation,
                                child: FadeTransition(opacity: animation, child: child),
                              );
                            },
                            transitionDuration: const Duration(milliseconds: 400),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.black,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Aplicar no Projeto',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
