import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:physiq/theme/design_system.dart';
import 'package:physiq/viewmodels/onboarding_viewmodel.dart';

// Importing all the individual step widgets
import 'gender_step.dart';
import 'birthyear_step.dart';
import 'height_weight_step.dart';
import 'activity_step.dart';
import 'goal_step.dart';
import 'target_weight_step.dart';
import 'timeframe_step.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    final state = ref.read(onboardingProvider);
    if (_isStepValid(state)) {
      if (_currentStep < 6) { // 7 steps total (0-6)
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _onComplete();
      }
    }
  }

  void _onBack() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.pop();
    }
  }

  bool _isStepValid(OnboardingState state) {
    switch (_currentStep) {
      case 0: // Gender
        if (state.gender == null) {
          _showError('Please select a gender.');
          return false;
        }
        return true;
      case 1: // Birth Year
        if (state.birthYear == null) {
          _showError('Please select your birth year.');
          return false;
        }
        return true;
      case 2: // Height & Weight
        if (state.height == null || state.weight == null) {
          _showError('Please enter your height and weight.');
          return false;
        }
        // Validate ranges
        if (state.height! < 100 || state.height! > 230) {
          _showError('Height must be between 100cm and 230cm.');
          return false;
        }
        if (state.weight! < 30 || state.weight! > 300) {
          _showError('Weight must be between 30kg and 300kg.');
          return false;
        }
        return true;
      case 3: // Activity
        if (state.activityLevel == null) {
          _showError('Please select your activity level.');
          return false;
        }
        return true;
      case 4: // Goal
        if (state.goal == null) {
          _showError('Please select a goal.');
          return false;
        }
        return true;
      case 5: // Target Weight
        if (state.targetWeight == null) {
          _showError('Please enter a target weight.');
          return false;
        }
        // Validate within +/- 50% of current weight
        final currentWeight = state.weight!;
        final min = currentWeight * 0.5;
        final max = currentWeight * 1.5;
        if (state.targetWeight! < min || state.targetWeight! > max) {
           _showError('Target weight must be within 50% of your current weight ($min - $max).');
           return false;
        }
        return true;
      case 6: // Timeframe
        if (state.timeframeMonths == null) {
          _showError('Please select a timeframe.');
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _onComplete() async {
    // Navigate to Loading Screen which will trigger generation
    context.go('/loading');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final viewModel = ref.read(onboardingProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _onBack,
        ),
        title: LinearProgressIndicator(
          value: (_currentStep + 1) / 7,
          backgroundColor: AppColors.surface,
          color: AppColors.primary,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentStep = index;
          });
        },
        children: [
          GenderStep(
            gender: state.gender,
            onChanged: viewModel.updateGender,
          ),
          BirthYearStep(
            birthYear: state.birthYear,
            onChanged: viewModel.updateBirthYear,
          ),
          HeightWeightStep(
            height: state.height,
            weight: state.weight,
            isMetric: state.isMetric,
            onMetricChanged: viewModel.toggleMetric,
            onChanged: (h, w) {
              viewModel.updateHeight(h);
              viewModel.updateWeight(w);
            },
          ),
          ActivityStep(
            activityLevel: state.activityLevel,
            onChanged: viewModel.updateActivityLevel,
          ),
          GoalStep(
            goal: state.goal,
            onChanged: viewModel.updateGoal,
          ),
          TargetWeightStep(
            targetWeight: state.targetWeight,
            onChanged: viewModel.updateTargetWeight,
            isMetric: state.isMetric,
          ),
          TimeframeStep(
            timeframe: state.timeframeMonths,
            onChanged: viewModel.updateTimeframe,
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: _onNext,
          child: Text(
            _currentStep == 6 ? 'Generate Plan' : 'Continue',
            style: AppTextStyles.button,
          ),
        ),
      ),
    );
  }
}
