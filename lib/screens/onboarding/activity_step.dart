import 'package:flutter/material.dart';

class ActivityStep extends StatelessWidget {
  final String? activityLevel;
  final ValueChanged<String> onChanged;

  const ActivityStep({super.key, this.activityLevel, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Select Your Activity Level', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          RadioListTile<String>(
            title: const Text('Sedentary'),
            value: 'sedentary',
            groupValue: activityLevel,
            onChanged: (value) => onChanged(value!),
          ),
          RadioListTile<String>(
            title: const Text('Lightly Active'),
            value: 'lightly_active',
            groupValue: activityLevel,
            onChanged: (value) => onChanged(value!),
          ),
          RadioListTile<String>(
            title: const Text('Moderately Active'),
            value: 'moderately_active',
            groupValue: activityLevel,
            onChanged: (value) => onChanged(value!),
          ),
          RadioListTile<String>(
            title: const Text('Very Active'),
            value: 'very_active',
            groupValue: activityLevel,
            onChanged: (value) => onChanged(value!),
          ),
        ],
      ),
    );
  }
}
