import 'package:flutter/material.dart';
import 'package:physiq/theme/design_system.dart';
import 'widgets/choice_card.dart';

class DietPreferenceStep extends StatelessWidget {
  final String? diet;
  final ValueChanged<String> onChanged;

  const DietPreferenceStep({super.key, this.diet, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Diet Preference', style: AppTextStyles.h1),
          const SizedBox(height: 8),
          Text(
            'Choose a diet that suits your lifestyle.',
            textAlign: TextAlign.center,
            style: AppTextStyles.label.copyWith(fontSize: 16, color: AppColors.secondaryText),
          ),
          const SizedBox(height: 32),
          ChoiceCard(
            text: 'Classic',
            isSelected: diet == 'classic',
            onTap: () => onChanged('classic'),
          ),
          ChoiceCard(
            text: 'Pescatarian',
            isSelected: diet == 'pescatarian',
            onTap: () => onChanged('pescatarian'),
          ),
          ChoiceCard(
            text: 'Vegetarian',
            isSelected: diet == 'vegetarian',
            onTap: () => onChanged('vegetarian'),
          ),
          ChoiceCard(
            text: 'Vegan',
            isSelected: diet == 'vegan',
            onTap: () => onChanged('vegan'),
          ),
        ],
      ),
    );
  }
}
