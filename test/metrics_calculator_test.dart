import 'package:flutter_test/flutter_test.dart';
import 'package:physiq/utils/metrics_calculator.dart';

void main() {
  group('MetricsCalculator', () {
    test('calculateCalories returns correct value', () {
      // MET=8.0, Weight=70kg, Duration=10min
      // 8.0 * 3.5 * 70 / 200 * 10 = 98.0
      final calories = MetricsCalculator.calculateCalories(
        met: 8.0,
        weightKg: 70,
        durationMinutes: 10,
      );
      expect(calories, closeTo(98.0, 0.1));
    });

    test('estimateDurationFromSets returns correct value', () {
      // 10 reps, 60s rest (1 set means 0 rest intervals between sets if only 1 set, but usually rest is after set)
      // If we have 1 set of 10 reps:
      // (10 * 2.5 / 60) + (0 / 60) = 25/60 = 0.4166 min
      
      // Let's test 2 sets of 10 reps (20 total), 60s rest between
      // (20 * 2.5 / 60) + (60 / 60) = 50/60 + 1 = 0.833 + 1 = 1.833 min
      final duration = MetricsCalculator.estimateDurationFromSets(
        totalReps: 20,
        totalRestSeconds: 60,
      );
      expect(duration, closeTo(1.833, 0.01));
    });

    test('getMET returns default if not found', () {
      expect(MetricsCalculator.getMET('unknown_exercise'), 3.5);
    });

    test('getMET returns correct value for known exercise', () {
      expect(MetricsCalculator.getMET('push_ups'), 8.0);
    });
  });
}
