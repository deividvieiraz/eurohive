import 'package:eurohive/core/constants/app_assets.dart';

class Post {
  final String author;
  final String username;
  final String time;
  final String content;
  final String? imagePath;
  final String? profileImage; 
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
     this.profileImage, 
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
    profileImage: AppAssets.p1Foto,
    likes: 12,
    comments: 4,
    shares: 2,
  ),
  Post(
    author: 'João Marcelo',
    username: '@joaomarcelo',
    time: '5h',
    content: 'Projeto reduz impacto ambiental com energia renovável.',
    profileImage: AppAssets.p3Foto,
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
    profileImage: AppAssets.p12Foto,
    likes: 20,
    comments: 4,
    shares: 3,
  ),
  Post(
    author: 'Bruno Sena',
    username: '@bsena',
    time: '3d',
    content: 'Eurofarma é destaque em ranking internacional da saúde.',
    profileImage: AppAssets.p4Foto,
    likes: 20,
    comments: 5,
    shares: 4,
  ),
  Post(
    author: 'Mariana Costa',
    username: '@maricosta',
    time: '4d',
    content: 'Novo centro de pesquisas impulsiona inovação farmacêutica.',
    profileImage: AppAssets.p2Foto,
    likes: 15,
    comments: 3,
    shares: 2,
  ),
  Post(
    author: 'Ricardo Alves',
    username: '@ralves',
    time: '5d',
    content: 'Parceria estratégica amplia acesso a medicamentos essenciais.',
    profileImage: AppAssets.p11Foto,
    likes: 10,
    comments: 2,
    shares: 1,
  ),
  Post(
    author: 'Fernanda Lima',
    username: '@flima',
    time: '1w',
    content: 'Iniciativa social leva atendimento médico a comunidades.',
    profileImage: AppAssets.p5Foto,
    imagePath: AppAssets.news5,
    likes: 25,
    comments: 6,
    shares: 5,
  ),
  Post(
    author: 'Lucas Pereira',
    username: '@lucpereira',
    time: '2w',
    content: 'Tecnologia 4.0 moderniza linhas de produção.',
    profileImage: AppAssets.p10Foto,
    likes: 18,
    comments: 3,
    shares: 2,
  ),
  Post(
    author: 'Carla Mendes',
    username: '@carlamendes',
    time: '3w',
    content: 'Treinamento profissional qualifica jovens para o futuro.',
    imagePath: AppAssets.news6,
    profileImage: AppAssets.p6Foto,
    likes: 22,
    comments: 7,
    shares: 4,
  ),
  Post(
    author: 'Paulo Henrique',
    username: '@paulohenrique',
    time: '1mo',
    content: 'Laboratório recebe certificação internacional de qualidade.',
    profileImage: AppAssets.p9Foto,
    likes: 30,
    comments: 8,
    shares: 6,
  ),
  Post(
    author: 'Juliana Rocha',
    username: '@jurocha',
    time: '1mo',
    content: 'Campanha de vacinação beneficiou milhares de pessoas.',
    profileImage: AppAssets.p7Foto,
    imagePath: AppAssets.news2,
    likes: 40,
    comments: 12,
    shares: 9,
  ),
  Post(
    author: 'André Santos',
    username: '@asantos',
    time: '2mo',
    content: 'Pesquisa clínica aprova novos medicamentos promissores.',
    profileImage: AppAssets.p1Foto,
    likes: 27,
    comments: 5,
    shares: 3,
  ),
  Post(
    author: 'Tatiane Moreira',
    username: '@tatimoreira',
    time: '2mo',
    content: 'Conferência internacional discute avanços em biotecnologia.',
    profileImage: AppAssets.p8Foto,
    likes: 19,
    comments: 4,
    shares: 2,
  ),
  Post(
    author: 'Gustavo Oliveira',
    username: '@gusoliveira',
    time: '3mo',
    content: 'Nova planta fabril começa a operar com energia 100% limpa.',
    profileImage: AppAssets.p10Foto,
    likes: 35,
    comments: 9,
    shares: 7,
  ),
  Post(
    author: 'Patrícia Souza',
    username: '@patisouza',
    time: '3mo',
    content: 'Programa de estágio abre oportunidades em diversas áreas.',
    profileImage: AppAssets.p6Foto,
    likes: 28,
    comments: 10,
    shares: 5,
  ),
];


