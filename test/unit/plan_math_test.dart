
import 'package:flutter_test/flutter_test.dart';
import 'package:physiq/services/plan_generator.dart';

void main() {
  group('PlanGenerator Math', () {
    test('Calculates BMR and TDEE correctly for Male, Sedentary, Maintain', () {
      final profile = {
        'gender': 'Male',
        'birthYear': 1990, // Age 34 (assuming 2024)
        'heightCm': 180.0,
        'weightKg': 80.0,
        'activityLevel': 'Sedentary',
        'goal': 'Maintain',
      };

      // Mifflin-St Jeor:
      // 10*80 + 6.25*180 - 5*34 + 5 = 800 + 1125 - 170 + 5 = 1760
      // TDEE (Sedentary 1.2) = 1760 * 1.2 = 2112
      // Goal (Maintain) = 2112

      final plan = PlanGenerator.generateLocalPlan(profile);
      
      // Allow some flexibility for age calculation depending on current date
      // Assuming age is calculated as DateTime.now().year - birthYear
      final currentYear = DateTime.now().year;
      final age = currentYear - 1990;
      final expectedBMR = (10 * 80) + (6.25 * 180) - (5 * age) + 5;
      final expectedTDEE = expectedBMR * 1.2;
      
      expect(plan['bmr'], closeTo(expectedBMR, 1.0));
      expect(plan['tdee'], closeTo(expectedTDEE, 1.0));
      expect(plan['goalCalories'], closeTo(expectedTDEE, 1.0));
    });

    test('Calculates correctly for Female, Very Active, Lose', () {
      final profile = {
        'gender': 'Female',
        'birthYear': 1995,
        'heightCm': 165.0,
        'weightKg': 60.0,
        'activityLevel': 'Very active',
        'goal': 'Lose',
      };

      // Mifflin-St Jeor:
      // 10*60 + 6.25*165 - 5*age - 161
      final currentYear = DateTime.now().year;
      final age = currentYear - 1995;
      final expectedBMR = (10 * 60) + (6.25 * 165) - (5 * age) - 161;
      // Very active = 1.725
      final expectedTDEE = expectedBMR * 1.725;
      // Lose = -500
      final expectedGoal = expectedTDEE - 500;

      final plan = PlanGenerator.generateLocalPlan(profile);

      expect(plan['bmr'], closeTo(expectedBMR, 1.0));
      expect(plan['tdee'], closeTo(expectedTDEE, 1.0));
      expect(plan['goalCalories'], closeTo(expectedGoal, 1.0));
    });
  });
}
