import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physiq/services/user_repository.dart';
import 'package:physiq/utils/design_system.dart';

class MacroAdjustmentScreen extends ConsumerStatefulWidget {
  const MacroAdjustmentScreen({super.key});

  @override
  ConsumerState<MacroAdjustmentScreen> createState() => _MacroAdjustmentScreenState();
}

class _MacroAdjustmentScreenState extends ConsumerState<MacroAdjustmentScreen> {
  final _caloriesController = TextEditingController(text: '2000');
  final _proteinController = TextEditingController(text: '150');
  final _carbsController = TextEditingController(text: '200');
  final _fatsController = TextEditingController(text: '65');
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Adjust Macros', style: AppTextStyles.heading2),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryText),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMacroInput('Calories (kcal)', _caloriesController),
            const SizedBox(height: 16),
            _buildMacroInput('Protein (g)', _proteinController),
            const SizedBox(height: 16),
            _buildMacroInput('Carbs (g)', _carbsController),
            const SizedBox(height: 16),
            _buildMacroInput('Fats (g)', _fatsController),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Save Custom Goals', style: AppTextStyles.button.copyWith(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: _openAutoGenerate,
                child: Text('Auto-Generate Goals', style: AppTextStyles.button.copyWith(color: AppColors.accent)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroInput(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  void _save() {
    // Save logic
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Custom goals saved!')),
    );
  }

  void _openAutoGenerate() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _AutoGenerateStepper(),
    );
  }
}

class _AutoGenerateStepper extends ConsumerStatefulWidget {
  const _AutoGenerateStepper();

  @override
  ConsumerState<_AutoGenerateStepper> createState() => _AutoGenerateStepperState();
}

class _AutoGenerateStepperState extends ConsumerState<_AutoGenerateStepper> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text('Auto-Generate Goals', style: AppTextStyles.heading2),
          Expanded(
            child: Stepper(
              type: StepperType.vertical,
              currentStep: _currentStep,
              onStepContinue: () async {
                if (_currentStep < 2) {
                  setState(() => _currentStep += 1);
                } else {
                  // Generate plan
                  await ref.read(userRepositoryProvider).generateCanonicalPlan();
                  if (mounted) {
                    Navigator.pop(context);
                    // Also pop the screen to return to settings, or stay to show updated values
                    Navigator.pop(context); 
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Plan auto-generated!')),
                    );
                  }
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() => _currentStep -= 1);
                } else {
                  Navigator.pop(context);
                }
              },
              steps: [
                Step(
                  title: const Text('Activity Level'),
                  content: const Text('How active are you? (Sedentary, Active, etc.)'),
                  isActive: _currentStep >= 0,
                ),
                Step(
                  title: const Text('Goal'),
                  content: const Text('Lose weight, Maintain, Gain muscle?'),
                  isActive: _currentStep >= 1,
                ),
                Step(
                  title: const Text('Confirm'),
                  content: const Text('Ready to generate your plan?'),
                  isActive: _currentStep >= 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
