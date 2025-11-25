
# Physiq Onboarding Flow

This directory contains the implementation of the Physiq onboarding flow.

## Features
- **Splash Screen**: Animated entry with auth check.
- **Get Started**: Entry point for new users.
- **Sign In**: Bottom sheet for Google/Email/Anonymous auth.
- **Onboarding Steps**:
  - Name, Gender, Birth Year
  - Height & Weight (Metric/Imperial toggle)
  - Activity Level, Goal, Target Weight
  - Motivational Messages & Timeframe
  - Diet Preference, Notifications, Referral
- **Plan Generation**: Local calculation using Mifflin-St Jeor formula.
- **Review**: Editable plan summary.
- **Paywall**: 5-screen sequence with spinner and offer.

## Running the App
1. Ensure you have Flutter installed.
2. Run `flutter pub get`.
3. Run `flutter run`.

## Testing
- **Unit Tests**:
  - `flutter test test/unit/conversions_test.dart`
  - `flutter test test/unit/plan_math_test.dart`
- **Integration Tests**:
  - `flutter test test/integration/onboarding_flow_test.dart`

## Cloud Functions
The app is designed to work with Firebase Cloud Functions for canonical plan generation.
Ensure your Firebase project is set up and `generateCanonicalPlan` function is deployed.
Currently, the app uses a local fallback if the cloud function is not reachable or for immediate feedback.

## File Structure
- `lib/screens/onboarding/`: All onboarding screens.
- `lib/services/onboarding_store.dart`: State management.
- `lib/services/plan_generator.dart`: Plan calculation logic.
- `lib/utils/conversions.dart`: Unit conversion helpers.
- `lib/widgets/`: Reusable widgets like `CentralPillButtons`, `UnitToggle`, `SliderWeight`.
