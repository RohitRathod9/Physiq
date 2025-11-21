import 'package:flutter/material.dart';

class BirthYearStep extends StatelessWidget {
  final int? birthYear;
  final ValueChanged<int> onChanged;

  const BirthYearStep({super.key, this.birthYear, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Enter Your Birth Year', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Birth Year'),
            onChanged: (value) => onChanged(int.tryParse(value) ?? 0),
          ),
        ],
      ),
    );
  }
}
