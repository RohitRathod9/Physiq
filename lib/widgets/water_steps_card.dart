import 'package:flutter/material.dart';
import 'package:physiq/utils/design_system.dart';

class WaterStepsCard extends StatelessWidget {
  final Map<String, dynamic> dailySummary;

  const WaterStepsCard({super.key, required this.dailySummary});

  @override
  Widget build(BuildContext context) {
    // Replaced Column with a ListView to prevent vertical overflow.
    return ListView(
      children: [
        Row(
          // Aligns the cards to the top of the row.
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepsCard(),
            const SizedBox(width: 12),
            _buildCaloriesBurnedCard(),
          ],
        ),
        const SizedBox(height: 12),
        _buildWaterCard(),
      ],
    );
  }

  Widget _buildStepsCard() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppRadii.smallCard),
          boxShadow: [AppShadows.card],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('0/10000', style: AppTextStyles.nutrientValue),
                const Spacer(),
                const Icon(Icons.directions_walk, color: AppColors.steps, size: 24),
              ],
            ),
            Text('Steps Today', style: AppTextStyles.label),
            const SizedBox(height: 16),
            Row(
              children: [
                // Assuming you have this asset.
                // Image.asset('assets/google_health_logo.png', width: 24, height: 24),
                const Icon(Icons.health_and_safety_outlined), // Placeholder icon
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Connect Google Health to track your steps',
                    style: AppTextStyles.smallLabel,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCaloriesBurnedCard() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppRadii.smallCard),
          boxShadow: [AppShadows.card],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('0', style: AppTextStyles.nutrientValue),
                const Spacer(),
                const Icon(Icons.local_fire_department, color: Colors.orange, size: 24),
              ],
            ),
            Text('Calories burned', style: AppTextStyles.label),
            const SizedBox(height: 16),
            Text('Steps', style: AppTextStyles.label),
            Text('+0', style: AppTextStyles.smallLabel),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadii.smallCard),
        boxShadow: [AppShadows.card],
      ),
      child: Row(
        children: [
          const Icon(Icons.water_drop, color: AppColors.water, size: 24),
          const SizedBox(width: 12),
          Text('Water', style: AppTextStyles.button),
          const Spacer(),
          Text('0 fl oz (0 cups)', style: AppTextStyles.label),
          const SizedBox(width: 12),
          const Icon(Icons.remove_circle_outline, color: AppColors.secondaryText),
          const SizedBox(width: 8),
          const Icon(Icons.add_circle, color: AppColors.accent),
        ],
      ),
    );
  }
}
