import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:physiq/services/auth_service.dart';
import 'package:physiq/services/firestore_service.dart';
import 'package:physiq/services/local_storage.dart';
import 'package:physiq/theme/design_system.dart';

// Importing all the individual step widgets from the same directory.
import 'gender_step.dart';
import 'birthyear_step.dart';
import 'height_weight_step.dart';
import 'activity_step.dart';
import 'goal_step.dart';
import 'target_weight_step.dart';
import 'timeframe_step.dart';

/// A multi-step onboarding screen that guides the user through
/// setting up their initial profile.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final LocalStorageService _localStorage = LocalStorageService();
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();

  // A map to hold the collected onboarding data.
  Map<String, dynamic> _draft = {};
  int _currentStep = 0;

  // The list of step widgets.
  late final List<Widget> _steps;

  @override
  void initState() {
    super.initState();
    _initializeSteps();
    _loadDraft();
  }

  /// Loads a previously saved draft from local storage.
  Future<void> _loadDraft() async {
    final draft = await _localStorage.loadOnboardingDraft();
    if (draft != null) {
      setState(() {
        _draft = draft;
        _initializeSteps(); // Re-initialize steps with loaded data
      });
      print("Onboarding draft loaded: $_draft");
    }
  }

  /// Saves the current onboarding draft to local storage and Firestore.
  Future<void> _saveDraft() async {
    await _localStorage.saveOnboardingDraft(_draft);

    final user = _authService.getCurrentUser();
    if (user != null && !AppConfig.useMockBackend) {
      // This is where you would save the draft to Firestore.
      // e.g., await _firestoreService.saveOnboardingDraft(user.uid, _draft);
      print("Draft saved to Firestore (simulated).");
    }
  }

  /// Handles moving to the next step or completing the flow.
  void _onNext() {
    // A simple validation placeholder.
    if (_isStepValid()) {
      if (_currentStep < _steps.length - 1) {
        _saveDraft(); // Save draft after each valid step.
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _onComplete();
      }
    }
  }

  /// Finalizes the onboarding process.
  Future<void> _onComplete() async {
    await _saveDraft();
    await _localStorage.clearOnboardingDraft(); // Clean up the local draft.

    // Here you would finalize the profile on your backend.
    // e.g., await _firestoreService.finalizeOnboarding(_authService.getCurrentUser()!.uid, _draft);
    print("Onboarding complete!");

    if (mounted) {
      context.go('/loading');
    }
  }

  /// Updates the draft with new data from a step.
  void _updateDraft(String key, dynamic value) {
    setState(() {
      _draft[key] = value;
    });
  }

  /// Placeholder for step-specific validation.
  bool _isStepValid() {
    // In a real app, you would have specific validation logic per step.
    // For example, checking if a gender has been selected.
    if (_currentStep == 0 && _draft['gender'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a gender.')),
      );
      return false;
    }
    return true;
  }
  
  /// Initializes or re-initializes the list of step widgets.
  /// This is necessary to pass the latest draft data to each step.
  void _initializeSteps() {
    _steps = [
      GenderStep(
        gender: _draft['gender'],
        onChanged: (val) => _updateDraft('gender', val),
      ),
      BirthYearStep(
        birthYear: _draft['birthYear'],
        onChanged: (val) => _updateDraft('birthYear', val),
      ),
      HeightWeightStep(
        height: _draft['height'],
        weight: _draft['weight'],
        onChanged: (height, weight) {
          _updateDraft('height', height);
          _updateDraft('weight', weight);
        },
      ),
      ActivityStep(
        activityLevel: _draft['activityLevel'],
        onChanged: (val) => _updateDraft('activityLevel', val),
      ),
      GoalStep(
        goal: _draft['goal'],
        onChanged: (val) => _updateDraft('goal', val),
      ),
      TargetWeightStep(
        targetWeight: _draft['targetWeight'],
        onChanged: (val) => _updateDraft('targetWeight', val),
      ),
      TimeframeStep(
        timeframe: _draft['timeframe'],
        onChanged: (val) => _updateDraft('timeframe', val),
      ),
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Step ${_currentStep + 1} of ${_steps.length}"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disables swiping.
        itemCount: _steps.length,
        onPageChanged: (index) {
          setState(() {
            _currentStep = index;
          });
        },
        itemBuilder: (context, index) {
          return _steps[index];
        },
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
            _currentStep == _steps.length - 1 ? 'Calculate My Plan' : 'Next',
            style: AppTextStyles.button,
          ),
        ),
      ),
    );
  }
}
