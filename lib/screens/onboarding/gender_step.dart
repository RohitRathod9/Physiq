import 'package:flutter/material.dart';

class GenderStep extends StatelessWidget {
  final String? gender;
  final ValueChanged<String> onChanged;

  const GenderStep({super.key, this.gender, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Select Your Gender', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          RadioListTile<String>(
            title: const Text('Male'),
            value: 'male',
            groupValue: gender,
            onChanged: (value) => onChanged(value!),
          ),
          RadioListTile<String>(
            title: const Text('Female'),
            value: 'female',
            groupValue: gender,
            onChanged: (value) => onChanged(value!),
          ),
        ],
      ),
    );
  }
}
