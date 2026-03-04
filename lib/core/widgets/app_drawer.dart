/// App drawer widget for navigation.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/localization/app_localizations.dart';
import 'package:mcs/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mcs/features/auth/presentation/bloc/auth_event.dart';
import 'package:mcs/features/auth/presentation/bloc/auth_state.dart';
import 'package:mcs/core/models/user_model.dart';

/// Main app drawer with navigation options.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, theme, localizations),
            const Divider(height: 1),
            Expanded(
              child: _buildNavigationItems(context, localizations),
            ),
            _buildFooter(context, localizations),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ThemeData theme,
    AppLocalizations localizations,
  ) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        UserModel? user;
        if (state is Authenticated) {
          user = state.user;
        }

        return UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withValues(alpha: 0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          accountName: Text(
            user?.fullName ?? 'Guest',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          accountEmail: Text(
            user?.email ?? '',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          currentAccountPicture: CircleAvatar(
            backgroundColor: theme.colorScheme.surface,
            child: user?.avatarUrl != null
                ? ClipOval(
                    child: Image.network(
                      user!.avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Text(
                          user!.fullName != null && user.fullName!.isNotEmpty
                              ? user.fullName![0].toUpperCase()
                              : 'U',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        );
                      },
                    ),
                  )
                : Text(
                    user?.fullName != null &&
                            (user?.fullName!.isNotEmpty ?? false)
                        ? user!.fullName![0].toUpperCase()
                        : 'U',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildNavigationItems(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _buildNavItem(
          context,
          icon: Icons.home_outlined,
          title: localizations.home,
          onTap: () => _navigateTo(context, '/home'),
        ),
        _buildNavItem(
          context,
          icon: Icons.person_outline,
          title: localizations.profile,
          onTap: () => _navigateTo(context, '/profile'),
        ),
        _buildNavItem(
          context,
          icon: Icons.calendar_today_outlined,
          title: localizations.appointments,
          onTap: () => _navigateTo(context, '/appointments'),
        ),
        _buildNavItem(
          context,
          icon: Icons.people_outline,
          title: localizations.patients,
          onTap: () => _navigateTo(context, '/patients'),
        ),
        _buildNavItem(
          context,
          icon: Icons.local_hospital_outlined,
          title: localizations.doctors,
          onTap: () => _navigateTo(context, '/doctors'),
        ),
        _buildNavItem(
          context,
          icon: Icons.description_outlined,
          title: localizations.prescriptions,
          onTap: () => _navigateTo(context, '/prescriptions'),
        ),
        _buildNavItem(
          context,
          icon: Icons.receipt_long_outlined,
          title: localizations.invoices,
          onTap: () => _navigateTo(context, '/invoices'),
        ),
        _buildNavItem(
          context,
          icon: Icons.inventory_2_outlined,
          title: localizations.inventory,
          onTap: () => _navigateTo(context, '/inventory'),
        ),
        _buildNavItem(
          context,
          icon: Icons.science_outlined,
          title: localizations.labResults,
          onTap: () => _navigateTo(context, '/lab-results'),
        ),
        _buildNavItem(
          context,
          icon: Icons.videocam_outlined,
          title: localizations.videoCalls,
          onTap: () => _navigateTo(context, '/video-calls'),
        ),
        _buildNavItem(
          context,
          icon: Icons.assessment_outlined,
          title: localizations.reports,
          onTap: () => _navigateTo(context, '/reports'),
        ),
        const Divider(height: 32),
        _buildNavItem(
          context,
          icon: Icons.settings_outlined,
          title: localizations.settings,
          onTap: () => _navigateTo(context, '/settings'),
        ),
        _buildNavItem(
          context,
          icon: Icons.help_outline,
          title: localizations.support,
          onTap: () => _navigateTo(context, '/support'),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, AppLocalizations localizations) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isAuthenticated = state is Authenticated;

        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (isAuthenticated)
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: Text(
                    localizations.logout,
                    style: const TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    context.read<AuthBloc>().add(const LogoutRequested());
                    Navigator.pop(context);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(localizations.about),
                onTap: () {
                  Navigator.pop(context);
                  _showAboutDialog(context, localizations);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  void _showAboutDialog(BuildContext context, AppLocalizations localizations) {
    showAboutDialog(
      context: context,
      applicationName: localizations.appName,
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2026 MCS. All rights reserved.',
      children: [
        Text(localizations.appFullName),
      ],
    );
  }
}
