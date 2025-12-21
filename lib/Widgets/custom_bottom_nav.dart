import 'package:flutter/material.dart';
import 'package:arbtilant/core/design_system/index.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.brightGreen,
      unselectedItemColor: AppColors.textSecondary,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: AppSpacing.elevation2,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt_rounded),
          label: 'Scan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books_rounded),
          label: 'Library',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history_rounded),
          label: 'History',
        ),
      ],
    );
  }
}
