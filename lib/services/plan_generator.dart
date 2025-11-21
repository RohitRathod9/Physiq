import 'dart:math';

class PlanGenerator {
  /// Generates a plan based on the user's profile.
  /// Returns a map containing the calculated values and the arithmetic trace.
  static Map<String, dynamic> generatePlan({
    required String gender,
    required int age,
    required double heightCm,
    required double weightKg,
    required double activityMultiplier,
    required String goal, // 'gain', 'lose', 'maintain'
  }) {
    final trace = StringBuffer();
    trace.writeln('Profile: $gender, $age, $heightCm cm, $weightKg kg, activity $activityMultiplier, goal $goal');

    // 1. BMR Calculation (Mifflin-St Jeor)
    double bmr;
    if (gender.toLowerCase() == 'male') {
      // BMR = 10 * weight + 6.25 * height - 5 * age + 5
      bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;
      trace.writeln('BMR = 10 * $weightKg + 6.25 * $heightCm - 5 * $age + 5 = $bmr');
    } else {
      // BMR = 10 * weight + 6.25 * height - 5 * age - 161
      bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;
      trace.writeln('BMR = 10 * $weightKg + 6.25 * $heightCm - 5 * $age - 161 = $bmr');
    }
    int bmrRounded = bmr.round();
    trace.writeln('BMR Rounded: $bmrRounded');

    // 2. TDEE Calculation
    double tdee = bmr * activityMultiplier;
    trace.writeln('TDEE = $bmr * $activityMultiplier = $tdee');
    int tdeeRounded = tdee.round();
    trace.writeln('TDEE Rounded: $tdeeRounded');

    // 3. Goal Calories
    double goalCalories;
    double proteinFactor;

    switch (goal.toLowerCase()) {
      case 'gain':
        goalCalories = tdee * 1.15;
        proteinFactor = 1.8;
        trace.writeln('Goal: Gain (+15%)');
        break;
      case 'lose':
        goalCalories = tdee * 0.85;
        proteinFactor = 2.0;
        trace.writeln('Goal: Lose (-15%)');
        break;
      case 'maintain':
      default:
        goalCalories = tdee * 1.0;
        proteinFactor = 1.7; // Default for maintain
        trace.writeln('Goal: Maintain (0%)');
        break;
    }
    trace.writeln('GoalCalories = TDEE * factor = $goalCalories');
    
    // Round GoalCalories to nearest 10 for friendly UI
    int goalCaloriesRounded = (goalCalories / 10).round() * 10;
    trace.writeln('GoalCalories Rounded (nearest 10): $goalCaloriesRounded');

    // 4. Macros
    // Protein
    double proteinG = weightKg * proteinFactor;
    trace.writeln('Protein_g = $weightKg * $proteinFactor = $proteinG');
    int proteinGRounded = proteinG.round();
    double proteinCal = proteinGRounded * 4.0;
    trace.writeln('Protein_cal = $proteinGRounded * 4 = $proteinCal');

    // Fat (Default 25%)
    double fatCal = goalCalories * 0.25;
    trace.writeln('Fat_cal = $goalCalories * 0.25 = $fatCal');
    double fatG = fatCal / 9.0;
    trace.writeln('Fat_g = $fatCal / 9 = $fatG');
    int fatGRounded = fatG.round();
    // Recalculate Fat Cal based on rounded grams for consistency in final sum? 
    // The prompt says "Fat_calories = GoalCalories * 0.25", then "Fat_g = Fat_calories / 9".
    // It doesn't explicitly say to use the rounded grams for the calorie sum, but usually we do.
    // However, for the "Carbs" calculation: "Carbs_calories = GoalCalories - (Protein_calories + Fat_calories)"
    // Let's use the unrounded calories for the subtraction to be more precise to the formula, or the rounded?
    // Prompt trace: "Fat_cal = 699 -> Fat_g ~ 78g". "Carbs_cal = 1672.2 -> Carbs_g ~ 418g".
    // It seems they calculate calories first, then grams.
    // Let's stick to the prompt's flow.
    
    // Carbs
    // Carbs_calories = GoalCalories - (Protein_calories + Fat_calories)
    // Note: The prompt uses "Protein_calories = Protein_g * 4". 
    // It uses the *calculated* protein grams (106.2 -> 106g) -> 424.8 cal.
    // So it uses the rounded protein grams? "Protein_g = 106.2 -> 106 g. Protein_cal = 424.8". 
    // Wait, 106 * 4 = 424. 106.2 * 4 = 424.8. So it uses the unrounded grams for calories?
    // "Protein_g = 106.2 -> 106 g" implies the final output is 106.
    // "Protein_cal = 424.8" implies it used 106.2 * 4.
    
    // Let's follow the prompt trace EXACTLY.
    // Profile: Male, 24, 175 cm, 59.0 kg, activityModerate (1.55), goal = gain +15%
    // BMR = 10*59 + 6.25*175 - 5*24 + 5 = 590 + 1093.75 - 120 + 5 = 1568.75. Correct.
    // TDEE = 1568.75 * 1.55 = 2431.5625. Correct.
    // GoalCalories = 2431.5625 * 1.15 = 2796.296875. Correct.
    // Protein_g = 59.0 * 1.8 = 106.2. Correct.
    // Protein_cal = 106.2 * 4 = 424.8. Correct. (So use unrounded protein g for cal calc)
    // Fat_cal = 2796.296875 * 0.25 = 699.074... -> Prompt says 699.
    // Fat_g = 699 / 9 = 77.66 -> Prompt says ~78.
    // Carbs_cal = 2796.296875 - (424.8 + 699.074...) = 1672.42... -> Prompt says 1672.2.
    // Difference might be rounding of GoalCalories or Fat_cal intermediate.
    // "Round BMR to nearest kcal; round TDEE to nearest kcal; round GoalCalories to nearest 5 or 10".
    // If we round GoalCalories first: 2800.
    // Fat_cal = 2800 * 0.25 = 700.
    // Carbs_cal = 2800 - (424.8 + 700) = 1675.2.
    // The prompt trace numbers are slightly inconsistent with its own rounding rules if applied early.
    // "GoalCalories = 2796.296875 -> 2796 (or 2800 for UI)".
    // It seems the calculation uses the precise or integer-rounded values, not the "friendly UI" values.
    
    // I will use the raw values for calculation to match the trace as closely as possible, 
    // but I will respect the "Round BMR... round TDEE... round GoalCalories" instruction for the final values.
    
    // Let's try to match the trace exactly with specific rounding steps.
    // BMR = 1568.75.
    // TDEE = 2431.5625.
    // GoalCalories = 2796.296875.
    // Protein_g = 106.2. Protein_cal = 424.8.
    // Fat_cal = GoalCalories * 0.25 = 699.07.
    // Carbs_cal = GoalCalories - (Protein_cal + Fat_cal) = 2796.29 - (424.8 + 699.07) = 1672.42.
    
    // The prompt says "Carbs_cal = 1672.2". 
    // This implies GoalCalories might have been used as 2796?
    // 2796 * 0.25 = 699.
    // 2796 - (424.8 + 699) = 1672.2. MATCH!
    
    // So the logic is:
    // 1. Calculate BMR (keep precision).
    // 2. Calculate TDEE (keep precision).
    // 3. Calculate GoalCalories (keep precision).
    // 4. Use GoalCalories *integer* (floor/round?) for macro splits? 
    // The prompt says "GoalCalories = 2796.29... -> 2796". It truncated or rounded to nearest int.
    // Let's use round(). 2796.
    
    // REVISED LOGIC based on trace:
    // 1. BMR (float)
    // 2. TDEE (float)
    // 3. GoalCalories (float) -> Round to Int for macro calc base.
    // 4. Protein_g (float) -> Protein_cal (float).
    // 5. Fat_cal = GoalCalories(Int) * 0.25.
    // 6. Carbs_cal = GoalCalories(Int) - (Protein_cal + Fat_cal).
    
    int goalCaloriesInt = goalCalories.round();
    trace.writeln('Using GoalCalories (Int) for macros: $goalCaloriesInt');

    // Protein
    // Protein_g already calculated as proteinG
    // Protein_cal already calculated as proteinCal (using unrounded proteinG)
    
    // Fat
    double fatCalCalculated = goalCaloriesInt * 0.25;
    trace.writeln('Fat_cal = $goalCaloriesInt * 0.25 = $fatCalCalculated');
    
    // Carbs
    double carbsCalCalculated = goalCaloriesInt - (proteinCal + fatCalCalculated);
    trace.writeln('Carbs_cal = $goalCaloriesInt - ($proteinCal + $fatCalCalculated) = $carbsCalCalculated');
    
    double carbsG = carbsCalCalculated / 4.0;
    trace.writeln('Carbs_g = $carbsCalCalculated / 4 = $carbsG');

    return {
      'bmr': bmrRounded,
      'tdee': tdeeRounded,
      'goalCalories': goalCaloriesRounded, // Friendly UI value
      'goalCaloriesPrecise': goalCaloriesInt, // Value used for calculation
      'proteinG': proteinGRounded,
      'proteinCal': proteinCal,
      'fatG': fatG.round(),
      'fatCal': fatCalCalculated,
      'carbsG': carbsG.round(),
      'carbsCal': carbsCalCalculated,
      'trace': trace.toString(),
    };
  }
}
