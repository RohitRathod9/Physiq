import 'package:flutter/material.dart';
import 'package:physiq/utils/design_system.dart';

class CalorieMainCard extends StatefulWidget {
  final Map<String, dynamic> dailySummary;

  const CalorieMainCard({super.key, required this.dailySummary});

  @override
  State<CalorieMainCard> createState() => _CalorieMainCardState();
}

class _CalorieMainCardState extends State<CalorieMainCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    final double caloriesEaten = (widget.dailySummary['caloriesEaten'] ?? 0)
        .toDouble();
    final double calorieTarget =
        (widget.dailySummary['macroTarget']?['calories'] ?? 2800).toDouble();
    final double endProgress = calorieTarget > 0
        ? caloriesEaten / calorieTarget
        : 0;

    _progressAnimation = Tween<double>(begin: 0, end: endProgress).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.card.withOpacity(0.9), AppColors.card],
        ),
        borderRadius: BorderRadius.circular(AppRadii.bigCard),
        boxShadow: [AppShadows.card],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('1429', style: AppTextStyles.largeNumber),
              Text('Calories left', style: AppTextStyles.label),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text('666 eaten', style: AppTextStyles.label),
                  const SizedBox(width: 16),
                  Text('108 burned', style: AppTextStyles.label),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 70,
            width: 70,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: _progressAnimation.value,
                      strokeWidth: 8,
                      backgroundColor: AppColors.background,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.accent,
                      ),
                    ),
                    const Center(
                      child: Icon(
                        Icons.local_fire_department,
                        color: AppColors.accent,
                        size: 28,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
