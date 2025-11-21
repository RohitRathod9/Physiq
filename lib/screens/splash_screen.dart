import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:physiq/theme/design_system.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      context.go('/get-started');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo placeholder or Text
            Text(
              'Physiq',
              style: AppTextStyles.h1.copyWith(fontSize: 48),
            ),
            const SizedBox(height: 16),
            Text(
              'Build your dream body',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
