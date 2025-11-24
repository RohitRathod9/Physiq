import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physiq/theme/design_system.dart';
import 'package:physiq/widgets/exercise/intensity_slider.dart';
import 'package:physiq/widgets/exercise/duration_selector.dart';
import 'package:physiq/screens/exercise/add_burned_calories_screen.dart';
import 'package:physiq/viewmodels/exercise_viewmodel.dart';
import 'package:physiq/models/exercise_log_model.dart';

class WeightliftingScreen extends ConsumerStatefulWidget {
  const WeightliftingScreen({super.key});

  @override
  ConsumerState<WeightliftingScreen> createState() => _WeightliftingScreenState();
}

class _WeightliftingScreenState extends ConsumerState<WeightliftingScreen> {
  String _intensity = 'medium';
  int _duration = 45;
  final _setsController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.fitness_center, color: AppColors.primaryText),
            const SizedBox(width: 8),
            Text('Weightlifting', style: AppTextStyles.heading2),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.primaryText),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IntensitySlider(
                    currentIntensity: _intensity,
                    onChanged: (val) => setState(() => _intensity = val),
                  ),
                  const SizedBox(height: 32),
                  DurationSelector(
                    initialDuration: _duration,
                    onChanged: (val) => setState(() => _duration = val),
                  ),
                  const SizedBox(height: 32),
                  Text('Details (Optional)', style: AppTextStyles.heading2),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _setsController,
                    decoration: InputDecoration(
                      labelText: 'Total sets & reps summary',
                      hintText: 'e.g. 3x10 Squats, 3x8 Bench',
                      filled: true,
                      fillColor: AppColors.card,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Avg Weight (kg)',
                      filled: true,
                      fillColor: AppColors.card,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text('Continue', style: AppTextStyles.button.copyWith(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onContinue() {
    const double weightKg = 70.0; // Placeholder
    final viewModel = ref.read(exerciseViewModelProvider.notifier);
    
    // Calculate base calories
    double calories = viewModel.estimateCalories(
      exerciseType: 'weightlifting',
      intensity: _intensity,
      durationMinutes: _duration,
      weightKg: weightKg,
    );

    // Add EPOC if high intensity (mock logic)
    if (_intensity == 'high') {
      calories *= 1.05; // 5% bonus
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddBurnedCaloriesScreen(
          initialCalories: calories,
          onLog: (finalCalories) {
            viewModel.logExercise(
              userId: 'current_user_id',
              exerciseId: 'weightlifting',
              name: 'Weightlifting',
              type: ExerciseType.weightlifting,
              durationMinutes: _duration,
              calories: finalCalories,
              intensity: _intensity,
              details: {
                'summary': _setsController.text,
                'avgWeight': _weightController.text,
              },
              isManualOverride: finalCalories != calories,
            );
            Navigator.popUntil(context, (route) => route.isFirst);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Workout logged!')));
          },
        ),
      ),
    );
  }
}
