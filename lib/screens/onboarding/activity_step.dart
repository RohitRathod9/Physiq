import 'package:flutter/material.dart';
import 'package:physiq/theme/design_system.dart';

class ActivityStep extends StatelessWidget {
  final double? activityLevel;
  final ValueChanged<double> onChanged;

  const ActivityStep({super.key, this.activityLevel, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Activity & Lifestyle', style: AppTextStyles.h2),
          const SizedBox(height: 20),
          _buildOption('Sedentary', 'Little or no exercise', 1.2),
          _buildOption('Lightly Active', 'Light exercise 1-3 days/week', 1.375),
          _buildOption('Moderately Active', 'Moderate exercise 3-5 days/week', 1.55),
          _buildOption('Very Active', 'Hard exercise 6-7 days/week', 1.725),
          _buildOption('Athletic', 'Physical job or 2x training', 1.9),
        ],
      ),
    );
  }

  Widget _buildOption(String title, String subtitle, double value) {
    return RadioListTile<double>(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      value: value,
      groupValue: activityLevel,
      activeColor: AppColors.primary,
      onChanged: (val) => onChanged(val!),
    );
  }
}
