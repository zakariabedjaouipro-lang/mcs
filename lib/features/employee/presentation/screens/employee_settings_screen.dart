import 'package:flutter/material.dart';
import 'package:mcs/core/extensions/context_extensions.dart';

/// Employee Settings Screen
class EmployeeSettingsScreen extends StatefulWidget {
  const EmployeeSettingsScreen({super.key});

  @override
  State<EmployeeSettingsScreen> createState() => _EmployeeSettingsScreenState();
}

class _EmployeeSettingsScreenState extends State<EmployeeSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _language = 'English';
  bool _twoFactorAuth = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translateSafe('settings')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            context.translateSafe('account'),
            [
              _buildListTile(
                context,
                Icons.person,
                context.translateSafe('edit_profile'),
                () {
                  // Navigate to edit profile
                },
              ),
              _buildListTile(
                context,
                Icons.lock,
                context.translateSafe('change_password'),
                () {
                  // Navigate to change password
                },
              ),
              _buildSwitchListTile(
                context,
                Icons.security,
                context.translateSafe('two_factor_authentication'),
                _twoFactorAuth,
                (value) {
                  setState(() {
                    _twoFactorAuth = value;
                  });
                },
              ),
              _buildListTile(
                context,
                Icons.logout,
                context.translateSafe('logout'),
                () {
                  _showLogoutDialog(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context.translateSafe('preferences'),
            [
              _buildSwitchListTile(
                context,
                Icons.notifications,
                context.translateSafe('notifications'),
                _notificationsEnabled,
                (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
              _buildListTile(
                context,
                Icons.language,
                context.translateSafe('language'),
                () {
                  _showLanguageDialog(context);
                },
              ),
              _buildSwitchListTile(
                context,
                Icons.dark_mode,
                context.translateSafe('dark_mode'),
                _darkModeEnabled,
                (value) {
                  setState(() {
                    _darkModeEnabled = value;
                  });
                },
              ),
              _buildListTile(
                context,
                Icons.access_time,
                context.translateSafe('working_hours'),
                () {
                  // Navigate to working hours settings
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context.translateSafe('privacy'),
            [
              _buildListTile(
                context,
                Icons.privacy_tip,
                context.translateSafe('privacy_policy'),
                () {
                  // Show privacy policy
                },
              ),
              _buildListTile(
                context,
                Icons.description,
                context.translateSafe('terms_of_service'),
                () {
                  // Show terms of service
                },
              ),
              _buildListTile(
                context,
                Icons.delete,
                context.translateSafe('delete_account'),
                () {
                  _showDeleteAccountDialog(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context.translateSafe('support'),
            [
              _buildListTile(
                context,
                Icons.help,
                context.translateSafe('help_center'),
                () {
                  // Show help center
                },
              ),
              _buildListTile(
                context,
                Icons.contact_support,
                context.translateSafe('contact_support'),
                () {
                  // Contact support
                },
              ),
              _buildListTile(
                context,
                Icons.bug_report,
                context.translateSafe('report_bug'),
                () {
                  // Report bug
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context.translateSafe('about'),
            [
              _buildListTile(
                context,
                Icons.info,
                context.translateSafe('about_app'),
                () {
                  _showAboutDialog(context);
                },
              ),
              _buildListTile(
                context,
                Icons.update,
                context.translateSafe('version') + ' 1.0.0',
                null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback? onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildSwitchListTile(
    BuildContext context,
    IconData icon,
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      secondary: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.translateSafe('confirm_logout')),
          content: Text(context.translateSafe('logout_confirmation_message')),
          actions: [
            TextButton(
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
              child: Text(context.translateSafe('cancel')),
            ),
            TextButton(
              onPressed: () {
                // Perform logout
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                context.translateSafe('logout'),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.translateSafe('select_language')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('English'),
                value: 'English',
                groupValue: _language,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _language = value;
                    });
                    Navigator.of(context).pop();
                  }
                },
              ),
              RadioListTile<String>(
                title: const Text('العربية'),
                value: 'Arabic',
                groupValue: _language,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _language = value;
                    });
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.translateSafe('delete_account')),
          content: Text(context.translateSafe('delete_account_warning')),
          actions: [
            TextButton(
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
              child: Text(context.translateSafe('cancel')),
            ),
            TextButton(
              onPressed: () {
                // Confirm delete account
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                context.translateSafe('delete'),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'MCS - Employee App',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2024 Medical Clinic System',
      children: [
        const SizedBox(height: 16),
        Text(
          context.translateSafe('about_description'),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}