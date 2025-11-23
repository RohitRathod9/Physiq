import 'package:flutter/material.dart';
import 'package:physiq/utils/design_system.dart';

class BmiCard extends StatelessWidget {
  final double bmi;
  final String category;

  const BmiCard({super.key, required this.bmi, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      // 1. DECREASED SIZE: Reduced vertical padding to make the card less bulky.
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadii.card),
        boxShadow: [AppShadows.card],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('BMI', style: AppTextStyles.heading2),
              IconButton(
                icon: const Icon(Icons.help_outline, color: AppColors.secondaryText),
                onPressed: () {
                  // Show info dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('BMI Categories'),
                      content: const Text(
                        'Underweight: < 18.5\nHealthy: 18.5 - 24.9\nOverweight: 25 - 29.9\nObese: 30+',
                      ),
                      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
                    ),
                  );
                },
              ),
            ],
          ),
          // 2. ADJUSTED SPACING: Reduced the SizedBox height from 16 to 8.
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(bmi.toStringAsFixed(1), style: AppTextStyles.heading1.copyWith(fontSize: 38)),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getCategoryColor(category).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  category,
                  style: AppTextStyles.bodyBold.copyWith(color: _getCategoryColor(category)),
                ),
              ),
            ],
          ),
          // Reduced spacing before the indicator.
          const SizedBox(height: 16),
          _buildVisualIndicator(),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Underweight': return Colors.blue;
      case 'Healthy': return Colors.green;
      case 'Overweight': return Colors.orange;
      case 'Obese': return Colors.red;
      default: return Colors.grey;
    }
  }

  Widget _buildVisualIndicator() {
    // Helper to create the text labels
    Widget _buildLabel(String text, int flex, Color color) {
      return Expanded(
        flex: flex,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyles.smallLabel.copyWith(color: color, fontSize: 9),
        ),
      );
    }

    return Column(
      children: [
        // The colored bar
        ClipRRect(
          borderRadius: BorderRadius.circular(4), // Rounded corners for the bar
          child: Row(
            children: [
              Expanded(flex: 18, child: Container(height: 8, color: Colors.blue)),
              Expanded(flex: 7, child: Container(height: 8, color: Colors.green)),
              Expanded(flex: 5, child: Container(height: 8, color: Colors.orange)),
              Expanded(flex: 10, child: Container(height: 8, color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // 3. ADDED LABELS: New Row with text labels below the bar.
        Row(
          children: [
            _buildLabel('Underweight', 18, Colors.blue),
            _buildLabel('Healthy', 7, Colors.green),
            _buildLabel('Overweight', 5, Colors.orange),
            _buildLabel('Obese', 10, Colors.red),
          ],
        ),
      ],
    );
  }
}
