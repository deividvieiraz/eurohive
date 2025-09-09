import 'package:eurohive/core/constants/app_colors.dart';
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
    'Mobile',
    'Web',
    'AI/ML',
    'Blockchain',
    'IoT',
    'Gaming',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.blue,
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
      itemCount: 12,
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
        'title': 'App de Finanças',
        'description': 'Aplicativo para controle financeiro pessoal com IA',
        'category': 'Mobile',
        'icon': Icons.account_balance_wallet,
        'color': AppColors.blue,
        'rating': '4.8',
        'likes': '234',
      },
      {
        'title': 'E-commerce Web',
        'description': 'Plataforma completa de e-commerce moderna',
        'category': 'Web',
        'icon': Icons.shopping_cart,
        'color': AppColors.lightBlue,
        'rating': '4.6',
        'likes': '189',
      },
      {
        'title': 'Chatbot IA',
        'description': 'Chatbot inteligente para atendimento ao cliente',
        'category': 'AI/ML',
        'icon': Icons.smart_toy,
        'color': Colors.purple,
        'rating': '4.9',
        'likes': '456',
      },
      {
        'title': 'Crypto Wallet',
        'description': 'Carteira digital para criptomoedas',
        'category': 'Blockchain',
        'icon': Icons.currency_bitcoin,
        'color': Colors.orange,
        'rating': '4.7',
        'likes': '312',
      },
      {
        'title': 'Smart Home App',
        'description': 'Controle de dispositivos IoT para casa inteligente',
        'category': 'IoT',
        'icon': Icons.home,
        'color': Colors.green,
        'rating': '4.5',
        'likes': '178',
      },
      {
        'title': 'Mobile Game',
        'description': 'Jogo mobile com gráficos 3D impressionantes',
        'category': 'Gaming',
        'icon': Icons.games,
        'color': Colors.red,
        'rating': '4.4',
        'likes': '567',
      },
      {
        'title': 'Task Manager',
        'description': 'Gerenciador de tarefas com colaboração em tempo real',
        'category': 'Web',
        'icon': Icons.task_alt,
        'color': AppColors.blue,
        'rating': '4.6',
        'likes': '245',
      },
      {
        'title': 'Fitness Tracker',
        'description': 'App para rastreamento de atividades físicas',
        'category': 'Mobile',
        'icon': Icons.fitness_center,
        'color': AppColors.lightBlue,
        'rating': '4.7',
        'likes': '398',
      },
      {
        'title': 'ML Dashboard',
        'description': 'Dashboard para visualização de dados de ML',
        'category': 'AI/ML',
        'icon': Icons.analytics,
        'color': Colors.purple,
        'rating': '4.8',
        'likes': '289',
      },
      {
        'title': 'NFT Marketplace',
        'description': 'Plataforma para compra e venda de NFTs',
        'category': 'Blockchain',
        'icon': Icons.collections,
        'color': Colors.orange,
        'rating': '4.5',
        'likes': '423',
      },
      {
        'title': 'Weather Station',
        'description': 'Estação meteorológica conectada via IoT',
        'category': 'IoT',
        'icon': Icons.wb_sunny,
        'color': Colors.green,
        'rating': '4.3',
        'likes': '156',
      },
      {
        'title': 'AR Puzzle Game',
        'description': 'Jogo de quebra-cabeça com realidade aumentada',
        'category': 'Gaming',
        'icon': Icons.view_in_ar,
        'color': Colors.red,
        'rating': '4.6',
        'likes': '334',
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
                        // Implementar aplicação no projeto
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Aplicação enviada com sucesso!'),
                            backgroundColor: AppColors.blue,
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
