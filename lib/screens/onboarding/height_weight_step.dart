import 'package:flutter/material.dart';
import 'package:physiq/theme/design_system.dart';

class HeightWeightStep extends StatefulWidget {
  final double? height; // always in cm
  final double? weight; // always in kg
  final bool isMetric;
  final ValueChanged<bool> onMetricChanged;
  final Function(double, double) onChanged;

  const HeightWeightStep({
    super.key,
    this.height,
    this.weight,
    required this.isMetric,
    required this.onMetricChanged,
    required this.onChanged,
  });

  @override
  State<HeightWeightStep> createState() => _HeightWeightStepState();
}

class _HeightWeightStepState extends State<HeightWeightStep> {
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  
  // Imperial controllers
  late TextEditingController _ftController;
  late TextEditingController _inController;
  late TextEditingController _lbsController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    // Metric
    _heightController = TextEditingController(text: widget.height?.toStringAsFixed(0) ?? '');
    _weightController = TextEditingController(text: widget.weight?.toStringAsFixed(1) ?? '');

    // Imperial
    if (widget.height != null) {
      double inchesTotal = widget.height! / 2.54;
      int feet = (inchesTotal / 12).floor();
      int inches = (inchesTotal % 12).round();
      _ftController = TextEditingController(text: feet.toString());
      _inController = TextEditingController(text: inches.toString());
    } else {
      _ftController = TextEditingController();
      _inController = TextEditingController();
    }

    if (widget.weight != null) {
      double lbs = widget.weight! * 2.20462;
      _lbsController = TextEditingController(text: lbs.toStringAsFixed(1));
    } else {
      _lbsController = TextEditingController();
    }
  }

  @override
  void didUpdateWidget(HeightWeightStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isMetric != widget.isMetric) {
      // Update controllers when unit changes to reflect current stored value
      _initializeControllers();
    }
  }

  void _onMetricChanged(String value, bool isHeight) {
    double h = widget.height ?? 0;
    double w = widget.weight ?? 0;

    if (isHeight) {
      h = double.tryParse(value) ?? 0;
    } else {
      w = double.tryParse(value) ?? 0;
    }
    widget.onChanged(h, w);
  }

  void _onImperialChanged() {
    double h = widget.height ?? 0;
    double w = widget.weight ?? 0;

    // Calculate Height
    int ft = int.tryParse(_ftController.text) ?? 0;
    int inches = int.tryParse(_inController.text) ?? 0;
    if (ft > 0 || inches > 0) {
      h = ((ft * 12) + inches) * 2.54;
    }

    // Calculate Weight
    double lbs = double.tryParse(_lbsController.text) ?? 0;
    if (lbs > 0) {
      w = lbs / 2.20462;
    }

    widget.onChanged(h, w);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Height & Weight', style: AppTextStyles.h2),
          const SizedBox(height: 8),
          Text(
            'This will be taken into account when calculating your daily nutrition goals.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          
          // Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Imperial'),
              Switch(
                value: widget.isMetric,
                onChanged: widget.onMetricChanged,
                activeColor: AppColors.primary,
              ),
              const Text('Metric'),
            ],
          ),
          const SizedBox(height: 24),

          if (widget.isMetric) ...[
            _buildTextField(
              controller: _heightController,
              label: 'Height (cm)',
              onChanged: (val) => _onMetricChanged(val, true),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _weightController,
              label: 'Weight (kg)',
              onChanged: (val) => _onMetricChanged(val, false),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _ftController,
                    label: 'Height (ft)',
                    onChanged: (_) => _onImperialChanged(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _inController,
                    label: 'Height (in)',
                    onChanged: (_) => _onImperialChanged(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _lbsController,
              label: 'Weight (lbs)',
              onChanged: (_) => _onImperialChanged(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: onChanged,
    );
  }
}
