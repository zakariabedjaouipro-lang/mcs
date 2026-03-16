import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/extensions/context_extensions.dart';
import 'package:mcs/features/patient/presentation/bloc/index.dart';

/// Patient Social Accounts Screen
/// Allows patients to link and manage their social media accounts
class PatientSocialAccountsScreen extends StatefulWidget {
  const PatientSocialAccountsScreen({super.key});

  @override
  State<PatientSocialAccountsScreen> createState() =>
      _PatientSocialAccountsScreenState();
}

class _PatientSocialAccountsScreenState
    extends State<PatientSocialAccountsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translateSafe('social_accounts')),
      ),
      body: BlocBuilder<PatientBloc, PatientState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.translateSafe('manage_social_accounts'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                _buildSocialAccountCard(
                  context,
                  Icons.facebook,
                  'Facebook',
                  false,
                  () {
                    // Link Facebook
                    context.read<PatientBloc>().add(
                          const LinkSocialAccount(
                            provider: 'facebook',
                            providerId: 'facebook_id',
                            accessToken: 'access_token',
                          ),
                        );
                  },
                ),
                const SizedBox(height: 12),
                _buildSocialAccountCard(
                  context,
                  Icons.g_mobiledata,
                  'Google',
                  false,
                  () {
                    // Link Google
                    context.read<PatientBloc>().add(
                          const LinkSocialAccount(
                            provider: 'google',
                            providerId: 'google_id',
                            accessToken: 'access_token',
                          ),
                        );
                  },
                ),
                const SizedBox(height: 12),
                _buildSocialAccountCard(
                  context,
                  Icons.mail,
                  'Apple',
                  false,
                  () {
                    // Link Apple
                    context.read<PatientBloc>().add(
                          const LinkSocialAccount(
                            provider: 'apple',
                            providerId: 'apple_id',
                            accessToken: 'access_token',
                          ),
                        );
                  },
                ),
                const SizedBox(height: 12),
                _buildSocialAccountCard(
                  context,
                  Icons.phone,
                  'Phone',
                  true,
                  () {
                    // Unlink Phone
                    context.read<PatientBloc>().add(
                          const UnlinkSocialAccount('phone'),
                        );
                  },
                ),
                const SizedBox(height: 12),
                _buildSocialAccountCard(
                  context,
                  Icons.email,
                  'Email',
                  true,
                  () {
                    // Unlink Email
                    context.read<PatientBloc>().add(
                          const UnlinkSocialAccount('email'),
                        );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSocialAccountCard(
    BuildContext context,
    IconData icon,
    String provider,
    bool isLinked,
    VoidCallback onPressed,
  ) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(provider),
        trailing: isLinked
            ? OutlinedButton.icon(
                icon: const Icon(Icons.link_off, size: 16),
                label: Text(context.translateSafe('unlink')),
                onPressed: onPressed,
              )
            : ElevatedButton.icon(
                icon: const Icon(Icons.link, size: 16),
                label: Text(context.translateSafe('link')),
                onPressed: onPressed,
              ),
      ),
    );
  }
}
