class MetricsCalculator {
  static const Map<String, double> metTable = {
    'push_ups': 8.0,
    'squats': 5.5,
    'plank': 3.0,
    'burpees': 10.0,
    'walking': 3.5,
    'running': 9.8,
    'bench_press': 6.0,
    'deadlift': 6.0,
    'cycling': 7.5,
    'yoga': 2.5,
    'hiit': 8.0,
    'default': 3.5,
  };

  static double getMET(String exerciseKey) {
    // Simple lookup, can be improved with fuzzy match or variation handling
    final key = exerciseKey.toLowerCase().replaceAll(' ', '_');
    return metTable[key] ?? metTable['default']!;
  }

  static double calculateCalories({
    required double met,
    required double weightKg,
    required double durationMinutes,
  }) {
    // Formula: MET * 3.5 * weight_kg / 200 * duration_minutes
    return met * 3.5 * weightKg / 200 * durationMinutes;
  }

  static double estimateDurationFromSets({
    required int totalReps,
    required int totalRestSeconds,
    double avgSecPerRep = 2.5,
  }) {
    return (totalReps * avgSecPerRep / 60) + (totalRestSeconds / 60);
  }

  static double calculateEpoc(double exerciseCalories, double met) {
    if (met >= 8.0) {
      return exerciseCalories * 0.05;
    }
    return 0.0;
  }
}
