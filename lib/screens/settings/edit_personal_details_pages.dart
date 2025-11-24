import 'package:flutter/material.dart';
import 'package:physiq/theme/design_system.dart';

// --- Edit Goal Weight ---
class EditGoalWeightPage extends StatefulWidget {
  const EditGoalWeightPage({super.key});

  @override
  State<EditGoalWeightPage> createState() => _EditGoalWeightPageState();
}

class _EditGoalWeightPageState extends State<EditGoalWeightPage> {
  double _currentValue = 70.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Goal Weight', style: AppTextStyles.heading2),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.primaryText),
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Text('${_currentValue.toStringAsFixed(1)} kg', style: AppTextStyles.largeNumber),
          const SizedBox(height: 40),
          Slider(
            value: _currentValue,
            min: 40,
            max: 150,
            activeColor: AppColors.primary,
            inactiveColor: Colors.grey[300],
            onChanged: (val) => setState(() => _currentValue = val),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text('Save', style: AppTextStyles.button.copyWith(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Edit Height & Weight ---
class EditHeightWeightPage extends StatelessWidget {
  const EditHeightWeightPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Height & Weight', style: AppTextStyles.heading2),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.primaryText),
      ),
      body: Center(child: Text('Height & Weight Picker UI Placeholder', style: AppTextStyles.bodyMedium)),
      // Implement actual pickers here similar to onboarding
    );
  }
}

// --- Edit Birth Year ---
class EditBirthYearPage extends StatelessWidget {
  const EditBirthYearPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Birth Year', style: AppTextStyles.heading2),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.primaryText),
      ),
      body: Center(child: Text('Year Picker UI Placeholder', style: AppTextStyles.bodyMedium)),
    );
  }
}

// --- Edit Gender ---
class EditGenderPage extends StatefulWidget {
  const EditGenderPage({super.key});

  @override
  State<EditGenderPage> createState() => _EditGenderPageState();
}

class _EditGenderPageState extends State<EditGenderPage> {
  String _selected = 'Male';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Gender', style: AppTextStyles.heading2),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.primaryText),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: ['Male', 'Female', 'Other'].map((gender) {
            final isSelected = _selected == gender;
            return GestureDetector(
              onTap: () => setState(() => _selected = gender),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.card,
                  borderRadius: BorderRadius.circular(AppRadii.card),
                  boxShadow: [AppShadows.card],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      gender,
                      style: AppTextStyles.bodyBold.copyWith(
                        color: isSelected ? Colors.white : AppColors.primaryText,
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check, color: Colors.white),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: Text('Save', style: AppTextStyles.button.copyWith(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
