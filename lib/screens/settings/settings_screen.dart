import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physiq/theme/design_system.dart';
import 'package:physiq/services/auth_service.dart';
// import 'package:physiq/services/user_repository.dart';
import 'package:physiq/widgets/settings/settings_widgets.dart';
import 'package:physiq/screens/settings/invite_friends_page.dart';
import 'package:physiq/screens/settings/leaderboard_page.dart';
import 'package:physiq/screens/settings/personal_details_page.dart';
import 'package:physiq/screens/macro_adjustment_screen.dart';
import 'package:physiq/screens/settings/legal_pages.dart';
import 'package:physiq/screens/onboarding/get_started_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:physiq/providers/preferences_provider.dart';
import 'package:physiq/services/support_service.dart';
import 'package:physiq/services/cloud_functions_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _supportService = SupportService();
  final _cloudFunctions = CloudFunctionsClient();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final prefsState = ref.watch(preferencesProvider);
    final isDarkMode = prefsState.themeMode == ThemeMode.dark;
    final language = prefsState.locale.languageCode == 'hi' ? 'Hindi' : 'English';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Settings', style: AppTextStyles.heading2),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // CARD 1: Invite & Leaderboard
            SettingsCard(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  SettingsPillButton(
                    text: 'Invite Friends',
                    icon: Icons.person_add,
                    isPrimary: true,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InviteFriendsPage())),
                  ),
                  const SizedBox(width: 16),
                  SettingsPillButton(
                    text: 'Leaderboard',
                    icon: Icons.leaderboard,
                    isPrimary: false,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardPage())),
                  ),
                ],
              ),
            ),

            // CARD 2: Personal & Preferences
            SettingsCard(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                children: [
                  SettingsRow(
                    icon: Icons.person_outline,
                    title: 'Personal details',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PersonalDetailsPage())),
                  ),
                  _buildDivider(),
                  SettingsRow(
                    icon: Icons.pie_chart_outline,
                    title: 'Adjust macronutrients',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MacroAdjustmentScreen())),
                  ),
                  _buildDivider(),
                  SettingsRow(
                    icon: Icons.language,
                    title: 'Language',
                    subtitle: language,
                    onTap: () => _showLanguageDialog(language),
                  ),
                  _buildDivider(),
                  SettingsRow(
                    icon: isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    title: 'Dark Mode',
                    showChevron: false,
                    trailing: Switch(
                      value: isDarkMode,
                      activeColor: AppColors.primary,
                      onChanged: (val) {
                        ref.read(preferencesProvider.notifier).setThemeMode(val ? ThemeMode.dark : ThemeMode.light);
                      },
                    ),
                  ),
                ],
              ),
            ),

            // CARD 3: Legal, Support & Delete
            SettingsCard(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                children: [
                  SettingsRow(
                    icon: Icons.description_outlined,
                    title: 'Terms & Conditions',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsPage())),
                  ),
                  _buildDivider(),
                  SettingsRow(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPage())),
                  ),
                  _buildDivider(),
                  SettingsRow(
                    icon: Icons.mail_outline,
                    title: 'Support Email',
                    onTap: _sendSupportEmail,
                  ),
                  _buildDivider(),
                  SettingsRow(
                    icon: Icons.feedback_outlined,
                    title: 'Feature Requests',
                    onTap: _showFeatureRequestDialog,
                  ),
                  _buildDivider(),
                  SettingsRow(
                    icon: Icons.delete_outline,
                    title: 'Delete Account',
                    titleColor: Colors.red,
                    showChevron: false,
                    onTap: _confirmDeleteAccount,
                  ),
                ],
              ),
            ),

            // CARD 4: Logout
            SettingsCard(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: SettingsRow(
                icon: Icons.logout,
                title: 'Log out',
                showChevron: false,
                onTap: _confirmLogout,
              ),
            ),
            
            const SizedBox(height: 20),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                final version = snapshot.data?.version ?? '1.0.0';
                return Text('Version $version', style: AppTextStyles.smallLabel);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, color: Color(0xFFF3F4F6), thickness: 1);
  }

  void _showLanguageDialog(String currentLang) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['English', 'Hindi'].map((lang) {
            return RadioListTile<String>(
              title: Text(lang),
              value: lang,
              groupValue: currentLang,
              activeColor: AppColors.primary,
              onChanged: (val) async {
                if (val != null) {
                  final locale = val == 'Hindi' ? const Locale('hi') : const Locale('en');
                  await ref.read(preferencesProvider.notifier).setLocale(locale);
                  if (mounted) Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _sendSupportEmail() async {
    final uid = _auth.currentUser?.uid ?? 'unknown';
    final info = await PackageInfo.fromPlatform();
    try {
      await _supportService.sendSupportEmail(uid, info.version);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch email app: $e')),
        );
      }
    }
  }

  void _showFeatureRequestDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Feature Request'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Describe your idea...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                final uid = _auth.currentUser?.uid;
                if (uid != null) {
                  await _supportService.submitFeatureRequest(uid, 'Feature Request', text);
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Request submitted!')),
                    );
                  }
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Submit', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to permanently delete all your data? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // Show loading
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(child: CircularProgressIndicator()),
              );
              
              try {
                final uid = _auth.currentUser?.uid;
                if (uid != null) {
                  await _cloudFunctions.deleteUserData(uid);
                  await ref.read(preferencesProvider.notifier).clear();
                  await AuthService().signOut();
                  
                  if (mounted) { 
                    Navigator.pop(context); // Pop loading
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const GetStartedScreen()),
                      (route) => false,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Account deleted successfully')),
                    );
                  }
                }
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context); // Pop loading
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Error'),
                      content: Text('Failed to delete account: $e. Please try again later.'),
                      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
                    ),
                  );
                }
              }
            },
            child: const Text('Yes, Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(preferencesProvider.notifier).clear();
              await AuthService().signOut();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const GetStartedScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('Log out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
