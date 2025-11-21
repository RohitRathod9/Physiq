import 'package:flutter/material.dart';
import 'package:physiq/theme/design_system.dart';

class GenderStep extends StatelessWidget {
  final String? gender;
  final ValueChanged<String> onChanged;

  const GenderStep({super.key, this.gender, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Choose your Gender', style: AppTextStyles.h2),
          const SizedBox(height: 8),
          Text(
            'This will be used to calibrate your custom plan.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          _buildOption('Female', 'female'),
          const SizedBox(height: 16),
          _buildOption('Male', 'male'),
          const SizedBox(height: 16),
          _buildOption('Other', 'other'),
        ],
      ),
    );
  }

  Widget _buildOption(String label, String value) {
    final isSelected = gender == value;
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
