import 'package:flutter/material.dart';
import 'package:physiq/theme/design_system.dart';

class GoalStep extends StatelessWidget {
  final String? goal;
  final ValueChanged<String> onChanged;

  const GoalStep({super.key, this.goal, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('What is Your Goal?', style: AppTextStyles.h2),
          const SizedBox(height: 32),
          _buildOption('Lose Weight', 'lose'),
          const SizedBox(height: 16),
          _buildOption('Maintain Weight', 'maintain'),
          const SizedBox(height: 16),
          _buildOption('Gain Weight', 'gain'),
        ],
      ),
    );
  }

  Widget _buildOption(String label, String value) {
    final isSelected = goal == value;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[200]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.bold,
              color: isSelected ? AppColors.primary : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
