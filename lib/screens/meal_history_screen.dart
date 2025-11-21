import 'package:flutter/material.dart';

class MealHistoryScreen extends StatelessWidget {
  const MealHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meal History')),
      body: const Center(
        child: Text('A list of all meals will be displayed here.'),
      ),
    );
  }
}
