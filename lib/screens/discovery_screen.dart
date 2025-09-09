import 'package:eurohive/core/constants/app_colors.dart';
import 'package:eurohive/screens/project_application_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        title: const Text('Descobrir'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryFilter(),
          Expanded(child: _buildProjectsGrid()),
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

  Widget _buildProjectsGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: 21,
      itemBuilder: (context, index) {
        return _buildProjectCard(index);
      },
    );
  }

  Widget _buildProjectCard(int index) {
    final projectData = _getProjectData(index);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.white,
      child: InkWell(
        onTap: () {
          _showProjectDetails(projectData);
        },
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
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
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
                    child: Icon(
                      projectData['icon'],
                      size: 40,
                      color: Colors.white,
                    ),
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
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
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
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.favorite_border,
                          size: 14,
                          color: Colors.grey[600],
                        ),
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

  Map<String, dynamic> _getProjectData(int index) {
    final projects = [
      {
        'id': 'vem_crescer',
        'title': 'Vem Crescer',
        'description': 'Programa de capacitação e desenvolvimento profissional interno',
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
        'category': 'Eventos',
        'icon': Icons.event_note,
        'color': Colors.deepPurple,
        'rating': '4.6',
        'likes': '267',
      },
    ];

    return projects[index % projects.length];
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
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
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
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
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
                  const Text(
                    'Este é um projeto inovador que combina as melhores práticas de desenvolvimento com tecnologias modernas. Ideal para desenvolvedores que querem aprender e aplicar novas técnicas.',
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
                          MaterialPageRoute(
                            builder: (context) => ProjectApplicationScreen(
                              projectId: project['id'],
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Aplicar no Projeto',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
