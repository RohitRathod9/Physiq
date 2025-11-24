class CalorieCalculator {
  static const Map<String, double> _metTable = {
    "run_low": 6.0,
    "run_medium": 9.8,
    "run_high": 11.5,
    "cycling_low": 4.0,
    "cycling_medium": 7.5,
    "cycling_high": 10.0,
    "weightlifting_low": 3.0,
    "weightlifting_medium": 5.0,
    "weightlifting_high": 6.0,
    "push_ups": 8.0,
    "squats": 5.5,
    "lunges": 5.5,
    "plank": 3.5,
    "burpees": 8.0,
    "mountain_climbers": 8.0,
    "hip_thrusts": 4.0,
    "bench_press": 5.0,
    "deadlift": 6.0,
    "squat_barbell": 6.0,
    "lat_pulldown": 4.5,
    "bicep_curl": 3.5,
    "shoulder_press": 4.5,
    "hiit": 10.0,
    "generic_low": 3.0,
    "generic_medium": 5.0,
    "generic_high": 8.0,
  };

  static double calculateCalories({
    required String exerciseType, // e.g., "run", "cycling", "weightlifting"
    required String intensity, // "low", "medium", "high"
    required int durationMinutes,
    required double weightKg,
  }) {
    String key = "${exerciseType}_$intensity";
    if (!_metTable.containsKey(key)) {
      // Fallback to generic if specific key not found
      key = "generic_$intensity";
    }
    
    // Direct lookup for specific exercises that might not have intensity suffix in the key passed
    if (_metTable.containsKey(exerciseType)) {
      key = exerciseType;
    }

    final met = _metTable[key] ?? 5.0; // Default MET 5.0 if all else fails
    
    // Formula: calories = MET * 3.5 * weightKg / 200 * durationMinutes
    return met * 3.5 * weightKg / 200 * durationMinutes;
  }

  static double getMet(String key) {
    return _metTable[key] ?? 5.0;
  }
}
