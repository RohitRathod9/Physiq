import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physiq/models/exercise_model.dart';
import 'package:physiq/models/exercise_log_model.dart';
import 'package:physiq/services/exercise_repository.dart';
import 'package:physiq/utils/design_system.dart';
import 'package:physiq/utils/metrics_calculator.dart';

class ExerciseTimer extends ConsumerStatefulWidget {
  final Exercise exercise;
  const ExerciseTimer({super.key, required this.exercise});

  @override
  ConsumerState<ExerciseTimer> createState() => _ExerciseTimerState();
}

class _ExerciseTimerState extends ConsumerState<ExerciseTimer> {
  // Timer State
  bool _isRunning = false;
  bool _isResting = false;
  int _currentRound = 1;
  int _totalRounds = 3;
  int _workDuration = 30;
  int _restDuration = 15;
  int _timeLeft = 30;
  
  Timer? _timer;
  final DateTime _startedAt = DateTime.now(); // Reset on start
  int _totalWorkSeconds = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
          if (!_isResting) _totalWorkSeconds++;
        });
      } else {
        _handleIntervalComplete();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _handleIntervalComplete() {
    if (_isResting) {
      // Rest done, start next round or finish
      if (_currentRound < _totalRounds) {
        setState(() {
          _currentRound++;
          _isResting = false;
          _timeLeft = _workDuration;
        });
        // Vibrate?
      } else {
        _finishWorkout();
      }
    } else {
      // Work done, start rest
      setState(() {
        _isResting = true;
        _timeLeft = _restDuration;
      });
      // Vibrate?
    }
  }

  void _finishWorkout() {
    _pauseTimer();
    _showSaveDialog();
  }

  void _showSaveDialog() {
    final durationMin = _totalWorkSeconds / 60.0;
    // Mock weight 70kg for now, should come from user provider
    final calories = MetricsCalculator.calculateCalories(
      met: widget.exercise.defaultMET,
      weightKg: 70,
      durationMinutes: durationMin,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Workout Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Duration: ${_formatTime(_totalWorkSeconds)}'),
            Text('Calories: ${calories.toStringAsFixed(1)} kcal'),
            const SizedBox(height: 16),
            Text('Great job!', style: AppTextStyles.bodyBold),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              _saveLog(durationMin, calories);
            },
            child: const Text('Save Log'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveLog(double durationMin, double calories) async {
    final log = ExerciseLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      exerciseId: widget.exercise.id,
      title: widget.exercise.title,
      startedAt: _startedAt,
      endedAt: DateTime.now(),
      durationMinutes: durationMin,
      exerciseCalories: calories,
      totalReps: 0, // Timer based
      sets: [],
      meta: {'source': 'timer', 'rounds': _totalRounds},
      timezone: DateTime.now().timeZoneName,
    );

    await ref.read(exerciseRepositoryProvider).saveExerciseLog(log);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Workout saved!')));
      Navigator.pop(context); // Go back to list
    }
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Presets
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPresetChip(20, 10),
              const SizedBox(width: 8),
              _buildPresetChip(30, 15),
              const SizedBox(width: 8),
              _buildPresetChip(40, 20),
            ],
          ),
          const SizedBox(height: 40),
          
          // Timer Display
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _isResting ? Colors.green : AppColors.accent,
                width: 8,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isResting ? 'REST' : 'WORK',
                    style: AppTextStyles.heading2.copyWith(
                      color: _isResting ? Colors.green : AppColors.accent,
                    ),
                  ),
                  Text(
                    _formatTime(_timeLeft),
                    style: AppTextStyles.largeNumber.copyWith(fontSize: 64),
                  ),
                  Text('Round $_currentRound / $_totalRounds', style: AppTextStyles.bodyMedium),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isRunning)
                FloatingActionButton(
                  onPressed: _pauseTimer,
                  backgroundColor: Colors.orange,
                  child: const Icon(Icons.pause),
                )
              else
                FloatingActionButton(
                  onPressed: _startTimer,
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.play_arrow),
                ),
              const SizedBox(width: 24),
              FloatingActionButton(
                onPressed: _finishWorkout,
                backgroundColor: Colors.red,
                child: const Icon(Icons.stop),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(int work, int rest) {
    final isSelected = _workDuration == work && _restDuration == rest;
    return ChoiceChip(
      label: Text('$work/$rest'),
      selected: isSelected,
      onSelected: (selected) {
        if (selected && !_isRunning) {
          setState(() {
            _workDuration = work;
            _restDuration = rest;
            _timeLeft = work;
          });
        }
      },
    );
  }
}
