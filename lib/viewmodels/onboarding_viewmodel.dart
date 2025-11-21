import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physiq/services/local_storage.dart';
import 'package:physiq/services/plan_generator.dart';
import 'package:physiq/services/auth_service.dart';
import 'package:physiq/services/firestore_service.dart';

class OnboardingState {
  final String? gender;
  final int? birthYear;
  final double? height; // in cm
  final double? weight; // in kg
  final double? activityLevel;
  final String? goal;
  final double? targetWeight; // in kg
  final int? timeframeMonths;
  final bool isMetric;
  final Map<String, dynamic>? calculatedPlan;
  final bool isLoading;

  OnboardingState({
    this.gender,
    this.birthYear,
    this.height,
    this.weight,
    this.activityLevel,
    this.goal,
    this.targetWeight,
    this.timeframeMonths = 3,
    this.isMetric = true,
    this.calculatedPlan,
    this.isLoading = false,
  });

  OnboardingState copyWith({
    String? gender,
    int? birthYear,
    double? height,
    double? weight,
    double? activityLevel,
    String? goal,
    double? targetWeight,
    int? timeframeMonths,
    bool? isMetric,
    Map<String, dynamic>? calculatedPlan,
    bool? isLoading,
  }) {
    return OnboardingState(
      gender: gender ?? this.gender,
      birthYear: birthYear ?? this.birthYear,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
      targetWeight: targetWeight ?? this.targetWeight,
      timeframeMonths: timeframeMonths ?? this.timeframeMonths,
      isMetric: isMetric ?? this.isMetric,
      calculatedPlan: calculatedPlan ?? this.calculatedPlan,
      isLoading: isLoading ?? this.isLoading,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'gender': gender,
      'birthYear': birthYear,
      'height': height,
      'weight': weight,
      'activityLevel': activityLevel,
      'goal': goal,
      'targetWeight': targetWeight,
      'timeframeMonths': timeframeMonths,
      'isMetric': isMetric,
    };
  }

  factory OnboardingState.fromMap(Map<String, dynamic> map) {
    return OnboardingState(
      gender: map['gender'],
      birthYear: map['birthYear'],
      height: map['height'],
      weight: map['weight'],
      activityLevel: map['activityLevel'],
      goal: map['goal'],
      targetWeight: map['targetWeight'],
      timeframeMonths: map['timeframeMonths'] ?? 3,
      isMetric: map['isMetric'] ?? true,
    );
  }
}

class OnboardingViewModel extends StateNotifier<OnboardingState> {
  final LocalStorageService _localStorage;
  final AuthService _authService;
  final FirestoreService _firestoreService;

  OnboardingViewModel(this._localStorage, this._authService, this._firestoreService) : super(OnboardingState()) {
    _loadDraft();
  }

  Future<void> _loadDraft() async {
    final draft = await _localStorage.loadOnboardingDraft();
    if (draft != null) {
      state = OnboardingState.fromMap(draft);
    }
  }

  Future<void> _saveDraft() async {
    await _localStorage.saveOnboardingDraft(state.toMap());
    // Sync to Firestore if user is logged in (skip for now or implement if auth is ready)
    // final user = _authService.getCurrentUser();
    // if (user != null) { ... }
  }

  void updateGender(String gender) {
    state = state.copyWith(gender: gender);
    _saveDraft();
  }

  void updateBirthYear(int year) {
    state = state.copyWith(birthYear: year);
    _saveDraft();
  }

  void updateHeight(double cm) {
    state = state.copyWith(height: cm);
    _saveDraft();
  }

  void updateWeight(double kg) {
    state = state.copyWith(weight: kg);
    _saveDraft();
  }

  void updateActivityLevel(double level) {
    state = state.copyWith(activityLevel: level);
    _saveDraft();
  }

  void updateGoal(String goal) {
    state = state.copyWith(goal: goal);
    _saveDraft();
  }

  void updateTargetWeight(double kg) {
    state = state.copyWith(targetWeight: kg);
    _saveDraft();
  }

  void updateTimeframe(int months) {
    state = state.copyWith(timeframeMonths: months);
    _saveDraft();
  }

  void toggleMetric(bool isMetric) {
    state = state.copyWith(isMetric: isMetric);
    _saveDraft();
  }

  Future<void> generatePlan() async {
    state = state.copyWith(isLoading: true);
    
    // Simulate delay for "Generating Plan"
    await Future.delayed(const Duration(seconds: 2));

    final age = DateTime.now().year - (state.birthYear ?? 2000);
    
    final plan = PlanGenerator.generatePlan(
      gender: state.gender ?? 'male',
      age: age,
      heightCm: state.height ?? 170,
      weightKg: state.weight ?? 70,
      activityMultiplier: state.activityLevel ?? 1.2,
      goal: state.goal ?? 'maintain',
    );

    state = state.copyWith(
      calculatedPlan: plan,
      isLoading: false,
    );
    
    // Save plan to local storage/firestore as needed
  }
  
  void updateMacroSplit({required int proteinG, required int fatG, required int carbsG}) {
     // Logic to update the plan manually if user edits macros
     // For now, we just update the local state map
     final currentPlan = Map<String, dynamic>.from(state.calculatedPlan!);
     currentPlan['proteinG'] = proteinG;
     currentPlan['fatG'] = fatG;
     currentPlan['carbsG'] = carbsG;
     
     // Recalculate calories based on new grams?
     // Or just update the grams.
     // The prompt says "Validate edits and dynamically recalc other macros".
     // We'll handle that logic in the UI or a specific method here.
     
     state = state.copyWith(calculatedPlan: currentPlan);
  }
}

final onboardingProvider = StateNotifierProvider<OnboardingViewModel, OnboardingState>((ref) {
  return OnboardingViewModel(
    LocalStorageService(),
    AuthService(),
    FirestoreService(),
  );
});
