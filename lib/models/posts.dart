import 'package:eurohive/core/constants/app_assets.dart';

class Post {
  final String author;
  final String username;
  final String time;
  final String content;
  final String? imagePath;
  int likes;
  int comments;
  int shares;
  bool isLiked;
  bool isShared;

  Post({
    required this.author,
    required this.username,
    required this.time,
    required this.content,
    this.imagePath,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.isLiked = false,
    this.isShared = false,
  });
}

final List<Post> demoPosts = [
  Post(
    author: 'Deivid Moura',
    username: '@deividvieiraz',
    time: '2h',
    content: 'Expansão fortalece nossa produção e geração de empregos.',
    imagePath: AppAssets.news1,
    likes: 12,
    comments: 4,
    shares: 2,
  ),
  Post(
    author: 'João Marcelo',
    username: '@joaomarcelo',
    time: '5h',
    content: 'Projeto reduz impacto ambiental com energia renovável.',
    likes: 8,
    comments: 1,
    shares: 1,
  ),
  Post(
    author: 'Vinicius Talhiaferro',
    username: '@vinivt',
    time: '1d',
    content: 'Estudo pioneiro avança no tratamento de doenças crônicas.',
    imagePath: AppAssets.news3,
    likes: 20,
    comments: 4,
    shares: 3,
  ),
  Post(
    author: 'Bruno Sena',
    username: '@bsena',
    time: '3d',
    content: 'Eurofarma é destaque em ranking internacional da saúde.',
    likes: 20,
    comments: 5,
    shares: 4,
  ),
];

