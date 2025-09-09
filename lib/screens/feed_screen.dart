import 'package:eurohive/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'create_post_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final List<String> _posts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        title: const Text('Feed'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCreatePostSection(),
          Expanded(
            child: _buildPostsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.blue,
        foregroundColor: AppColors.white,
        onPressed: () async {
          final newPost = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreatePostScreen(),
            ),
          );

          if (newPost != null && newPost.isNotEmpty) {
            setState(() {
              _posts.insert(0, newPost);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCreatePostSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.blue,
            child: Icon(
              Icons.person,
              color: AppColors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final newPost = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreatePostScreen(),
                  ),
                );

                if (newPost != null && newPost.isNotEmpty) {
                  setState(() {
                    _posts.insert(0, newPost);
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Text(
                  'O que você está pensando?',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _posts.length + 10,
      itemBuilder: (context, index) {
        if (index < _posts.length) {
          return _buildCustomPostCard(_posts[index]);
        } else {
          return _buildPostCard(index - _posts.length);
        }
      },
    );
  }

Widget _buildCustomPostCard(String content) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    child: Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: AppColors.lightGray,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppColors.blue,
                  child: Icon(Icons.person, color: AppColors.white),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Você",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_horiz),
                  onSelected: (value) {
                    if (value == 'excluir') {
                      // Remove o post da lista
                      setState(() {
                        _posts.remove(content);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Post excluído")),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'excluir',
                      child: Text("Excluir post"),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildPostCard(int index) {
  bool isMyPost = index == 0;

  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    child: Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: AppColors.lightGray,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.blue,
                  child: Text(
                    'U${index + 1}',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Usuário ${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '@usuario${index + 1} • ${_getRandomTime(index)}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_horiz),
                  onSelected: (value) {
                    if (value == 'excluir') {
                      // Excluir post
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Post excluído")),
                      );
                    } else if (value == 'nao_interessa') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Esse post não será mostrado com frequência")),
                      );
                    } else if (value == 'ocultar') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Você não verá mais posts assim")),
                      );
                    }
                  },
                  itemBuilder: (context) {
                    if (isMyPost) {
                      return [
                        const PopupMenuItem(
                          value: 'excluir',
                          child: Text("Excluir post"),
                        ),
                      ];
                    } else {
                      return [
                        const PopupMenuItem(
                          value: 'nao_interessa',
                          child: Text("Esse post não me interessa"),
                        ),
                        const PopupMenuItem(
                          value: 'ocultar',
                          child: Text("Não quero mais ver posts assim"),
                        ),
                      ];
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _getRandomPostContent(index),
              style: const TextStyle(fontSize: 16),
            ),
            if (index % 3 == 0) ...[
              const SizedBox(height: 12),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.lightBlue.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(
                    Icons.image,
                    size: 48,
                    color: AppColors.blue,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: '${(index + 1) * 3}',
                  onPressed: () {},
                ),
                _buildActionButton(
                  icon: Icons.repeat,
                  label: '${(index + 1) * 2}',
                  onPressed: () {},
                ),
                _buildActionButton(
                  icon: Icons.favorite_border,
                  label: '${(index + 1) * 5}',
                  onPressed: () {},
                ),
                _buildActionButton(
                  icon: Icons.share,
                  label: '',
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: Colors.grey[600],
            ),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getRandomTime(int index) {
    final times = ['2h', '5h', '1d', '3d', '1w'];
    return times[index % times.length];
  }

  String _getRandomPostContent(int index) {
    final contents = [
      'Acabei de finalizar um novo projeto! 🚀',
      'Dica de hoje: sempre teste seu código antes de fazer deploy!',
      'Alguém mais está participando do hackathon?',
      'Flutter é realmente incrível para desenvolvimento mobile!',
      'Novas tecnologias surgindo todos os dias...',
      'Compartilhando minha experiência com desenvolvimento web',
      'Quem mais está estudando novas linguagens de programação?',
      'O futuro da tecnologia está nas nossas mãos! 💻',
      'Dica: sempre documente seu código!',
      'Networking é fundamental na área de tecnologia',
    ];
    return contents[index % contents.length];
  }
}
