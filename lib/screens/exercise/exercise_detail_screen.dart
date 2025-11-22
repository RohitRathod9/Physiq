import 'package:flutter/material.dart';
import 'package:physiq/models/exercise_model.dart';
import 'package:physiq/utils/design_system.dart';
import 'package:physiq/widgets/exercise/exercise_timer.dart';
import 'package:physiq/widgets/exercise/manual_entry_form.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise;
  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.exercise.title, style: AppTextStyles.heading2),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryText),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.accent,
          unselectedLabelColor: AppColors.secondaryText,
          indicatorColor: AppColors.accent,
          tabs: const [
            Tab(text: 'Timer'),
            Tab(text: 'Manual'),
            Tab(text: 'Info'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ExerciseTimer(exercise: widget.exercise),
          ManualEntryForm(exercise: widget.exercise),
          _buildInfoTab(),
        ],
      ),
    );
  }

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Instructions', style: AppTextStyles.heading2),
          const SizedBox(height: 16),
          Text(widget.exercise.instructions, style: AppTextStyles.bodyMedium),
          const SizedBox(height: 24),
          Text('Variations', style: AppTextStyles.heading2),
          const SizedBox(height: 16),
          if (widget.exercise.variations.isEmpty)
            Text('No variations listed.', style: AppTextStyles.bodyMedium)
          else
            ...widget.exercise.variations.map((v) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 8, color: AppColors.accent),
                      const SizedBox(width: 8),
                      Text(v, style: AppTextStyles.bodyMedium),
                    ],
                  ),
                )),
        ],
      ),
    );
  }
}
