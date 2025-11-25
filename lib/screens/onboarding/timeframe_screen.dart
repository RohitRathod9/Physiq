
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:physiq/providers/onboarding_provider.dart';
import 'package:physiq/theme/design_system.dart';

class TimeframeScreen extends ConsumerStatefulWidget {
  const TimeframeScreen({super.key});

  @override
  ConsumerState<TimeframeScreen> createState() => _TimeframeScreenState();
}

class _TimeframeScreenState extends ConsumerState<TimeframeScreen> {
  double _months = 6.0;

  void _onContinue() {
    ref.read(onboardingProvider).saveStepData('timeframeMonths', _months.round());
    context.push('/onboarding/result-message');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Spacer(),
            Text(
              "How fast do you want to reach your goal?",
              style: AppTextStyles.h1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Text(
              '${_months.round()} months',
              style: AppTextStyles.largeNumber.copyWith(fontSize: 48),
            ),
            const SizedBox(height: 24),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.black,
                inactiveTrackColor: Colors.grey.shade300,
                thumbColor: Colors.black,
                trackHeight: 6.0,
                overlayColor: Colors.black.withOpacity(0.1),
              ),
              child: Slider(
                value: _months,
                min: 1,
                max: 12,
                divisions: 11,
                onChanged: (val) {
                  setState(() => _months = val);
                },
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Continue'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
