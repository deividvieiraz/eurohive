import 'package:eurohive/core/constants/app_colors.dart';
import 'package:eurohive/screens/discovery_screen.dart';
import 'package:eurohive/screens/feed_screen.dart';
import 'package:eurohive/screens/home_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const FeedScreen(),
    const DiscoveryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  body: Stack(
    children: [
      IndexedStack(index: _currentIndex, children: _screens),

      Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 100,
            right: 100,
            bottom: 25,
          ),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(0, Icons.home),
                  _buildNavItem(1, Icons.article),
                  _buildNavItem(2, Icons.explore),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  ),
);
  }

  Widget _buildNavItem(int index, IconData icon) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        borderRadius: BorderRadius.circular(30),
        child: Container(
          height: 70,
          child: Icon(
            icon,
            color: isSelected ? AppColors.blue : Colors.grey[600],
            size: 28,
          ),
        ),
      ),
    );
  }
}
