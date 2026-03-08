import 'package:flutter/material.dart';

import 'package:mcs/core/localization/app_localizations.dart';

/// Patient settings screen
class PatientSettingsScreen extends StatelessWidget {
  const PatientSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('settings')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// Appearance
          _buildSection(
            context,
            loc.translate('appearance'),
            const [
              ThemeSwitcherTile(),
              LanguageSwitcherTile(),
            ],
          ),

          const SizedBox(height: 24),

          /// Notifications
          _buildSection(
            context,
            loc.translate('notifications'),
            [
              _buildNotificationTile(
                context,
                loc.translate('push_notifications'),
                Icons.notifications,
                true,
              ),
              _buildNotificationTile(
                context,
                loc.translate('email_notifications'),
                Icons.email,
                true,
              ),
              _buildNotificationTile(
                context,
                loc.translate('sms_notifications'),
                Icons.sms,
                false,
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// Privacy
          _buildSection(
            context,
            loc.translate('privacy'),
            [
              _buildSimpleTile(
                context,
                loc.translate('privacy_policy'),
                Icons.privacy_tip,
              ),
              _buildSimpleTile(
                context,
                loc.translate('terms_of_service'),
                Icons.description,
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// Support
          _buildSection(
            context,
            loc.translate('support'),
            [
              _buildSimpleTile(
                context,
                loc.translate('help_center'),
                Icons.help,
              ),
              _buildSimpleTile(
                context,
                loc.translate('contact_us'),
                Icons.contact_support,
              ),
              _buildSimpleTile(
                context,
                loc.translate('report_bug'),
                Icons.bug_report,
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// About
          _buildSection(
            context,
            loc.translate('about'),
            [
              ListTile(
                leading: const Icon(Icons.info),
                title: Text(loc.translate('about_app')),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showAboutDialog(context),
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// Logout
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(
                loc.translate('logout'),
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () => _showLogoutDialog(context),
            ),
          ),
        ],
      ),
    );
  }

  /// Section builder
  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
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
          child: Column(children: children),
        ),
      ],
    );
  }

  /// Notification tile
  Widget _buildNotificationTile(
    BuildContext context,
    String title,
    IconData icon,
    bool value,
  ) {
    return SwitchListTile(
      secondary: Icon(icon),
      title: Text(title),
      value: value,
      onChanged: (newValue) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title: ${newValue ? "enabled" : "disabled"}'),
          ),
        );
      },
    );
  }

  /// Simple list tile
  Widget _buildSimpleTile(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // TODO: Navigation
      },
    );
  }

  /// Logout dialog
  void _showLogoutDialog(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.translate('logout')),
        content: Text(loc.translate('logout_confirmation')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc.translate('cancel')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text(
              loc.translate('logout'),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  /// About dialog
  void _showAboutDialog(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    showAboutDialog(
      context: context,
      applicationName: 'MCS',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2026 Medical Clinic Management System',
      children: [
        const SizedBox(height: 16),
        Text(
          loc.translate('about_description'),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Theme Switcher Tile
class ThemeSwitcherTile extends StatelessWidget {
  const ThemeSwitcherTile({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
      title: Text(loc.translate('theme')),
      subtitle: Text(
        isDark ? loc.translate('dark_theme') : loc.translate('light_theme'),
      ),
      trailing: Switch(
        value: isDark,
        onChanged: (value) {
          // TODO: Theme change logic
        },
      ),
    );
  }
}

/// Language Switcher Tile
class LanguageSwitcherTile extends StatelessWidget {
  const LanguageSwitcherTile({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(loc.translate('language')),
      subtitle: Text(
        locale.languageCode == 'ar' ? 'العربية' : 'English',
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // TODO: Language change logic
      },
    );
  }
}
