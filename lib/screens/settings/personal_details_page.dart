import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physiq/theme/design_system.dart';
import 'package:physiq/services/user_repository.dart';
import 'package:physiq/widgets/settings/settings_widgets.dart';
import 'package:physiq/screens/settings/edit_personal_details_pages.dart';

class PersonalDetailsPage extends ConsumerWidget {
  const PersonalDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRepo = ref.watch(userRepositoryProvider);
    // In a real app, use a stream or FutureProvider for user data
    // For now, we'll assume we can get the current user or show loading
    // This is a placeholder for the actual data fetching logic
    
    // Mocking user data for display if repo is not fully wired for synchronous access
    // In production, use ref.watch(userProvider)
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Personal Details', style: AppTextStyles.heading2),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.primaryText),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildDetailCard(
              context,
              title: 'Goal Weight',
              value: '70 kg', // Replace with dynamic data
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditGoalWeightPage())),
            ),
            _buildDetailCard(
              context,
              title: 'Current Weight',
              value: '75 kg', // Replace with dynamic data
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditHeightWeightPage())),
            ),
            _buildDetailCard(
              context,
              title: 'Height',
              value: '180 cm', // Replace with dynamic data
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditHeightWeightPage())),
            ),
            _buildDetailCard(
              context,
              title: 'Birth Year',
              value: '1995', // Replace with dynamic data
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditBirthYearPage())),
            ),
            _buildDetailCard(
              context,
              title: 'Gender',
              value: 'Male', // Replace with dynamic data
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditGenderPage())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context, {required String title, required String value, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadii.card),
        boxShadow: [AppShadows.card],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.card),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.label),
                    const SizedBox(height: 4),
                    Text(value, style: AppTextStyles.heading2),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, size: 16, color: AppColors.primaryText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
