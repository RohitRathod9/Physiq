import 'package:flutter/material.dart';
import 'package:physiq/theme/design_system.dart';

class TimeframeStep extends StatelessWidget {
  final int? timeframe; // months
  final ValueChanged<int> onChanged;

  const TimeframeStep({super.key, this.timeframe, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    // Map slider value (0-4) to months
    final steps = [1, 3, 6, 9, 12];
    double sliderValue = 1.0; // Default index 1 -> 3 months
    
    if (timeframe != null) {
      int index = steps.indexOf(timeframe!);
      if (index != -1) {
        sliderValue = index.toDouble();
      }
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Timeframe', style: AppTextStyles.h2),
          const SizedBox(height: 8),
          Text(
            'How quickly do you want to reach your goal?',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 48),
          
          Text(
            '${steps[sliderValue.toInt()]} Months',
            style: AppTextStyles.h1.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 24),
          
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: Colors.grey[300],
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withOpacity(0.2),
              trackHeight: 6.0,
            ),
            child: Slider(
              value: sliderValue,
              min: 0,
              max: 4,
              divisions: 4,
              onChanged: (val) {
                onChanged(steps[val.toInt()]);
              },
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Faster'),
              Text('Slower'),
            ],
          ),
        ],
      ),
    );
  }
}
