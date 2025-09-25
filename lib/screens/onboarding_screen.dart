import 'package:eurohive/core/constants/app_assets.dart';
import 'package:eurohive/core/constants/app_colors.dart';
import 'package:eurohive/routes/app_routes.dart';
import 'package:eurohive/services/onboarding_service.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: "Bem-vindo ao EuroHive 🚀",
      description:
          "Um espaço feito para você explorar, participar e transformar a inovação dentro da Eurofarma.",
      imagePath: AppAssets.onBoard1,
    ),
    OnboardingPage(
      title: "Conheça os Projetos",
      description:
          "Explore iniciativas de inovação, entenda seus objetivos e encontre onde sua ideia pode gerar impacto.",
      imagePath: AppAssets.onBoard2,
    ),
    OnboardingPage(
      title: "Sua voz importa",
      description:
          "Envie suas ideias de forma simples, com ajuda de inteligência artificial ou até mesmo por áudio.",
      imagePath: AppAssets.onBoard3,
    ),
    OnboardingPage(
      title: "Colabore e Inspire",
      description:
          "Troque experiências no Feed, acompanhe novidades e faça parte da cultura de inovação da Eurofarma.",
      imagePath: AppAssets.onBoard4,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() async {
    await OnboardingService.markOnboardingAsSeen();
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  void _finishOnboarding() async {
    await OnboardingService.markOnboardingAsSeen();
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Botão Pular
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _skipOnboarding,
                  child: Text(
                    'Pular',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            // Conteúdo do carrossel
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),

            // Indicador de progresso
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.blue
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            // Botão de navegação simplificado
            Padding(
              padding: const EdgeInsets.only(bottom: 40, left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Espaço vazio para manter o botão centralizado
                  const SizedBox(width: 50),

                  // Botão de navegação centralizado
                  GestureDetector(
                    onTap: _currentPage == _pages.length - 1
                        ? _finishOnboarding
                        : _nextPage,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.blue,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.blue.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(
                        _currentPage == _pages.length - 1
                            ? Icons.check
                            : Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),

                  // Espaço vazio para manter o botão centralizado
                  const SizedBox(width: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Espaço para imagem no centro
          Image.asset(
            page.imagePath,
            width: 300,
            height: 300,
            fit: BoxFit.cover,
          ),

          const SizedBox(height: 50),

          // Título
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 20),

          // Barra amarela
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.darkOrange,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 30),

          // Descrição
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String imagePath;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}
