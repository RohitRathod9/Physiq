import 'package:flutter/material.dart';
import 'package:physiq/theme/design_system.dart';

class TargetWeightStep extends StatefulWidget {
  final double? targetWeight; // always in kg
  final bool isMetric;
  final ValueChanged<double> onChanged;

  const TargetWeightStep({
    super.key,
    this.targetWeight,
    required this.isMetric,
    required this.onChanged,
  });

  @override
  State<TargetWeightStep> createState() => _TargetWeightStepState();
}

class _TargetWeightStepState extends State<TargetWeightStep> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _updateController();
  }

  @override
  void didUpdateWidget(TargetWeightStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isMetric != widget.isMetric || oldWidget.targetWeight != widget.targetWeight) {
      // Only update controller if the value changed externally or unit changed
      // Avoid overwriting user input if they are typing
      // But here we need to handle unit conversion display
       if (oldWidget.isMetric != widget.isMetric) {
         _updateController();
       }
    }
  }

  void _updateController() {
    if (widget.targetWeight == null) {
      _controller = TextEditingController();
      return;
    }

    if (widget.isMetric) {
      _controller = TextEditingController(text: widget.targetWeight!.toStringAsFixed(1));
    } else {
      double lbs = widget.targetWeight! * 2.20462;
      _controller = TextEditingController(text: lbs.toStringAsFixed(1));
    }
  }

  void _onChanged(String value) {
    double val = double.tryParse(value) ?? 0;
    if (val == 0) return;

    if (widget.isMetric) {
      widget.onChanged(val);
    } else {
      widget.onChanged(val / 2.20462);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Target Weight', style: AppTextStyles.h2),
          const SizedBox(height: 8),
          Text(
            'What is your goal weight?',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: widget.isMetric ? 'Target Weight (kg)' : 'Target Weight (lbs)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: _onChanged,
          ),
        ],
      ),
    );
  }
}
