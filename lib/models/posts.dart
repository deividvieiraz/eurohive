import 'package:eurohive/core/constants/app_assets.dart';

class Post {
  final String author;
  final String username;
  final String time;
  final String title;
  final String content;
  final String imagePath;
  final int likes;
  final int comments;
  final int shares;

  Post({
    required this.author,
    required this.username,
    required this.time,
    required this.title,
    required this.content,
    required this.imagePath,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
  });
}

final List<Post> demoPosts = [
  Post(
    author: 'Deivid Moura',
    username: '@deividvieiraz',
    time: '2h',
    title: 'Nova Unidade em Goiás',
    content: 'Expansão fortalece nossa produção e geração de empregos.',
    imagePath: AppAssets.news1,
    likes: 12,
    comments: 3,
    shares: 2,
  ),
  Post(
    author: 'João Marcelo',
    username: '@joaomarcelo',
    time: '5h',
    title: 'Eurofarma Sustentável',
    content: 'Projeto reduz impacto ambiental com energia renovável.',
    imagePath: AppAssets.news2,
    likes: 8,
    comments: 1,
    shares: 1,
  ),
  Post(
    author: 'Vinicius Talhiaferro',
    username: '@vinivt',
    time: '1d',
    title: 'Pesquisa Inovadora',
    content: 'Estudo pioneiro avança no tratamento de doenças crônicas.',
    imagePath: AppAssets.news3,
    likes: 15,
    comments: 4,
    shares: 3,
  ),
  Post(
    author: 'Bruno Sena',
    username: '@bsena',
    time: '3d',
    title: 'Reconhecimento Global',
    content: 'Eurofarma é destaque em ranking internacional da saúde.',
    imagePath: AppAssets.news4,
    likes: 20,
    comments: 5,
    shares: 4,
  ),
  Post(
    author: 'Eduardo Paludetto',
    username: '@eduardopaludetto',
    time: '1w',
    title: 'Ações Sociais',
    content: 'Iniciativas apoiam educação e saúde em comunidades carentes.',
    imagePath: AppAssets.news5,
    likes: 10,
    comments: 2,
    shares: 1,
  ),
  Post(
    author: 'Gustavo Duarte',
    username: '@gustavo.duarte',
    time: '2w',
    title: 'Treinamento Online',
    content: 'Novo portal de cursos para desenvolvimento profissional contínuo.',
    imagePath: AppAssets.news6,
    likes: 7,
    comments: 1,
    shares: 1,
  ),
];
