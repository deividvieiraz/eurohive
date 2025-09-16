import 'package:eurohive/core/constants/app_assets.dart';
import 'package:eurohive/core/constants/app_colors.dart';
import 'package:eurohive/models/posts.dart';
import 'package:flutter/material.dart';
import 'create_post_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final List<Post> _posts = demoPosts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildAppBar(),
          _buildCreatePostSection(),
          Expanded(child: _buildPostsList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.blue,
        foregroundColor: AppColors.white,
        onPressed: () async {
          final newPost = await Navigator.push<Post>(
            context,
            MaterialPageRoute(builder: (context) => const CreatePostScreen()),
          );

          if (newPost != null) {
            setState(() {
              _posts.insert(0, newPost);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 160,
      decoration: const BoxDecoration(color: AppColors.black),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.menu,
                        color: AppColors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: AppColors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ],
                ),
                Image.asset(AppAssets.eurohiveName, height: 25),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Recentes',
                      style: TextStyle(color: AppColors.white, fontSize: 18),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Trending',
                      style: TextStyle(color: AppColors.white, fontSize: 18),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Seguindo',
                      style: TextStyle(color: AppColors.white, fontSize: 18),
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

  Widget _buildCreatePostSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(25),
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
            child: Icon(Icons.person, color: AppColors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final newPost = await Navigator.push<Post>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreatePostScreen(),
                  ),
                );

                if (newPost != null) {
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
                  style: TextStyle(color: Colors.grey, fontSize: 16),
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
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        return _buildPostCard(post);
      },
    );
  }

Widget _buildPostCard(Post post) {
  final bool isMyPost = post.author == "Você";

  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    child: Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    post.author.substring(0, 1),
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
                        post.author,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${post.username} • ${post.time}',
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
                    if (value == 'excluir' && isMyPost) {
                      setState(() {
                        _posts.remove(post);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Post excluído")),
                      );
                    } else if (value == 'nao_interessa') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Esse post não será mostrado com frequência",
                          ),
                        ),
                      );
                    } else if (value == 'ocultar') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Você não verá mais posts assim"),
                        ),
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
              post.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(post.content, style: const TextStyle(fontSize: 16)),
            if (post.imagePath.isNotEmpty) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  post.imagePath,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: '${post.comments}',
                  onPressed: () {},
                ),
                _buildActionButton(
                  icon: Icons.repeat,
                  label: '${post.shares}',
                  onPressed: () {},
                ),
                _buildActionButton(
                  icon: Icons.favorite_border,
                  label: '${post.likes}',
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
            Icon(icon, size: 20, color: Colors.grey[600]),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
