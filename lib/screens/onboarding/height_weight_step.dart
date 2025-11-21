import 'package:flutter/material.dart';

class HeightWeightStep extends StatelessWidget {
  final double? height;
  final double? weight;
  final Function(double, double) onChanged;

  const HeightWeightStep({
    super.key,
    this.height,
    this.weight,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Enter Your Height & Weight', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Height (cm)'),
            onChanged: (value) => onChanged(double.tryParse(value) ?? 0, weight ?? 0),
          ),
          const SizedBox(height: 20),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Weight (kg)'),
            onChanged: (value) => onChanged(height ?? 0, double.tryParse(value) ?? 0),
          ),
        ],
      ),
    );
  }
}
