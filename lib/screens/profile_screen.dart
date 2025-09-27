import 'package:eurohive/core/constants/app_assets.dart';
import 'package:eurohive/core/constants/app_colors.dart';
import 'package:eurohive/models/user_application.dart';
import 'package:eurohive/services/user_application_service.dart';
import 'package:eurohive/routes/app_routes.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "João Silva";
  String email = "joao.silva@eurohive.com";
  String role = "Desenvolvedor Sênior";

  final UserApplicationService _applicationService = UserApplicationService();
  List<UserApplication> _applications = [];
  Map<String, int> _stats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    try {
      final applications = await _applicationService.getUserApplications();
      final stats = await _applicationService.getApplicationStats();

      setState(() {
        _applications = applications;
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildProfileHeader(),
                _buildStatsSection(),
                _buildProjectsSection(),
                _buildLikedProjectsSection(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 150,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.black,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: AppColors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end, // joga pro fundo
            children: const [
              SizedBox(height: 15), // controla a distância do topo
              Text(
                'Perfil',
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 40), // empurra mais pra baixo se quiser
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_square, color: AppColors.white),
          onPressed: () {
            _showEditProfileDialog();
          },
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: AppColors.blue.withValues(alpha: 0.1),
            backgroundImage: AssetImage(AppAssets.joaoFoto),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(email, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              role,
              style: const TextStyle(
                color: AppColors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildStatItem(
            'Projetos\nAplicados',
            '${_stats['total'] ?? 0}',
            Icons.assignment_turned_in,
          ),
          _buildStatDivider(),
          _buildStatItem(
            'Projetos\nAprovados',
            '${_stats['approved'] ?? 0}',
            Icons.check_circle,
          ),
          _buildStatDivider(),
          _buildStatItem('Curtidas\nRecebidas', '156', Icons.favorite),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.blue, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 50,
      width: 1,
      color: Colors.grey.withValues(alpha: 0.3),
    );
  }

  Widget _buildProjectsSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Projetos Aplicados',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_applications.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: const Center(
                child: Text(
                  'Nenhuma aplicação encontrada.\nAplique para um projeto para vê-lo aqui!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            )
          else
            ..._applications.reversed.map((application) {
              return Column(
                children: [
                  _buildApplicationCard(application),
                  const SizedBox(height: 12),
                ],
              );
            }),
        ],
      ),
    );
  }

  Widget _buildApplicationCard(UserApplication application) {
    final statusColor = _getStatusColor(application.status);
    final statusIcon = _getStatusIcon(application.status);

    return GestureDetector(
      onTap: () => _navigateToApplicationDetails(application),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(statusIcon, color: statusColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    application.projectName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    application.description,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Prot: ${application.protocolNumber.split('-').last}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: Text(
                          _formatDate(application.submittedAt),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                application.status.displayName,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.submitted:
        return Colors.blue;
      case ApplicationStatus.underReview:
        return Colors.orange;
      case ApplicationStatus.approved:
        return Colors.green;
      case ApplicationStatus.rejected:
        return Colors.red;
      case ApplicationStatus.inProgress:
        return Colors.purple;
      case ApplicationStatus.completed:
        return Colors.teal;
    }
  }

  IconData _getStatusIcon(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.submitted:
        return Icons.send;
      case ApplicationStatus.underReview:
        return Icons.search;
      case ApplicationStatus.approved:
        return Icons.check_circle;
      case ApplicationStatus.rejected:
        return Icons.cancel;
      case ApplicationStatus.inProgress:
        return Icons.play_circle;
      case ApplicationStatus.completed:
        return Icons.done_all;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Hoje';
    } else if (difference == 1) {
      return 'Ontem';
    } else if (difference < 7) {
      return '$difference dias atrás';
    } else if (difference < 30) {
      final weeks = (difference / 7).floor();
      return '$weeks semana${weeks > 1 ? 's' : ''} atrás';
    } else {
      final months = (difference / 30).floor();
      return '$months mês${months > 1 ? 'es' : ''} atrás';
    }
  }

  void _navigateToApplicationDetails(UserApplication application) {
    Navigator.pushNamed(
      context,
      AppRoutes.applicationDetails,
      arguments: application,
    );
  }

  Widget _buildLikedProjectsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Projetos Curtidos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                final projects = [
                  {
                    'title': 'Hackathon',
                    'color': AppColors.cyan,
                    'icon': Icons.event,
                  },
                  {
                    'title': 'Challenge',
                    'color': AppColors.cyan,
                    'icon': Icons.psychology,
                  },
                  {
                    'title': 'Imersões',
                    'color': AppColors.pink,
                    'icon': Icons.school,
                  },
                  {
                    'title': 'Multiplicadores',
                    'color': AppColors.pink,
                    'icon': Icons.share,
                  },
                  {
                    'title': 'Euron Hub',
                    'color': AppColors.pink,
                    'icon': Icons.hub,
                  },
                ];

                final project = projects[index];

                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: (project['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (project['color'] as Color).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        project['icon'] as IconData,
                        color: project['color'] as Color,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        project['title'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: project['color'] as Color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: name);
    final emailController = TextEditingController(text: email);
    final roleController = TextEditingController(text: role);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Editar Perfil"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nome"),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: roleController,
                decoration: const InputDecoration(labelText: "Cargo"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue),
            onPressed: () {
              setState(() {
                name = nameController.text;
                email = emailController.text;
                role = roleController.text;
              });
              Navigator.pop(context);
            },
            child: const Text(
              "Salvar",
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
