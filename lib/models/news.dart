import 'package:eurohive/core/constants/app_assets.dart';

class News {
  final String title;
  final String description;
  final String imagePath;
  final String details;

  News({required this.title, required this.description, required this.imagePath, required this.details});
}

final List<News> newsList = [
  News(
    title: 'Nova Unidade em Goiás',
    description: 'Expansão fortalece nossa produção e geração de empregos.',
    imagePath: AppAssets.news1,
    details: 'A Eurofarma inaugurou uma nova unidade em Goiás, ampliando sua capacidade de produção em 30%. '
        'O projeto vai gerar mais de 500 novos empregos diretos e indiretos na região, fortalecendo a economia local. '
        'A unidade conta com tecnologia de ponta e segue padrões de sustentabilidade.',
  ),
  News(
    title: 'Eurofarma Sustentável',
    description: 'Projeto reduz impacto ambiental com energia renovável.',
    imagePath: AppAssets.news2,
    details: 'Dentro do programa Eurofarma Sustentável, a empresa passou a utilizar energia 100% renovável '
        'em suas principais plantas fabris. Isso representa uma redução de 40% nas emissões de carbono. '
        'Além disso, novos projetos de reciclagem e economia de água já estão em andamento.',
  ),
  News(
    title: 'Pesquisa Inovadora',
    description: 'Estudo pioneiro avança no tratamento de doenças crônicas',
    imagePath: AppAssets.news3,
    details: 'Pesquisadores da Eurofarma desenvolveram um estudo pioneiro focado em terapias para doenças crônicas. '
        'O projeto envolve mais de 200 especialistas e já apresenta resultados promissores em testes clínicos. '
        'O objetivo é oferecer tratamentos mais eficazes e acessíveis.',
  ),
  News(
    title: 'Reconhecimento Global',
    description: 'Eurofarma é destaque em ranking internacional da saúde.',
    imagePath: AppAssets.news4,
    details: 'A Eurofarma foi reconhecida no ranking Global Healthcare 2025 como uma das 50 empresas mais inovadoras '
        'do setor de saúde. O destaque foi dado às iniciativas de pesquisa, sustentabilidade e impacto social.',
  ),
  News(
    title: 'Ações Sociais',
    description: 'Iniciativas apoiam educação e saúde em comunidades carentes.',
    imagePath: AppAssets.news5,
    details: 'Com foco em responsabilidade social, a Eurofarma ampliou seus projetos de apoio à educação básica '
        'e à saúde em comunidades carentes. Mais de 10 mil pessoas já foram beneficiadas em 2025 '
        'com programas de reforço escolar e atendimento médico gratuito.',
  ),
  News(
    title: 'Treinamento Online',
    description: 'Novo portal de cursos para desenvolvimento profissional contínuo..',
    imagePath: AppAssets.news6,
    details: 'Foi lançado o Eurofarma Academy, um portal online com mais de 150 cursos gratuitos para colaboradores. '
        'O objetivo é fomentar o aprendizado contínuo em áreas como liderança, inovação e tecnologia. '
        'A iniciativa já conta com mais de 8 mil usuários cadastrados.',
  ),
];
