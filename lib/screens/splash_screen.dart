import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:physiq/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Give the splash screen a moment to be visible.
    await Future.delayed(const Duration(seconds: 1));

    final authService = AuthService();
    final user = authService.getCurrentUser();

    if (user != null) {
      // Here you would check if the user has completed onboarding.
      // For this example, we'll assume they haven't.
      final bool hasOnboarded = false; // Replace with actual logic

      if (mounted) {
        if (hasOnboarded) {
          context.go('/home');
        } else {
          context.go('/onboarding'); // Placeholder for onboarding flow
        }
      }
    } else {
      if (mounted) {
        context.go('/get-started');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        // Placeholder for the Physiq app logo
        child: FlutterLogo(size: 100),
      ),
    );
  }
}
