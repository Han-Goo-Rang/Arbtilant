import 'package:flutter/material.dart';
import 'package:arbtilant/core/design_system/index.dart';
import 'package:arbtilant/Pages/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.brightGreen.withValues(alpha: 0.1),
              ),
              child: Image.asset('assets/logo.png', fit: BoxFit.contain),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Arbtilant',
              style: AppTypography.displayLarge(color: AppColors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Detect Plant Diseases',
              style: AppTypography.bodyLarge(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
