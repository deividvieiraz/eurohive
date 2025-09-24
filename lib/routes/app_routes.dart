import 'package:eurohive/screens/login_screen.dart';
import 'package:eurohive/screens/main_screen.dart';
import 'package:eurohive/screens/profile_screen.dart';
import 'package:eurohive/screens/application_method_choice_screen.dart';
import 'package:eurohive/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const main = '/main';
  static const profile = '/profile';
  static const applicationMethodChoice = '/application-method-choice';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        );
      case login:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        );
      case main:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case applicationMethodChoice:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ApplicationMethodChoiceScreen(
            projectId: args['projectId'],
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}