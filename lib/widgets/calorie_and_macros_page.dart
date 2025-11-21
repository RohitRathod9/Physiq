import 'package:flutter/material.dart';
import 'package:physiq/widgets/calorie_main_card.dart';
import 'package:physiq/widgets/protein_card.dart';
import 'package:physiq/widgets/carbs_card.dart';
import 'package:physiq/widgets/fats_card.dart';

/// This widget arranges the main calorie card and the three nutrient
/// cards into a single page view, as seen in the screenshot.
class CalorieAndMacrosPage extends StatelessWidget {
  final Map<String, dynamic> dailySummary;

  const CalorieAndMacrosPage({super.key, required this.dailySummary});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // The main, large card displaying calorie information.
        CalorieMainCard(dailySummary: dailySummary),
        const SizedBox(height: 12),
        // The row of three smaller cards for macronutrients.
        Row(
          children: [
            ProteinCard(dailySummary: dailySummary),
            const SizedBox(width: 12),
            CarbsCard(dailySummary: dailySummary),
            const SizedBox(width: 12),
            FatsCard(dailySummary: dailySummary),
          ],
        ),
      ],
    );
  }
}
