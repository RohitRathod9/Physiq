import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// A service for handling simple local data storage using SharedPreferences.
class LocalStorageService {
  // A constant key for storing and retrieving the onboarding draft.
  static const String _onboardingDraftKey = 'onboarding_draft';

  /// Saves the current state of the onboarding draft to local storage.
  ///
  /// The [draft] map is encoded as a JSON string before being saved.
  Future<void> saveOnboardingDraft(Map<String, dynamic> draft) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String jsonDraft = json.encode(draft);
      await prefs.setString(_onboardingDraftKey, jsonDraft);
      print("LocalStorage: Onboarding draft saved successfully.");
    } catch (e) {
      print("LocalStorage Error (Save): $e");
    }
  }

  /// Loads the saved onboarding draft from local storage.
  ///
  /// Returns the draft as a [Map<String, dynamic>] or `null` if no draft
  /// is found or if an error occurs during decoding.
  Future<Map<String, dynamic>?> loadOnboardingDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonDraft = prefs.getString(_onboardingDraftKey);

      if (jsonDraft == null) {
        print("LocalStorage: No onboarding draft found.");
        return null;
      }

      print("LocalStorage: Onboarding draft loaded successfully.");
      return json.decode(jsonDraft) as Map<String, dynamic>;
    } catch (e) {
      print("LocalStorage Error (Load): $e");
      return null;
    }
  }

  /// Clears the saved onboarding draft from local storage.
  Future<void> clearOnboardingDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_onboardingDraftKey);
      print("LocalStorage: Onboarding draft cleared successfully.");
    } catch (e) {
      print("LocalStorage Error (Clear): $e");
    }
  }
}
