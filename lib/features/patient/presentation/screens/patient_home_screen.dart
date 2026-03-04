/// Patient Home Screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/localization/app_localizations.dart';
import 'package:mcs/core/widgets/custom_button.dart';
import 'package:mcs/features/patient/presentation/bloc/index.dart';

/// Patient home screen with quick actions
class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('patient_home')),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              context.read<PatientBloc>().add(const NavigateToSettings());
            },
          ),
        ],
      ),
      body: BlocBuilder<PatientBloc, PatientState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                _buildWelcomeSection(context),
                const SizedBox(height: 24),

                // Quick Actions
                _buildQuickActions(context),
                const SizedBox(height: 24),

                // Upcoming Appointments
                _buildUpcomingAppointments(context),
                const SizedBox(height: 24),

                // Active Prescriptions
                _buildActivePrescriptions(context),
                const SizedBox(height: 24),

                // Recent Lab Results
                _buildRecentLabResults(context),
              ],
            ),
          );
        },
      ),
      drawer: _buildDrawer(context),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).translate('welcome'),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context).translate('patient_home_subtitle'),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).translate('quick_actions'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _buildActionCard(
              context,
              icon: Icons.calendar_month_outlined,
              label: AppLocalizations.of(context).translate('book_appointment'),
              onTap: () {
                context.read<PatientBloc>().add(const NavigateToBooking());
              },
            ),
            _buildActionCard(
              context,
              icon: Icons.video_call_outlined,
              label: AppLocalizations.of(context).translate('remote_sessions'),
              onTap: () {
                context.read<PatientBloc>().add(const NavigateToRemoteSessions());
              },
            ),
            _buildActionCard(
              context,
              icon: Icons.medication_outlined,
              label: AppLocalizations.of(context).translate('prescriptions'),
              onTap: () {
                context.read<PatientBloc>().add(const NavigateToPrescriptions());
              },
            ),
            _buildActionCard(
              context,
              icon: Icons.science_outlined,
              label: AppLocalizations.of(context).translate('lab_results'),
              onTap: () {
                context.read<PatientBloc>().add(const NavigateToLabResults());
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingAppointments(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context).translate('upcoming_appointments'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () {
                context.read<PatientBloc>().add(const NavigateToAppointments());
              },
              child: Text(AppLocalizations.of(context).translate('view_all')),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context).translate('no_upcoming_appointments'),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: AppLocalizations.of(context).translate('book_appointment'),
                  onPressed: () {
                    context.read<PatientBloc>().add(const NavigateToBooking());
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivePrescriptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context).translate('active_prescriptions'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () {
                context.read<PatientBloc>().add(const NavigateToPrescriptions());
              },
              child: Text(AppLocalizations.of(context).translate('view_all')),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(
                  Icons.medication_outlined,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context).translate('no_active_prescriptions'),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentLabResults(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context).translate('recent_lab_results'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () {
                context.read<PatientBloc>().add(const NavigateToLabResults());
              },
              child: Text(AppLocalizations.of(context).translate('view_all')),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(
                  Icons.science_outlined,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context).translate('no_lab_results'),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 32,
                  child: Icon(Icons.person, size: 32),
                ),
                const SizedBox(height: 16),
                Text(
                  'اسم المريض',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                ),
                Text(
                  'patient@example.com',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: Text(AppLocalizations.of(context).translate('home')),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month_outlined),
            title: Text(AppLocalizations.of(context).translate('appointments')),
            onTap: () {
              Navigator.pop(context);
              context.read<PatientBloc>().add(const NavigateToAppointments());
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_call_outlined),
            title: Text(AppLocalizations.of(context).translate('remote_sessions')),
            onTap: () {
              Navigator.pop(context);
              context.read<PatientBloc>().add(const NavigateToRemoteSessions());
            },
          ),
          ListTile(
            leading: const Icon(Icons.medication_outlined),
            title: Text(AppLocalizations.of(context).translate('prescriptions')),
            onTap: () {
              Navigator.pop(context);
              context.read<PatientBloc>().add(const NavigateToPrescriptions());
            },
          ),
          ListTile(
            leading: const Icon(Icons.science_outlined),
            title: Text(AppLocalizations.of(context).translate('lab_results')),
            onTap: () {
              Navigator.pop(context);
              context.read<PatientBloc>().add(const NavigateToLabResults());
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person_outlined),
            title: Text(AppLocalizations.of(context).translate('profile')),
            onTap: () {
              Navigator.pop(context);
              context.read<PatientBloc>().add(const NavigateToProfile());
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text(AppLocalizations.of(context).translate('settings')),
            onTap: () {
              Navigator.pop(context);
              context.read<PatientBloc>().add(const NavigateToSettings());
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: Text(AppLocalizations.of(context).translate('logout')),
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement logout
            },
          ),
        ],
      ),
    );
  }
}