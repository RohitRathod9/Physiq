import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physiq/theme/design_system.dart';
import 'package:physiq/services/auth_service.dart';
import 'package:physiq/services/user_repository.dart';
import 'package:physiq/widgets/settings/settings_widgets.dart';
import 'package:physiq/screens/settings/invite_friends_page.dart';
import 'package:physiq/screens/settings/leaderboard_page.dart';
import 'package:physiq/screens/settings/personal_details_page.dart';
import 'package:physiq/screens/macro_adjustment_screen.dart';
import 'package:physiq/screens/settings/legal_pages.dart';
import 'package:physiq/screens/onboarding/get_started_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isDarkMode = false;
  String _language = 'English';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _language = prefs.getString('language') ?? 'English';
    });
  }

  Future<void> _toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    setState(() {
      _isDarkMode = value;
    });
    // In a real app, you would update a ThemeProvider here
    // ref.read(themeProvider.notifier).toggleTheme(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Settings', style: AppTextStyles.heading2),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Assuming this is a tab or has its own nav
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
                    subtitle: _language,
                    onTap: _showLanguageDialog,
                  ),
                  _buildDivider(),
                  SettingsRow(
                    icon: _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    title: 'Dark Mode',
                    showChevron: false,
                    trailing: Switch(
                      value: _isDarkMode,
                      activeColor: AppColors.primary,
                      onChanged: _toggleTheme,
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
            Text('Version 1.0.0', style: AppTextStyles.smallLabel),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, color: Color(0xFFF3F4F6), thickness: 1);
  }

  void _showLanguageDialog() {
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
              groupValue: _language,
              activeColor: AppColors.primary,
              onChanged: (val) async {
                if (val != null) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('language', val);
                  setState(() => _language = val);
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
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@example.com',
      query: 'subject=Support Request',
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch email app')),
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
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Request submitted!')),
              );
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
        content: const Text('Are you sure you want to permanently delete all your data?'),
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
              
              // Simulate API call
              await Future.delayed(const Duration(seconds: 2));
              
              // Call actual delete API if available
              await ref.read(userRepositoryProvider).deleteAccount();
              
              if (mounted) {
                Navigator.pop(context); // Pop loading
                // Navigate to Get Started
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const GetStartedScreen()),
                  (route) => false,
                );
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
