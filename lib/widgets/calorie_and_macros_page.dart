import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:physiq/theme/design_system.dart';

class CalorieAndMacrosPage extends StatelessWidget {
  final Map<String, dynamic> dailySummary;

  const CalorieAndMacrosPage({super.key, required this.dailySummary});

  @override
  Widget build(BuildContext context) {
    // Extract data with safe defaults
    final int caloriesGoal = (dailySummary['caloriesGoal'] ?? 2000).toInt();
    final int caloriesConsumed = (dailySummary['caloriesConsumed'] ?? 0).toInt();
    
    final int caloriesLeft = (caloriesGoal - caloriesConsumed).clamp(0, 9999);
    final double caloriesPercent = (caloriesGoal > 0) ? (caloriesConsumed / caloriesGoal).clamp(0.0, 1.0) : 0.0;

    // Macros
    final int carbsGoal = (dailySummary['carbsGoal'] ?? 100).toInt();
    final int carbsConsumed = (dailySummary['carbsConsumed'] ?? 0).toInt();
    final double carbsPercent = (carbsGoal > 0) ? (carbsConsumed / carbsGoal).clamp(0.0, 1.0) : 0.0;

    final int proteinGoal = (dailySummary['proteinGoal'] ?? 100).toInt();
    final int proteinConsumed = (dailySummary['proteinConsumed'] ?? 0).toInt();
    final double proteinPercent = (proteinGoal > 0) ? (proteinConsumed / proteinGoal).clamp(0.0, 1.0) : 0.0;

    final int fatGoal = (dailySummary['fatGoal'] ?? 50).toInt();
    final int fatConsumed = (dailySummary['fatConsumed'] ?? 0).toInt();
    final double fatPercent = (fatGoal > 0) ? (fatConsumed / fatGoal).clamp(0.0, 1.0) : 0.0;

    return Column(
      children: [
        // --- Main Calorie Card ---
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0), // Padding handled by alignment
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadii.bigCard),
              boxShadow: [AppShadows.card],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left Side: Calories Left
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$caloriesLeft',
                        style: AppTextStyles.largeNumber.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'EATEN',
                        style: AppTextStyles.smallLabel,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                // Center: Progress Ring
                CircularPercentIndicator(
                  radius: 88.0, // 140 diameter
                  lineWidth: 15.0,
                  animation: true,
                  percent: caloriesPercent,
                  center: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.local_fire_department_rounded, color: AppColors.primaryText, size: 28),
                    ),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: const Color(0xFFF3F4F6),
                  progressColor: Colors.grey.shade300,
                ),

                // Right Side: Calories Burned
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$caloriesConsumed',
                        style: AppTextStyles.largeNumber.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'BURNED',
                        style: AppTextStyles.smallLabel,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // --- Macro Cards ---
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildVerticalMacroCard(
                label: 'Protein',
                value: '${proteinConsumed}g',
                percent: proteinPercent,
                icon: Icons.restaurant,
                color: const Color(0xFFF87171), // Red/Pink
              ),
              const SizedBox(width: 12),
              _buildVerticalMacroCard(
                label: 'Carbs',
                value: '${carbsConsumed}g',
                percent: carbsPercent,
                icon: Icons.grass,
                color: const Color(0xFFFACC15), // Yellow
              ),
              const SizedBox(width: 12),
              _buildVerticalMacroCard(
                label: 'Fats',
                value: '${fatConsumed}g',
                percent: fatPercent,
                icon: Icons.water_drop,
                color: const Color(0xFF60A5FA), // Blue
              ),
              const SizedBox(width: 12),
              _buildVerticalMacroCard(
                label: 'Sodium',
                value: '${(dailySummary['sodiumConsumed'] ?? 0).toInt()}mg',
                percent: 0.5, // Placeholder
                icon: Icons.grain,
                color: const Color(0xFFA78BFA),
              ),
              const SizedBox(width: 12),
              _buildVerticalMacroCard(
                label: 'Sugar',
                value: '${(dailySummary['sugarConsumed'] ?? 0).toInt()}g',
                percent: 0.3, // Placeholder
                icon: Icons.cake,
                color: const Color(0xFFF472B6),
              ),
              const SizedBox(width: 12),
              _buildVerticalMacroCard(
                label: 'Fiber',
                value: '${(dailySummary['fiberConsumed'] ?? 0).toInt()}g',
                percent: 0.7, // Placeholder
                icon: Icons.eco,
                color: const Color(0xFF34D399),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalMacroCard({
    required String label,
    required String value,
    required double percent,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 110, // Increased width
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8), // Reduced vertical padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.smallCard),
        boxShadow: [AppShadows.card],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularPercentIndicator(
            radius: 30.0, // Restored size
            lineWidth: 6.0,
            animation: true,
            percent: percent,
            center: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 14, color: color),
            ),
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: const Color(0xFFF3F4F6),
            progressColor: color.withOpacity(0.5),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppTextStyles.bodyBold.copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTextStyles.smallLabel.copyWith(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
