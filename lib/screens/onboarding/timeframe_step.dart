import 'package:flutter/material.dart';

class TimeframeStep extends StatelessWidget {
  final String? timeframe;
  final ValueChanged<String> onChanged;

  const TimeframeStep({super.key, this.timeframe, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Select Your Timeframe', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          RadioListTile<String>(
            title: const Text('3 Months'),
            value: '3_months',
            groupValue: timeframe,
            onChanged: (value) => onChanged(value!),
          ),
          RadioListTile<String>(
            title: const Text('6 Months'),
            value: '6_months',
            groupValue: timeframe,
            onChanged: (value) => onChanged(value!),
          ),
          RadioListTile<String>(
            title: const Text('1 Year'),
            value: '1_year',
            groupValue: timeframe,
            onChanged: (value) => onChanged(value!),
          ),
        ],
      ),
    );
  }
}
