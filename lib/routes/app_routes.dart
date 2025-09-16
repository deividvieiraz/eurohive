import 'package:eurohive/screens/login_screen.dart';
import 'package:eurohive/screens/main_screen.dart';
import 'package:eurohive/screens/profile_screen.dart';
import 'package:eurohive/screens/application_method_choice_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const login = '/login';
  static const main = '/main';
  static const profile = '/profile';
  static const applicationMethodChoice = '/application-method-choice';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
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