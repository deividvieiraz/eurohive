import 'package:eurohive/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Map<String, dynamic> project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final String mainTitle = "Projetos Recentes";
    final String title = project['title'] ?? '';
    final String longDescription = project['longDescription'] ?? '';
    final String rating = project['rating']?.toString() ?? '0.0';
    final String likes = project['likes']?.toString() ?? '0';
    final Color color = project['color'] as Color? ?? Colors.grey;
    final IconData icon = project['icon'] as IconData? ?? Icons.work;

    return Scaffold(
      appBar: AppBar(
        title: Text(mainTitle),
        backgroundColor: AppColors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: color,
                    radius: 28,
                    child: Icon(icon, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                longDescription,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(rating),
                  const SizedBox(width: 16),
                  const Icon(Icons.thumb_up, color: Colors.blue),
                  const SizedBox(width: 4),
                  Text(likes),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
