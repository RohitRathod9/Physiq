
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:physiq/providers/onboarding_provider.dart';
import 'package:physiq/services/plan_generator.dart';
import 'package:physiq/theme/design_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GeneratePlanScreen extends ConsumerWidget {
  const GeneratePlanScreen({super.key});

  Future<void> _onConfirm(BuildContext context, WidgetRef ref) async {
    final store = ref.read(onboardingProvider);
    
    // Generate local plan
    final profile = store.data;
    final plan = PlanGenerator.generateLocalPlan(profile);
    
    // Save plan to store/draft
    await store.saveStepData('currentPlan', plan);
    
    // Save to Firestore if signed in
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          ...profile,
          'currentPlan': plan,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (e) {
        print('Error saving to Firestore: $e');
      }
    }

    // Navigate to loading to simulate/perform server generation
    if (context.mounted) {
      context.push('/onboarding/loading');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(onboardingProvider);
    
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
              "Ready to build your plan?",
              style: AppTextStyles.h1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildSummaryItem('Goal', store.goal ?? '-'),
            _buildSummaryItem('Current Weight', '${store.weightKg?.toStringAsFixed(1)} kg'),
            _buildSummaryItem('Target Weight', '${store.targetWeightKg?.toStringAsFixed(1)} kg'),
            _buildSummaryItem('Activity', store.activityLevel ?? '-'),
            _buildSummaryItem('Diet', store.dietPreference ?? '-'),
            
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _onConfirm(context, ref),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Generate Plan'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body.copyWith(color: AppColors.secondaryText)),
          Text(value, style: AppTextStyles.bodyBold),
        ],
      ),
    );
  }
}
