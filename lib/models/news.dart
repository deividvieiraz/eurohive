import 'package:eurohive/core/constants/app_assets.dart';

class News {
  final String title;
  final String description;
  final String imagePath;

  News({required this.title, required this.description, required this.imagePath});
}

final List<News> newsList = [
  News(
    title: 'Nova Unidade em Goiás',
    description: 'Expansão fortalece nossa produção e geração de empregos.',
    imagePath: AppAssets.news1
  ),
  News(
    title: 'Eurofarma Sustentável',
    description: 'Projeto reduz impacto ambiental com energia renovável.',
    imagePath: AppAssets.news2
  ),
  News(
    title: 'Pesquisa Inovadora',
    description: 'Estudo pioneiro avança no tratamento de doenças crônicas',
    imagePath: AppAssets.news3
  ),
  News(
    title: 'Reconhecimento Global',
    description: 'Eurofarma é destaque em ranking internacional da saúde.',
    imagePath: AppAssets.news4
  ),
  News(
    title: 'Ações Sociais',
    description: 'Iniciativas apoiam educação e saúde em comunidades carentes.',
    imagePath: AppAssets.news5
  ),
  News(
    title: 'Treinamento Online',
    description: 'Novo portal de cursos para desenvolvimento profissional contínuo..',
    imagePath: AppAssets.news6
  )
];