import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physiq/utils/design_system.dart';

class WorkoutHistoryScreen extends ConsumerWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock data
    final history = [
      {'date': 'Today', 'title': 'Push Ups', 'calories': '45 kcal'},
      {'date': 'Yesterday', 'title': 'Running', 'calories': '300 kcal'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Workout History', style: AppTextStyles.heading2),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryText),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: history.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final item = history[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(AppRadii.smallCard),
              boxShadow: [AppShadows.card],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['title']!, style: AppTextStyles.bodyBold),
                    Text(item['date']!, style: AppTextStyles.smallLabel),
                  ],
                ),
                Text(item['calories']!, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.accent)),
              ],
            ),
          );
        },
      ),
    );
  }
}
