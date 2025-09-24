import 'package:eurohive/core/theme/app_theme.dart';
import 'package:eurohive/routes/app_routes.dart';
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

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkOnboardingAndNavigate();
  }

  Future<void> _checkOnboardingAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final hasSeenOnboarding = await OnboardingService.hasSeenOnboarding();
    
    if (mounted) {
      if (hasSeenOnboarding) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rocket_launch,
              size: 80,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Text(
              'EuroHive',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
