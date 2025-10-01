import 'package:eurohive/core/constants/app_assets.dart';
import 'package:eurohive/core/constants/app_colors.dart';
import 'package:eurohive/models/ranking_user.dart';
import 'package:eurohive/services/auth_service.dart';
import 'package:flutter/material.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  String? currentUserEmail;
  List<RankingUser> rankingUsers = [];

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadRankingData();
  }

  Future<void> _loadCurrentUser() async {
    final email = await AuthService.getUserEmail();
    setState(() {
      currentUserEmail = email;
    });
  }

  void _loadRankingData() {
    // Dados mockados para o ranking
    final mockUsers = [
      RankingUser(
        id: '1',
        name: 'Maria Santos',
        email: 'maria.santos@eurohive.com',
        avatarPath: AppAssets.p2Foto,
        posts: 45,
        ideas: 12,
        likes: 234,
        comments: 89,
        totalScore: 1250,
        position: 1,
      ),
      RankingUser(
        id: '2',
        name: 'Carlos Oliveira',
        email: 'carlos.oliveira@eurohive.com',
        avatarPath: AppAssets.p1Foto,
        posts: 38,
        ideas: 15,
        likes: 198,
        comments: 67,
        totalScore: 1180,
        position: 2,
      ),
      RankingUser(
        id: '3',
        name: 'Ana Costa',
        email: 'ana.costa@eurohive.com',
        avatarPath: AppAssets.p6Foto,
        posts: 42,
        ideas: 8,
        likes: 187,
        comments: 72,
        totalScore: 1120,
        position: 3,
      ),
      RankingUser(
        id: '4',
        name: 'João Silva',
        email: 'joao@eurohive.com',
        avatarPath: AppAssets.joaoFoto,
        posts: 28,
        ideas: 6,
        likes: 145,
        comments: 45,
        totalScore: 890,
        position: 4,
      ),
      RankingUser(
        id: '5',
        name: 'Pedro Ferreira',
        email: 'pedro.ferreira@eurohive.com',
        avatarPath: AppAssets.p4Foto,
        posts: 35,
        ideas: 9,
        likes: 156,
        comments: 58,
        totalScore: 875,
        position: 5,
      ),
      RankingUser(
        id: '6',
        name: 'Lucia Mendes',
        email: 'lucia.mendes@eurohive.com',
        avatarPath: AppAssets.p5Foto,
        posts: 31,
        ideas: 7,
        likes: 134,
        comments: 52,
        totalScore: 820,
        position: 6,
      ),
      RankingUser(
        id: '7',
        name: 'Rafael Lima',
        email: 'rafael.lima@eurohive.com',
        avatarPath: AppAssets.p3Foto,
        posts: 29,
        ideas: 5,
        likes: 128,
        comments: 41,
        totalScore: 780,
        position: 7,
      ),
      RankingUser(
        id: '8',
        name: 'Fernanda Alves',
        email: 'fernanda.alves@eurohive.com',
        avatarPath: AppAssets.p7Foto,
        posts: 26,
        ideas: 4,
        likes: 115,
        comments: 38,
        totalScore: 720,
        position: 8,
      ),
      RankingUser(
        id: '9',
        name: 'Bruna Rodrigues',
        email: 'bruna.rodrigues@eurohive.com',
        avatarPath: AppAssets.p8Foto,
        posts: 24,
        ideas: 3,
        likes: 98,
        comments: 35,
        totalScore: 680,
        position: 9,
      ),
      RankingUser(
        id: '10',
        name: 'Pedro Souza',
        email: 'pedro.souza@eurohive.com',
        avatarPath: AppAssets.p9Foto,
        posts: 22,
        ideas: 2,
        likes: 87,
        comments: 29,
        totalScore: 640,
        position: 10,
      ),
    ];

    setState(() {
      rankingUsers = mockUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildRankingList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.white,
                  size: 28,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Text(
                  'Ranking de Colaboradores',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48), // Para centralizar o título
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.emoji_events,
                  color: Colors.amber,
                  size: 32,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Top Colaboradores',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        'Ranking baseado em posts, ideias e engajamento',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankingList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: rankingUsers.length,
      itemBuilder: (context, index) {
        final user = rankingUsers[index];
        final isCurrentUser = currentUserEmail == user.email;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isCurrentUser ? AppColors.blue.withValues(alpha: 0.1) : AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: isCurrentUser 
                ? Border.all(color: AppColors.blue, width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(user.avatarPath),
                ),
                if (user.position <= 3)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: _getPositionColor(user.position),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          '${user.position}',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    user.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isCurrentUser ? AppColors.blue : AppColors.black,
                    ),
                  ),
                ),
                if (isCurrentUser)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'VOCÊ',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildStatChip(Icons.article, '${user.posts}'),
                    const SizedBox(width: 8),
                    _buildStatChip(Icons.lightbulb, '${user.ideas}'),
                    const SizedBox(width: 8),
                    _buildStatChip(Icons.favorite, '${user.likes}'),
                    const SizedBox(width: 8),
                    _buildStatChip(Icons.comment, '${user.comments}'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Posição #${user.position}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isCurrentUser ? AppColors.blue : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getPositionColor(user.position),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${user.totalScore} pts',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatChip(IconData icon, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey[600]),
          const SizedBox(width: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPositionColor(int position) {
    switch (position) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey[400]!;
      case 3:
        return const Color.fromARGB(255, 187, 126, 35);
      default:
        return AppColors.blue;
    }
  }
}
