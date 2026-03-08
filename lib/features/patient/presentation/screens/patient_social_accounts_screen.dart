/// Patient Social Accounts Screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/localization/app_localizations.dart';
import 'package:mcs/features/patient/presentation/bloc/index.dart';

/// Patient social accounts screen
class PatientSocialAccountsScreen extends StatelessWidget {
  const PatientSocialAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('social_accounts')),
      ),
      body: BlocListener<PatientBloc, PatientState>(
        listener: (context, state) {
          if (state is SocialAccountLinked) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is SocialAccountUnlinked) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is PatientError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<PatientBloc, PatientState>(
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Info Card
                Card(
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context).translate('social_accounts_info'),
                            style: TextStyle(color: Colors.blue[900]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Google Account
                _buildSocialAccountTile(
                  context,
                  provider: 'Google',
                  icon: Icons.g_mobiledata,
                  color: Colors.red,
                  isLinked: false, // TODO: Get from user data
                ),
                const SizedBox(height: 16),
                
                // Facebook Account
                _buildSocialAccountTile(
                  context,
                  provider: 'Facebook',
                  icon: Icons.facebook,
                  color: Colors.blue,
                  isLinked: false, // TODO: Get from user data
                ),
                const SizedBox(height: 16),
                
                // VK Account
                _buildSocialAccountTile(
                  context,
                  provider: 'VK',
                  icon: Icons.share,
                  color: Colors.blue[800]!,
                  isLinked: false, // TODO: Get from user data
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSocialAccountTile(
    BuildContext context, {
    required String provider,
    required IconData icon,
    required Color color,
    required bool isLinked,
  }) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(provider),
        subtitle: Text(
          isLinked
              ? AppLocalizations.of(context).translate('account_linked')
              : AppLocalizations.of(context).translate('account_not_linked'),
        ),
        trailing: isLinked
            ? OutlinedButton.icon(
                onPressed: () {
                  _showUnlinkDialog(context, provider);
                },
                icon: const Icon(Icons.link_off, size: 16),
                label: Text(AppLocalizations.of(context).translate('unlink')),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
              )
            : OutlinedButton.icon(
                onPressed: () {
                  context.read<PatientBloc>().add(LinkSocialAccount(provider));
                },
                icon: const Icon(Icons.link, size: 16),
                label: Text(AppLocalizations.of(context).translate('link')),
              ),
      ),
    );
  }

  void _showUnlinkDialog(BuildContext context, String provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).translate('unlink_account')),
        content: Text(
          AppLocalizations.of(context).translate('unlink_account_confirmation').replaceFirst('{provider}', provider),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).translate('cancel')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<PatientBloc>().add(UnlinkSocialAccount(provider));
            },
            child: Text(
              AppLocalizations.of(context).translate('unlink'),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}