import 'package:eurohive/core/constants/app_assets.dart';
import 'package:eurohive/core/constants/app_colors.dart';
import 'package:eurohive/screens/application_method_choice_screen.dart';
import 'package:eurohive/screens/questionnaire_intro_screen.dart';
import 'package:eurohive/data/projects_data.dart';
import 'package:flutter/material.dart';

class DiscoveryScreen extends StatefulWidget {
  final String? projectToHighlight;
  
  const DiscoveryScreen({super.key, this.projectToHighlight});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  String _selectedCategory = 'Todos';
  late ScrollController _scrollController;
  final GlobalKey _gridKey = GlobalKey();

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
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    
    // Se há um projeto para destacar, aguarda e faz scroll
    if (widget.projectToHighlight != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _scrollToProject(widget.projectToHighlight!);
        });
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProjects = _selectedCategory == 'Todos'
        ? projects
        : projects
            .where((p) => p['category'] == _selectedCategory)
            .toList();
    return Scaffold(
      body: Column(
        children: [
          _buildAppBar(),
          _buildCategoryFilter(),
          Expanded(child: _buildProjectsGrid(filteredProjects, widget.projectToHighlight)),
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
      child: SafeArea(
        child: Column(
          children: [
            Padding(
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
            const SizedBox(height: 8),
            _buildQuestionnaireCard()
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsGrid(List<Map<String, dynamic>> projects, String? projectToHighlight) {
    return GridView.builder(
      key: _gridKey,
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        final isHighlighted = projectToHighlight != null && 
                             project['title'] == projectToHighlight;
        return _buildProjectCard(project, isHighlighted);
      },
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> projectData, [bool isHighlighted = false]) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isHighlighted ? BorderSide(
            color: projectData['color'],
            width: 3,
          ) : BorderSide.none,
        ),
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
    ));
  }

  void _scrollToProject(String projectTitle) {
    final filteredProjects = _selectedCategory == 'Todos'
        ? projects
        : projects.where((p) => p['category'] == _selectedCategory).toList();
    
    final projectIndex = filteredProjects.indexWhere((p) => p['title'] == projectTitle);
    
    if (projectIndex != -1) {
      // Calcula a posição aproximada do projeto no grid
      final row = projectIndex ~/ 2; // 2 colunas por linha
      final itemHeight = 200.0; // Altura aproximada de cada item
      final spacing = 16.0;
      final padding = 16.0; // Padding do GridView
      
      // Calcula a posição do card
      final cardPosition = row * (itemHeight + spacing) + padding + 500;
      
      // Calcula a altura visível da tela (descontando app bar e filtros)
      final screenHeight = MediaQuery.of(context).size.height;
      final appBarHeight = 120.0; // Altura aproximada do app bar
      final filterHeight = 60.0; // Altura aproximada do filtro
      final visibleHeight = screenHeight - appBarHeight - filterHeight;
      
      // Calcula o offset para centralizar o card
      final targetOffset = cardPosition - (visibleHeight / 2) + (itemHeight / 2);
      
      _scrollController.animateTo(
        targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
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

  Widget _buildQuestionnaireCard() {
    return Material(
      color: AppColors.black,
      child: InkWell(
        onTap: () => _navigateToQuestionnaire(),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Encontre seu Projeto Ideal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: AppColors.darkOrange,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToQuestionnaire() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const QuestionnaireIntroScreen(),
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
  }
}
