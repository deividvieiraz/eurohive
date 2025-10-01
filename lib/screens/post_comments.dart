import 'package:eurohive/core/constants/app_assets.dart';
import 'package:eurohive/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/posts.dart';

class PostCommentsScreen extends StatefulWidget {
  final Post post;

  const PostCommentsScreen({super.key, required this.post});

  @override
  State<PostCommentsScreen> createState() => _PostCommentsScreenState();
}

class _PostCommentsScreenState extends State<PostCommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _comments = [
    {
      "author": "Fernando Lacerda",
      "avatarType": "asset",
      "avatar": AppAssets.p1Foto,
      "time": "2h",
      "text": "Muito bom esse conteúdo! 👏",
    },
    {
      "author": "Maria Oliveira",
      "avatarType": "asset",
      "avatar": AppAssets.p2Foto,
      "time": "1h",
      "text": "Concordo totalmente, faz muito sentido.",
    },
    {
      "author": "Carlos Mendes",
      "avatarType": "asset",
      "avatar": AppAssets.p3Foto,
      "time": "45m",
      "text": "Alguém poderia compartilhar mais detalhes sobre esse tema?",
    },
    {
      "author": "Ana Costa",
      "avatarType": "asset",
      "avatar": AppAssets.p5Foto,
      "time": "10m",
      "text": "Parabéns pelo post, ficou excelente! 🚀",
    },
  ];

  void _addComment(String comment) {
    if (comment.trim().isEmpty) return;
    
    // Fechar o teclado
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusScope.of(context).unfocus();
    
    setState(() {
      // Selecionar uma foto e nome aleatórios para o novo comentário
      _comments.insert(0, {
        "author": "João Silva",
        "avatarType": "asset",
        "avatar": AppAssets.joaoFoto,
        "time": "Agora",
        "text": comment.trim(),
      });
      _commentController.clear();
    });
    
    // Fazer scroll para o topo para mostrar o novo comentário
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.black,
        title: const Text('Comentários'),
      ),
      body: Stack(
        children: [
          // Tela inteira com scroll
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              children: [
                // Card do post original
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header do post
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: post.profileImage != null
                                ? (post.profileImage!.startsWith("http")
                                      ? NetworkImage(post.profileImage!)
                                      : AssetImage(post.profileImage!)
                                            as ImageProvider)
                                : null,
                            backgroundColor: AppColors.blue,
                            child: post.profileImage == null
                                ? Text(
                                    post.author.substring(0, 1),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.author,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                post.username,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(post.content, style: const TextStyle(fontSize: 15)),
                      if (post.imagePath != null && post.imagePath!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              post.imagePath!,
                              width: double.infinity,
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Lista de comentários
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  itemCount: _comments.length,
                  itemBuilder: (context, index) {
                    final c = _comments[index];
                    return _buildCommentCard(
                      c["author"],
                      c["avatarType"],
                      c["avatar"],
                      c["color"],
                      c["time"],
                      c["text"],
                    );
                  },
                ),
              ],
            ),
          ),

          // Campo de novo comentário fixo na parte inferior
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage(AppAssets.joaoFoto),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      minLines: 1,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Escreva um comentário...',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: _addComment,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () => _addComment(_commentController.text),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentCard(
    String author,
    String avatarType,
    dynamic avatar,
    Color? color,
    String time,
    String text,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sempre usar foto real
          CircleAvatar(
            radius: 18, 
            backgroundImage: AssetImage(avatar),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        author,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(text, style: const TextStyle(fontSize: 15, height: 1.4)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
