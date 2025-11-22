import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physiq/models/exercise_model.dart';
import 'package:physiq/services/exercise_repository.dart';
import 'package:physiq/utils/design_system.dart';
import 'package:physiq/screens/exercise/exercise_detail_screen.dart';

class CategoryDetailScreen extends ConsumerStatefulWidget {
  final String category;
  const CategoryDetailScreen({super.key, required this.category});

  @override
  ConsumerState<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends ConsumerState<CategoryDetailScreen> {
  List<Exercise> _exercises = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchExercises();
  }

  Future<void> _fetchExercises() async {
    final exercises = await ref.read(exerciseRepositoryProvider).getExercisesByCategory(widget.category);
    if (mounted) {
      setState(() {
        _exercises = exercises;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.category, style: AppTextStyles.heading2),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryText),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: _exercises.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return _buildExerciseTile(context, _exercises[index]);
              },
            ),
    );
  }

  Widget _buildExerciseTile(BuildContext context, Exercise exercise) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ExerciseDetailScreen(exercise: exercise)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppRadii.smallCard),
          boxShadow: [AppShadows.card],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.image, color: Colors.grey),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(exercise.title, style: AppTextStyles.bodyBold),
                  const SizedBox(height: 4),
                  Text(
                    '~${(exercise.defaultMET * 3.5 * 70 / 200 * 10).round()} kcal / 10 min', // Est for 70kg
                    style: AppTextStyles.smallLabel,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.secondaryText),
          ],
        ),
      ),
    );
  }
}
