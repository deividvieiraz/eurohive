import 'package:eurohive/core/constants/app_assets.dart';
import 'package:eurohive/core/theme/app_theme.dart';
import 'package:eurohive/routes/app_routes.dart';
import 'package:eurohive/services/auth_service.dart';
import 'package:eurohive/services/onboarding_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const EuroHive());
}

class EuroHive extends StatelessWidget {
  const EuroHive({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EuroHive',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _checkOnboardingAndNavigate();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _navigateWithFadeOut(String route) async {
    // Animação de fade out
    await _animationController.reverse();
    
    // Aguarda um pouco para completar a animação
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (mounted) {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  Future<void> _checkOnboardingAndNavigate() async {
    // Aguarda 3 segundos para mostrar o splash
    await Future.delayed(const Duration(seconds: 3));
    
    final hasSeenOnboarding = await OnboardingService.hasSeenOnboarding();
    final isLoggedIn = await AuthService.isLoggedIn();
    
    if (mounted) {
      if (isLoggedIn) {
        await _navigateWithFadeOut(AppRoutes.main);
      } else if (hasSeenOnboarding) {
        await _navigateWithFadeOut(AppRoutes.login);
      } else {
        await _navigateWithFadeOut(AppRoutes.onboarding);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Image.asset(
            AppAssets.eurohiveName,
            width: 250,
            height: 100,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
