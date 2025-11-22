import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physiq/services/user_repository.dart';
import 'package:physiq/utils/design_system.dart';

class PersonalDetailsSheet extends ConsumerStatefulWidget {
  const PersonalDetailsSheet({super.key});

  @override
  ConsumerState<PersonalDetailsSheet> createState() => _PersonalDetailsSheetState();
}

class _PersonalDetailsSheetState extends ConsumerState<PersonalDetailsSheet> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _nameController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _goalWeightController = TextEditingController();
  final _birthYearController = TextEditingController();
  String _gender = 'male';
  
  @override
  void initState() {
    super.initState();
    // In real app, populate from provider
    _nameController.text = 'Rohit';
    _heightController.text = '175';
    _weightController.text = '70';
    _goalWeightController.text = '80';
    _birthYearController.text = '2001';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24, 
        right: 24, 
        top: 24, 
        bottom: MediaQuery.of(context).viewInsets.bottom + 24
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text('Personal Details', style: AppTextStyles.heading2),
              const SizedBox(height: 24),
              _buildTextField('Display Name', _nameController),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Height (cm)', _heightController, isNumber: true)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('Current Weight (kg)', _weightController, isNumber: true)),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField('Goal Weight (kg)', _goalWeightController, isNumber: true),
              const SizedBox(height: 16),
              Row(
                children: [
                   Expanded(child: _buildTextField('Birth Year', _birthYearController, isNumber: true)),
                   const SizedBox(width: 16),
                   Expanded(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text('Gender', style: AppTextStyles.label),
                         const SizedBox(height: 8),
                         Container(
                           padding: const EdgeInsets.symmetric(horizontal: 12),
                           decoration: BoxDecoration(
                             color: AppColors.card,
                             borderRadius: BorderRadius.circular(12),
                           ),
                           child: DropdownButtonHideUnderline(
                             child: DropdownButton<String>(
                               value: _gender,
                               isExpanded: true,
                               items: const [
                                 DropdownMenuItem(value: 'male', child: Text('Male')),
                                 DropdownMenuItem(value: 'female', child: Text('Female')),
                               ],
                               onChanged: (val) => setState(() => _gender = val!),
                             ),
                           ),
                         ),
                       ],
                     ),
                   ),
                ],
              ),
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
                  child: Text('Save Changes', style: AppTextStyles.button.copyWith(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
      ],
    );
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'displayName': _nameController.text,
        'heightCm': double.tryParse(_heightController.text),
        'weightKg': double.tryParse(_weightController.text),
        'goalWeightKg': double.tryParse(_goalWeightController.text),
        'birthYear': int.tryParse(_birthYearController.text),
        'gender': _gender,
      };
      
      await ref.read(userRepositoryProvider).updateUser('uid', data); // Use real UID
      
      if (mounted) {
        final shouldRecalculate = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Update Nutrition Plan?'),
            content: const Text('You changed your personal details. Do you want to recalculate your daily calorie and macro goals?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('No, keep current'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Yes, recalculate'),
              ),
            ],
          ),
        );

        if (shouldRecalculate == true) {
          await ref.read(userRepositoryProvider).generateCanonicalPlan();
          if (mounted) {
             ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nutrition goals updated!')),
            );
          }
        }
        if (mounted) Navigator.pop(context);
      }
    }
  }
}
