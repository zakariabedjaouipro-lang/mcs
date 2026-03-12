/// Settings Screen
/// User settings, preferences, and account management
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/components/loading_button.dart';
import 'package:mcs/core/theme/medical_colors.dart';
import 'package:mcs/core/utils/extensions.dart';
import 'package:mcs/features/localization/presentation/bloc/localization_bloc.dart';
import 'package:mcs/features/localization/presentation/bloc/localization_event.dart';
import 'package:mcs/features/localization/presentation/bloc/localization_state.dart';
import 'package:mcs/features/theme/presentation/bloc/theme_bloc.dart';
import 'package:mcs/features/theme/presentation/bloc/theme_event.dart';
import 'package:mcs/features/theme/presentation/bloc/theme_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({this.isPremium = false, super.key});

  final bool isPremium;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationEnabled = true;
  bool _emailNotificationEnabled = true;
  bool _appointmentReminder = true;
  bool _biometricEnabled = false;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Profile Section
            _buildProfileSection(context),
            const SizedBox(height: 24),

            // Preferences Section
            _buildSectionTitle(context, 'Preferences'),
            _buildThemeToggle(context),
            _buildLanguageToggle(context),
            const Divider(),

            // Notification Settings
            _buildSectionTitle(context, 'Notifications'),
            _buildSwitchTile(
              context,
              title: 'Push Notifications',
              subtitle: 'Receive appointment and message alerts',
              value: _notificationEnabled,
              onChanged: (value) {
                setState(() => _notificationEnabled = value);
              },
            ),
            _buildSwitchTile(
              context,
              title: 'Email Notifications',
              subtitle: 'Get email updates and summaries',
              value: _emailNotificationEnabled,
              onChanged: (value) {
                setState(() => _emailNotificationEnabled = value);
              },
            ),
            _buildSwitchTile(
              context,
              title: 'Appointment Reminders',
              subtitle: 'Remind me before appointments',
              value: _appointmentReminder,
              onChanged: (value) {
                setState(() => _appointmentReminder = value);
              },
            ),
            const Divider(),

            // Security Section
            _buildSectionTitle(context, 'Security'),
            _buildSwitchTile(
              context,
              title: 'Biometric Login',
              subtitle: 'Use fingerprint or face recognition',
              value: _biometricEnabled,
              onChanged: (value) {
                setState(() => _biometricEnabled = value);
              },
            ),
            _buildSettingsTile(
              context,
              icon: Icons.lock,
              title: 'Change Password',
              subtitle: 'Update your account password',
              onTap: () {
                _showChangePasswordDialog(context);
              },
            ),
            const Divider(),

            // Account Section
            _buildSectionTitle(context, 'Account'),
            _buildSettingsTile(
              context,
              icon: Icons.person,
              title: 'Edit Profile',
              subtitle: 'Update your personal information',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit Profile - Coming Soon')),
                );
              },
            ),
            _buildSettingsTile(
              context,
              icon: Icons.privacy_tip,
              title: 'Privacy Policy',
              subtitle: 'Read our privacy terms',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Privacy Policy - Opening')),
                );
              },
            ),
            _buildSettingsTile(
              context,
              icon: Icons.description,
              title: 'Terms of Service',
              subtitle: 'Review our terms and conditions',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Terms of Service - Opening')),
                );
              },
            ),
            const Divider(),

            // About Section
            _buildSectionTitle(context, 'About'),
            _buildInfoTile(
              context,
              icon: Icons.info,
              title: 'App Version',
              subtitle: 'v1.0.0',
            ),
            _buildInfoTile(
              context,
              icon: Icons.business,
              title: 'Developer',
              subtitle: 'Medical Clinic Management System',
            ),
            const Divider(),

            // Logout Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: LoadingButton(
                onPressed: () async {
                  // Simulate logout API call
                  await Future<void>.delayed(const Duration(seconds: 1));
                  if (!mounted) return;
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logged out successfully')),
                    );
                  }
                },
                label: 'Logout',
                variant: LoadingButtonVariant.secondary,
                icon: Icons.logout,
                fullWidth: true,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MedicalColors.primary.withValues(alpha: 0.2),
        ),
        color: MedicalColors.primary.withValues(alpha: 0.05),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: MedicalColors.primary,
            ),
            child: const Center(
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dr. Ahmed Al-Mansoori',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'General Practitioner',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ahmed.mansoori@clinic.ae',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final isDark = context.isDarkMode;
        return _buildSettingsTile(
          context,
          icon: isDark ? Icons.dark_mode : Icons.light_mode,
          title: 'Theme',
          subtitle: isDark ? 'Dark Mode' : 'Light Mode',
          trailing: Switch(
            value: isDark,
            activeThumbColor: MedicalColors.primary,
            onChanged: (value) {
              context.read<ThemeBloc>().add(
                    SetThemeModeEvent(
                      value ? ThemeMode.dark : ThemeMode.light,
                    ),
                  );
            },
          ),
          onTap: () {
            context.read<ThemeBloc>().add(
                  const ToggleThemeEvent(),
                );
          },
        );
      },
    );
  }

  Widget _buildLanguageToggle(BuildContext context) {
    return BlocBuilder<LocalizationBloc, LocalizationState>(
      builder: (context, state) {
        final isArabic = state is LanguageArabicState ||
            (state is LanguageChanged && state.languageCode == 'ar');
        return _buildSettingsTile(
          context,
          icon: Icons.language,
          title: 'Language',
          subtitle: isArabic ? 'العربية' : 'English',
          trailing: GestureDetector(
            onTap: () {
              context.read<LocalizationBloc>().add(
                    SetLanguageEvent(isArabic ? 'en' : 'ar'),
                  );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: MedicalColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isArabic ? 'En' : 'العربية',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: MedicalColors.primary,
                ),
              ),
            ),
          ),
          onTap: () {
            context.read<LocalizationBloc>().add(
                  SetLanguageEvent(isArabic ? 'en' : 'ar'),
                );
          },
        );
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: MedicalColors.primary,
              ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: MedicalColors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: MedicalColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: MedicalColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
            trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.grey[600],
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password updated successfully'),
                    ),
                  );
                },
                child: const Text('Update'),
              ),
            ),
          ],
        );
      },
    );
  }
}
