/// App drawer widget for navigation.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mcs/core/constants/app_routes.dart';
import 'package:mcs/core/localization/app_localizations.dart';
import 'package:mcs/core/models/user_model.dart';
import 'package:mcs/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mcs/features/auth/presentation/bloc/auth_event.dart';
import 'package:mcs/features/auth/presentation/bloc/auth_state.dart';

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
          onTap: () => context.go(AppRoutes.patientHome),
        ),
        _buildNavItem(
          context,
          icon: Icons.person_outline,
          title: localizations.profile,
          onTap: () => context.go(AppRoutes.settings),
        ),
        _buildNavItem(
          context,
          icon: Icons.calendar_today_outlined,
          title: localizations.appointments,
          onTap: () => context.go(AppRoutes.appointments),
        ),
        _buildNavItem(
          context,
          icon: Icons.people_outline,
          title: localizations.patients,
          onTap: () => context.go(AppRoutes.patients),
        ),
        _buildNavItem(
          context,
          icon: Icons.local_hospital_outlined,
          title: localizations.doctors,
          onTap: () => Navigator.pop(context), // TODO: Implement doctors route
        ),
        _buildNavItem(
          context,
          icon: Icons.description_outlined,
          title: localizations.prescriptions,
          onTap: () =>
              Navigator.pop(context), // TODO: Implement prescriptions route
        ),
        _buildNavItem(
          context,
          icon: Icons.receipt_long_outlined,
          title: localizations.invoices,
          onTap: () => context.go(AppRoutes.invoices),
        ),
        _buildNavItem(
          context,
          icon: Icons.inventory_2_outlined,
          title: localizations.inventory,
          onTap: () => context.go(AppRoutes.inventory),
        ),
        _buildNavItem(
          context,
          icon: Icons.science_outlined,
          title: localizations.labResults,
          onTap: () =>
              Navigator.pop(context), // TODO: Implement lab results route
        ),
        _buildNavItem(
          context,
          icon: Icons.videocam_outlined,
          title: localizations.videoCalls,
          onTap: () =>
              Navigator.pop(context), // TODO: Implement video calls route
        ),
        _buildNavItem(
          context,
          icon: Icons.assessment_outlined,
          title: localizations.reports,
          onTap: () => Navigator.pop(context), // TODO: Implement reports route
        ),
        const Divider(height: 32),
        _buildNavItem(
          context,
          icon: Icons.settings_outlined,
          title: localizations.settings,
          onTap: () => context.go(AppRoutes.settings),
        ),
        _buildNavItem(
          context,
          icon: Icons.help_outline,
          title: localizations.support,
          onTap: () => Navigator.pop(context), // TODO: Implement support route
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
                    context.pop();
                  },
                ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(localizations.about),
                onTap: () {
                  context.pop();
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
        if (context.canPop()) {
          context.pop();
        }
        onTap();
      },
    );
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
