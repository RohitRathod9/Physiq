import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physiq/theme/design_system.dart';
import 'package:physiq/viewmodels/exercise_viewmodel.dart';
import 'package:physiq/models/exercise_log_model.dart';
import 'package:physiq/screens/exercise/add_burned_calories_screen.dart';

class ExerciseDetailScreen extends ConsumerStatefulWidget {
  final String exerciseId;
  final String name;
  final String category;

  const ExerciseDetailScreen({
    super.key,
    required this.exerciseId,
    required this.name,
    required this.category,
  });

  @override
  ConsumerState<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends ConsumerState<ExerciseDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Timer State
  Timer? _timer;
  int _timeLeft = 30;
  bool _isWork = true;
  int _rounds = 0;
  bool _isRunning = false;
  int _totalDurationSec = 0;

  // Manual State
  final List<Map<String, String>> _sets = [];
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tabController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_timeLeft > 0) {
            _timeLeft--;
            _totalDurationSec++;
          } else {
            // Switch mode
            _isWork = !_isWork;
            _timeLeft = _isWork ? 30 : 10; // Default 30/10
            if (_isWork) _rounds++;
          }
        });
      });
    }
    setState(() => _isRunning = !_isRunning);
  }

  void _addSet() {
    if (_repsController.text.isNotEmpty) {
      setState(() {
        _sets.add({
          'reps': _repsController.text,
          'weight': _weightController.text,
        });
        _repsController.clear();
        _weightController.clear();
      });
    }
  }

  void _onSave() {
    final viewModel = ref.read(exerciseViewModelProvider.notifier);
    const double weightKg = 70.0; // Mock

    int durationMin = 0;
    double calories = 0;

    if (_tabController.index == 0) {
      // Timer mode
      durationMin = (_totalDurationSec / 60).ceil();
      calories = viewModel.estimateCalories(
        exerciseType: 'hiit', // Timer implies HIIT/Circuit
        intensity: 'high',
        durationMinutes: durationMin,
        weightKg: weightKg,
      );
    } else {
      // Manual Sets mode
      // Estimate duration: sets * (reps * 3s + 60s rest)
      // Simple heuristic: 2 mins per set
      durationMin = _sets.length * 2; 
      calories = viewModel.estimateCalories(
        exerciseType: widget.exerciseId, // Specific ID
        intensity: 'medium',
        durationMinutes: durationMin,
        weightKg: weightKg,
      );
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddBurnedCaloriesScreen(
          initialCalories: calories,
          onLog: (finalCalories) {
            viewModel.logExercise(
              userId: 'current_user_id',
              exerciseId: widget.exerciseId,
              name: widget.name,
              type: widget.category == 'home' ? ExerciseType.home : ExerciseType.gym,
              durationMinutes: durationMin,
              calories: finalCalories,
              intensity: 'medium',
              details: {
                'mode': _tabController.index == 0 ? 'timer' : 'sets',
                'rounds': _rounds,
                'sets': _sets,
              },
              isManualOverride: finalCalories != calories,
            );
            Navigator.popUntil(context, (route) => route.isFirst);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Workout logged!')));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.name, style: AppTextStyles.heading2),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.primaryText),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.secondaryText,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Timer'),
            Tab(text: 'Manual Sets'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Timer Tab
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_isWork ? 'WORK' : 'REST', style: AppTextStyles.heading1.copyWith(color: _isWork ? Colors.green : Colors.orange)),
              const SizedBox(height: 20),
              Text('$_timeLeft', style: AppTextStyles.largeNumber.copyWith(fontSize: 80)),
              const SizedBox(height: 20),
              Text('Rounds: $_rounds', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 40),
              FloatingActionButton(
                onPressed: _toggleTimer,
                backgroundColor: AppColors.primary,
                child: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
              ),
            ],
          ),
          // Manual Sets Tab
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _sets.length,
                    itemBuilder: (context, index) {
                      final set = _sets[index];
                      return ListTile(
                        title: Text('Set ${index + 1}'),
                        subtitle: Text('${set['reps']} reps @ ${set['weight']} kg'),
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _repsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Reps'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Weight (kg)'),
                      ),
                    ),
                    IconButton(
                      onPressed: _addSet,
                      icon: const Icon(Icons.add_circle, color: AppColors.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: Text('Finish & Save', style: AppTextStyles.button.copyWith(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
