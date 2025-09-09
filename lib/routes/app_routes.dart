import 'package:eurohive/screens/login_screen.dart';
import 'package:eurohive/screens/main_screen.dart';
import 'package:eurohive/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const login = '/login';
  static const main = '/main';
  static const profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case main:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}