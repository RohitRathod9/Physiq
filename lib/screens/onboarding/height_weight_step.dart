import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:physiq/theme/design_system.dart';
import 'dart:math';

class HeightWeightStep extends StatefulWidget {
  final double? height;
  final double? weight;
  final bool isMetric;
  final Function(double, double) onChanged;
  final ValueChanged<bool>? onUnitChanged;

  const HeightWeightStep({
    super.key,
    this.height,
    this.weight,
    required this.isMetric,
    required this.onChanged,
    this.onUnitChanged,
  });

  @override
  State<HeightWeightStep> createState() => _HeightWeightStepState();
}

class _HeightWeightStepState extends State<HeightWeightStep> {
  late FixedExtentScrollController _heightController;
  late FixedExtentScrollController _weightController;

  // Ranges
  final List<int> _cmValues = List.generate(151, (index) => 100 + index); // 100-250 cm
  final List<int> _inValues = List.generate(61, (index) => 36 + index);  // 36-96 inches (3'0" - 8'0")

  final List<int> _kgValues = List.generate(171, (index) => 30 + index); // 30-200 kg
  final List<int> _lbsValues = List.generate(391, (index) => 60 + index); // 60-450 lbs

  // Conversion factors
  static const double _cmToIn = 0.393701;
  static const double _inToCm = 2.54;
  static const double _kgToLbs = 2.20462;
  static const double _lbsToKg = 0.453592;

  // Default values
  static const double _defaultCm = 165;
  static const double _defaultIn = 65; // 5'5"
  static const double _defaultKg = 60;
  static const double _defaultLbs = 132;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    // Height
    int heightIndex = _getInitialIndex(
      isMetric: widget.isMetric,
      metricValue: widget.height,
      imperialValue: widget.height,
      metricList: _cmValues,
      imperialList: _inValues,
      defaultMetric: _defaultCm,
      defaultImperial: _defaultIn,
    );
    _heightController = FixedExtentScrollController(initialItem: heightIndex);

    // Weight
    int weightIndex = _getInitialIndex(
      isMetric: widget.isMetric,
      metricValue: widget.weight,
      imperialValue: widget.weight,
      metricList: _kgValues,
      imperialList: _lbsValues,
      defaultMetric: _defaultKg,
      defaultImperial: _defaultLbs,
    );
    _weightController = FixedExtentScrollController(initialItem: weightIndex);
  }

  int _getInitialIndex({
    required bool isMetric,
    double? metricValue,
    double? imperialValue,
    required List<int> metricList,
    required List<int> imperialList,
    required double defaultMetric,
    required double defaultImperial,
  }) {
    double? value = isMetric ? metricValue : imperialValue;
    List<int> list = isMetric ? metricList : imperialList;
    double defaultValue = isMetric ? defaultMetric : defaultImperial;

    int index = -1;
    if (value != null) {
      index = list.indexOf(value.round());
    }

    if (index == -1) {
      index = list.indexOf(defaultValue.round());
    }

    return max(0, index); // Ensure index is not negative
  }

  @override
  void didUpdateWidget(HeightWeightStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isMetric != widget.isMetric) {
      // Unit changed, re-initialize controllers to reflect converted values
      _initControllers();
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _onHeightChanged(int index) {
    double currentHeight;
    double currentWeight = widget.weight ?? (widget.isMetric ? _defaultKg : _defaultLbs);

    if (widget.isMetric) {
      currentHeight = _cmValues[index].toDouble();
    } else {
      currentHeight = _inValues[index].toDouble();
    }

    // Pass both metric and imperial original values to parent
    double heightToStore = widget.isMetric ? currentHeight : currentHeight * _inToCm;
    double weightToStore = widget.isMetric ? currentWeight : currentWeight * _lbsToKg;

    widget.onChanged(heightToStore, weightToStore);
  }

  void _onWeightChanged(int index) {
    double currentWeight;
    double currentHeight = widget.height ?? (widget.isMetric ? _defaultCm : _defaultIn);

    if (widget.isMetric) {
      currentWeight = _kgValues[index].toDouble();
    } else {
      currentWeight = _lbsValues[index].toDouble();
    }

    // Pass both metric and imperial original values to parent
    double heightToStore = widget.isMetric ? currentHeight : currentHeight * _inToCm;
    double weightToStore = widget.isMetric ? currentWeight : currentWeight * _lbsToKg;

    widget.onChanged(heightToStore, weightToStore);
  }

  void _handleUnitChange(bool isNowMetric) {
    if (widget.onUnitChanged == null) return;

    // Get current raw values from the pickers
    double currentHeight = widget.isMetric
        ? _cmValues[_heightController.selectedItem].toDouble()
        : _inValues[_heightController.selectedItem].toDouble();

    double currentWeight = widget.isMetric
        ? _kgValues[_weightController.selectedItem].toDouble()
        : _lbsValues[_weightController.selectedItem].toDouble();

    double heightInCm, weightInKg;

    if (widget.isMetric) { // Was metric, now converting to imperial
      heightInCm = currentHeight;
      weightInKg = currentWeight;
    } else { // Was imperial, now converting to metric
      heightInCm = currentHeight * _inToCm;
      weightInKg = currentWeight * _lbsToKg;
    }

    // Notify parent of the new unit and the converted values
    widget.onUnitChanged!(isNowMetric);
    widget.onChanged(heightInCm, weightInKg);
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Text('Height & Weight', style: AppTextStyles.h1),
          const SizedBox(height: 16),
          // Unit Toggle
          if (widget.onUnitChanged != null)
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildToggleOption('Metric', widget.isMetric),
                  _buildToggleOption('Imperial', !widget.isMetric),
                ],
              ),
            ),
          const SizedBox(height: 32),

          Expanded(
            child: Row(
              children: [
                // Height Picker
                Expanded(
                  child: Column(
                    children: [
                      Text('Height', style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      Expanded(
                        child: CupertinoPicker(
                          scrollController: _heightController,
                          itemExtent: 40,
                          onSelectedItemChanged: _onHeightChanged,
                          selectionOverlay: Container(
                            decoration: BoxDecoration(
                              border: Border.symmetric(
                                horizontal: BorderSide(color: AppColors.primary.withOpacity(0.2)),
                              ),
                            ),
                          ),
                          children: widget.isMetric
                              ? _cmValues.map((h) => Center(child: Text('$h cm', style: AppTextStyles.h3))).toList()
                              : _inValues.map((h) {
                            final ft = h ~/ 12;
                            final inch = h % 12;
                            return Center(child: Text('$ft\' $inch"', style: AppTextStyles.h3));
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                // Weight Picker
                Expanded(
                  child: Column(
                    children: [
                      Text('Weight', style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      Expanded(
                        child: CupertinoPicker(
                          scrollController: _weightController,
                          itemExtent: 40,
                          onSelectedItemChanged: _onWeightChanged,
                          selectionOverlay: Container(
                            decoration: BoxDecoration(
                              border: Border.symmetric(
                                horizontal: BorderSide(color: AppColors.primary.withOpacity(0.2)),
                              ),
                            ),
                          ),
                          children: widget.isMetric
                              ? _kgValues.map((w) => Center(child: Text('$w kg', style: AppTextStyles.h3))).toList()
                              : _lbsValues.map((w) => Center(child: Text('$w lbs', style: AppTextStyles.h3))).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          _handleUnitChange(text == 'Metric');
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)]
              : null,
        ),
        child: Text(
          text,
          style: AppTextStyles.body.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
