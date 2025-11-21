import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Review Your Plan')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Here are your auto-generated macros:'),
            // ... (display macro details here)
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => context.go('/paywall'),
              child: const Text('Continue to Paywall'),
            ),
          ],
        ),
      ),
    );
  }
}
