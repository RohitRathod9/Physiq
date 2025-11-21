import 'package:flutter/material.dart';

class TargetWeightStep extends StatelessWidget {
  final double? targetWeight;
  final ValueChanged<double> onChanged;

  const TargetWeightStep({super.key, this.targetWeight, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Enter Your Target Weight', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Target Weight (kg)'),
            onChanged: (value) => onChanged(double.tryParse(value) ?? 0),
          ),
        ],
      ),
    );
  }
}
