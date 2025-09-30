import 'package:eurohive/screens/login_screen.dart';
import 'package:eurohive/screens/main_screen.dart';
import 'package:eurohive/screens/profile_screen.dart';
import 'package:eurohive/screens/application_method_choice_screen.dart';
import 'package:eurohive/screens/application_details_screen.dart';
import 'package:eurohive/screens/onboarding_screen.dart';
import 'package:eurohive/screens/settings_screen.dart';
import 'package:eurohive/screens/help_screen.dart';
import 'package:eurohive/screens/ranking_screen.dart';
import 'package:eurohive/models/user_application.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const main = '/main';
  static const profile = '/profile';
  static const applicationMethodChoice = '/application-method-choice';
  static const applicationDetails = '/application-details';
  static const settings = '/settings';
  static const help = '/help';
  static const ranking = '/ranking';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
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
        final args = routeSettings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ApplicationMethodChoiceScreen(
            projectId: args['projectId'],
          ),
        );
      case applicationDetails:
        final application = routeSettings.arguments as UserApplication;
        return MaterialPageRoute(
          builder: (_) => ApplicationDetailsScreen(
            application: application,
          ),
        );
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case help:
        return MaterialPageRoute(builder: (_) => const HelpScreen());
      case ranking:
        return MaterialPageRoute(builder: (_) => const RankingScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}