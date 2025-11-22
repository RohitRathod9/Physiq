import 'package:flutter/material.dart';
import 'package:physiq/utils/design_system.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fitness_center, size: 64, color: AppColors.secondaryText),
            const SizedBox(height: 16),
            Text(
              'Exercise Tracking',
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: 8),
            Text(
              'Coming Soon',
              style: AppTextStyles.body.copyWith(color: AppColors.secondaryText),
            ),
          ],
        ),
      ),
    );
  }
}
