import 'package:flutter/material.dart';

class GoalStep extends StatelessWidget {
  final String? goal;
  final ValueChanged<String> onChanged;

  const GoalStep({super.key, this.goal, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('What is Your Goal?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          RadioListTile<String>(
            title: const Text('Lose Weight'),
            value: 'lose_weight',
            groupValue: goal,
            onChanged: (value) => onChanged(value!),
          ),
          RadioListTile<String>(
            title: const Text('Maintain Weight'),
            value: 'maintain_weight',
            groupValue: goal,
            onChanged: (value) => onChanged(value!),
          ),
          RadioListTile<String>(
            title: const Text('Gain Weight'),
            value: 'gain_weight',
            groupValue: goal,
            onChanged: (value) => onChanged(value!),
          ),
        ],
      ),
    );
  }
}
