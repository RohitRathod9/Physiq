
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physiq/services/onboarding_store.dart';

final onboardingProvider = ChangeNotifierProvider<OnboardingStore>((ref) {
  return OnboardingStore();
});
