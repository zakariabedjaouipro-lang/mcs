/// Patient Settings Screen
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/localization/app_localizations.dart';
import 'package:mcs/core/widgets/app_drawer.dart';
import 'package:mcs/core/widgets/language_switcher.dart';
import 'package:mcs/core/widgets/theme_switcher.dart';

/// Patient settings screen
class PatientSettingsScreen extends StatelessWidget {
  const PatientSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('settings')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance Section
          _buildSection(
            context,
            AppLocalizations.of(context).translate('appearance'),
            [
              _buildThemeTile(context),
              _buildLanguageTile(context),
            ],
          ),
          const SizedBox(height: 24),
          
          // Notifications Section
          _buildSection(
            context,
            AppLocalizations.of(context).translate('notifications'),
            [
              _buildNotificationTile(
                context,
                AppLocalizations.of(context).translate('push_notifications'),
                Icons.notifications,
                true,
              ),
              _buildNotificationTile(
                context,
                AppLocalizations.of(context).translate('email_notifications'),
                Icons.email,
                true,
              ),
              _buildNotificationTile(
                context,
                AppLocalizations.of(context).translate('sms_notifications'),
                Icons.sms,
                false,
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Privacy Section
          _buildSection(
            context,
            AppLocalizations.of(context).translate('privacy'),
            [
              _buildPrivacyTile(
                context,
                AppLocalizations.of(context).translate('privacy_policy'),
                Icons.privacy_tip,
              ),
              _buildPrivacyTile(
                context,
                AppLocalizations.of(context).translate('terms_of_service'),
                Icons.description,
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Support Section
          _buildSection(
            context,
            AppLocalizations.of(context).translate('support'),
            [
              _buildSupportTile(
                context,
                AppLocalizations.of(context).translate('help_center'),
                Icons.help,
              ),
              _buildSupportTile(
                context,
                AppLocalizations.of(context).translate('contact_us'),
                Icons.contact_support,
              ),
              _buildSupportTile(
                context,
                AppLocalizations.of(context).translate('report_bug'),
                Icons.bug_report,
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // About Section
          _buildSection(
            context,
            AppLocalizations.of(context).translate('about'),
            [
              _buildAboutTile(context),
            ],
          ),
          const SizedBox(height: 24),
          
          // Logout Button
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(
                AppLocalizations.of(context).translate('logout'),
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () {
                _showLogoutDialog(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeTile(BuildContext context) {
    return const ThemeSwitcherTile();
  }

  Widget _buildLanguageTile(BuildContext context) {
    return const LanguageSwitcherTile();
  }

  Widget _buildNotificationTile(
    BuildContext context,
    String title,
    IconData icon,
    bool value,
  ) {
    return SwitchListTile(
      leading: Icon(icon),
      title: Text(title),
      value: value,
      onChanged: (newValue) {
        // TODO: Implement notification preference update
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title: ${newValue ? "enabled" : "disabled"}'),
          ),
        );
      },
    );
  }

  Widget _buildPrivacyTile(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // TODO: Navigate to privacy policy/terms
      },
    );
  }

  Widget _buildSupportTile(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // TODO: Navigate to support
      },
    );
  }

  Widget _buildAboutTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info),
      title: Text(AppLocalizations.of(context).translate('about_app')),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        _showAboutDialog(context);
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).translate('logout')),
        content: Text(
          AppLocalizations.of(context).translate('logout_confirmation'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).translate('cancel')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement logout
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text(
              AppLocalizations.of(context).translate('logout'),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'MCS',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2026 Medical Clinic Management System',
      children: [
        const SizedBox(height: 16),
        Text(
          AppLocalizations.of(context).translate('about_description'),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Theme Switcher Tile Widget
class ThemeSwitcherTile extends StatelessWidget {
  const ThemeSwitcherTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Theme.of(context).brightness == Brightness.light
            ? Icons.light_mode
            : Icons.dark_mode,
      ),
      title: Text(AppLocalizations.of(context).translate('theme')),
      subtitle: Text(
        Theme.of(context).brightness == Brightness.light
            ? AppLocalizations.of(context).translate('light_theme')
            : AppLocalizations.of(context).translate('dark_theme'),
      ),
      trailing: Switch(
        value: Theme.of(context).brightness == Brightness.dark,
        onChanged: (value) {
          // TODO: Implement theme switching
        },
      ),
    );
  }
}

/// Language Switcher Tile Widget
class LanguageSwitcherTile extends StatelessWidget {
  const LanguageSwitcherTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(AppLocalizations.of(context).translate('language')),
      subtitle: Text(
        Localizations.localeOf(context).languageCode == 'ar'
            ? 'العربية'
            : 'English',
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // TODO: Implement language switching
      },
    );
  }
}