import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physiq/models/exercise_model.dart';
import 'package:physiq/models/exercise_log_model.dart';
import 'package:physiq/services/exercise_repository.dart';
import 'package:physiq/utils/design_system.dart';
import 'package:physiq/utils/metrics_calculator.dart';

class ManualEntryForm extends ConsumerStatefulWidget {
  final Exercise exercise;
  const ManualEntryForm({super.key, required this.exercise});

  @override
  ConsumerState<ManualEntryForm> createState() => _ManualEntryFormState();
}

class _ManualEntryFormState extends ConsumerState<ManualEntryForm> {
  final List<SetEntry> _sets = [];
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();
  
  void _addSet() {
    final reps = int.tryParse(_repsController.text);
    if (reps == null) return;
    
    setState(() {
      _sets.add(SetEntry(
        reps: reps,
        weight: double.tryParse(_weightController.text),
        restSeconds: 60, // Default rest
      ));
      _repsController.clear();
      // Keep weight for next set convenience
    });
  }

  void _saveLog() async {
    if (_sets.isEmpty) return;

    final totalReps = _sets.fold(0, (sum, set) => sum + set.reps);
    // Estimate duration: 2.5s per rep + 60s rest per set
    final durationMin = MetricsCalculator.estimateDurationFromSets(
      totalReps: totalReps,
      totalRestSeconds: (_sets.length - 1) * 60, // Rest between sets
    );

    // Mock weight 70kg
    final calories = MetricsCalculator.calculateCalories(
      met: widget.exercise.defaultMET,
      weightKg: 70,
      durationMinutes: durationMin,
    );

    final log = ExerciseLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      exerciseId: widget.exercise.id,
      title: widget.exercise.title,
      startedAt: DateTime.now().subtract(Duration(minutes: durationMin.round())),
      endedAt: DateTime.now(),
      durationMinutes: durationMin,
      exerciseCalories: calories,
      totalReps: totalReps,
      sets: _sets,
      meta: {'source': 'manual'},
      timezone: DateTime.now().timeZoneName,
    );

    await ref.read(exerciseRepositoryProvider).saveExerciseLog(log);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Log saved!')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add Sets', style: AppTextStyles.heading2),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _repsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Reps',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Weight (kg)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: _addSet,
                icon: const Icon(Icons.add_circle, color: AppColors.accent, size: 32),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_sets.isNotEmpty) ...[
            Text('Current Sets', style: AppTextStyles.bodyBold),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _sets.length,
              itemBuilder: (context, index) {
                final set = _sets[index];
                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text('${set.reps} reps'),
                  subtitle: set.weight != null ? Text('${set.weight} kg') : null,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => setState(() => _sets.removeAt(index)),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveLog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Save Workout', style: AppTextStyles.button.copyWith(color: Colors.white)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
