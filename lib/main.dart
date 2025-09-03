import 'package:eurohive/core/theme/app_theme.dart';
import 'package:eurohive/routes/app_routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const EuroHive());
}

class EuroHive extends StatefulWidget {
  const EuroHive({super.key});

  @override
  State<EuroHive> createState() => _EuroHiveState();
}

class _EuroHiveState extends State<EuroHive> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EuroHive',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.generateRoute,
      builder: (context, child) {
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
