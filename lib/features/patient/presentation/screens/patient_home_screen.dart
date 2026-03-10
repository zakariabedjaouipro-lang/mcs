import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mcs/core/constants/responsive_constants.dart';
import 'package:mcs/core/extensions/context_extensions.dart';
import 'package:mcs/core/widgets/responsive_card.dart';
import 'package:mcs/core/widgets/responsive_grid_view.dart';
import 'package:mcs/features/patient/presentation/bloc/index.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translateSafe('home')),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => _handleNotifications(context),
            tooltip: context.translateSafe('notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _handleSettings(context),
            tooltip: context.translateSafe('settings'),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: BlocBuilder<PatientBloc, PatientState>(
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(context.adaptivePaddingHorizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Welcome Card
                  _welcomeCard(context),
                  SizedBox(height: context.adaptivePaddingVertical * 1.5),

                  /// Quick Actions Section
                  _quickActionsSection(context),
                  SizedBox(height: context.adaptivePaddingVertical * 1.5),

                  /// Appointments Card
                  _sectionCard(
                    context,
                    icon: Icons.calendar_month_outlined,
                    title: context.translateSafe('appointments'),
                    subtitle: context.translateSafe(
                      'no_upcoming_appointments',
                    ),
                    onTap: () {
                      context.read<PatientBloc>().add(NavigateToAppointments());
                    },
                  ),
                  SizedBox(height: context.adaptivePaddingVertical),

                  /// Prescriptions Card
                  _sectionCard(
                    context,
                    icon: Icons.medication_outlined,
                    title: context.translateSafe('prescriptions'),
                    subtitle: context.translateSafe('no_active_prescriptions'),
                    onTap: () {
                      context
                          .read<PatientBloc>()
                          .add(NavigateToPrescriptions());
                    },
                  ),
                  SizedBox(height: context.adaptivePaddingVertical),

                  /// Lab Results Card
                  _sectionCard(
                    context,
                    icon: Icons.science_outlined,
                    title: context.translateSafe('lab_results'),
                    subtitle: context.translateSafe('no_lab_results'),
                    onTap: () {
                      context.read<PatientBloc>().add(NavigateToLabResults());
                    },
                  ),
                  SizedBox(height: context.adaptivePaddingVertical),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Welcome Card with user information
  Widget _welcomeCard(BuildContext context) {
    return ResponsiveCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: context.colorSchemeSafe.primary,
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: ResponsiveConstants.iconLarge,
            ),
          ),
          SizedBox(width: context.adaptivePaddingHorizontal),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.translateSafe('welcome'),
                  style: context.textThemeSafe.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: ResponsiveConstants.spacing4),
                Text(
                  context.translateSafe('patient_dashboard'),
                  style: context.textThemeSafe.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Quick Actions Grid Section
  Widget _quickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.translateSafe('quick_actions'),
          style: context.textThemeSafe.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: context.adaptivePaddingVertical),
        ResponsiveGridView(
          scrollable: false,
          childAspectRatio: 1.1,
          padding: EdgeInsets.zero,
          children: [
            _actionCard(
              context,
              icon: Icons.calendar_today_outlined,
              label: context.translateSafe('book_appointment'),
              onTap: () {
                context.read<PatientBloc>().add(NavigateToBooking());
              },
            ),
            _actionCard(
              context,
              icon: Icons.video_call_outlined,
              label: context.translateSafe('remote_sessions'),
              onTap: () {
                context.read<PatientBloc>().add(NavigateToRemoteSessions());
              },
            ),
            _actionCard(
              context,
              icon: Icons.medication_outlined,
              label: context.translateSafe('prescriptions'),
              onTap: () {
                context.read<PatientBloc>().add(NavigateToPrescriptions());
              },
            ),
            _actionCard(
              context,
              icon: Icons.science_outlined,
              label: context.translateSafe('lab_results'),
              onTap: () {
                context.read<PatientBloc>().add(NavigateToLabResults());
              },
            ),
          ],
        ),
      ],
    );
  }

  /// Action Card for quick access
  Widget _actionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ResponsiveCard(
      onTap: onTap,
      padding: EdgeInsets.all(context.adaptiveCardPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: ResponsiveConstants.iconLarge,
            color: context.colorSchemeSafe.primary,
          ),
          SizedBox(height: context.adaptivePaddingVertical),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textThemeSafe.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Card with icon and navigation
  Widget _sectionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ResponsiveCard(
      onTap: onTap,
      child: SizedBox(
        height: ResponsiveConstants.minTouchSize,
        child: Row(
          children: [
            Icon(
              icon,
              size: ResponsiveConstants.iconMedium,
              color: context.colorSchemeSafe.primary,
            ),
            SizedBox(width: context.adaptivePaddingHorizontal),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textThemeSafe.titleSmall,
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textThemeSafe.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: ResponsiveConstants.iconSmall,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  /// Navigation Drawer
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: context.colorSchemeSafe.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.person),
                  ),
                  SizedBox(height: context.adaptivePaddingVertical),
                  Text(
                    context.translateSafe('patient_name'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'patient@email.com',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text(context.translateSafe('profile')),
              onTap: () {
                context.read<PatientBloc>().add(NavigateToProfile());
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: Text(context.translateSafe('settings')),
              onTap: () {
                context.read<PatientBloc>().add(NavigateToSettings());
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(context.translateSafe('logout')),
              onTap: () => _handleLogout(context),
            ),
          ],
        ),
      ),
    );
  }

  // ── Event Handlers ──────────────────────────────────────────

  /// Handles notification icon tap
  void _handleNotifications(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.translateSafe('no_notifications')),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Handles settings icon tap
  void _handleSettings(BuildContext context) {
    context.read<PatientBloc>().add(NavigateToSettings());
  }

  /// Handles logout action
  void _handleLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(context.translateSafe('confirm_logout')),
          content: Text(context.translateSafe('logout_message')),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(context.translateSafe('cancel')),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<PatientBloc>().add(LogoutEvent());
              },
              child: Text(context.translateSafe('logout')),
            ),
          ],
        );
      },
    );
  }
}
