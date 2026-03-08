import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mcs/core/extensions/context_extensions.dart';
import 'package:mcs/features/patient/presentation/bloc/index.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.translateSafe('home')),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              context.read<PatientBloc>().add(NavigateToSettings());
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: BlocBuilder<PatientBloc, PatientState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Welcome Card
                _welcomeCard(context),

                const SizedBox(height: 28),

                /// Quick Actions
                Text(
                  context.translateSafe('quick_actions'),
                  style: theme.textTheme.titleLarge,
                ),

                const SizedBox(height: 16),

                _quickActions(context),

                const SizedBox(height: 28),

                /// Upcoming Appointment
                _sectionCard(
                  context,
                  icon: Icons.calendar_month_outlined,
                  title: context.translateSafe('appointments'),
                  subtitle: context.translateSafe('no_upcoming_appointments'),
                  onTap: () {
                    context.read<PatientBloc>().add(NavigateToAppointments());
                  },
                ),

                const SizedBox(height: 16),

                /// Prescriptions
                _sectionCard(
                  context,
                  icon: Icons.medication_outlined,
                  title: context.translateSafe('prescriptions'),
                  subtitle: context.translateSafe('no_active_prescriptions'),
                  onTap: () {
                    context.read<PatientBloc>().add(NavigateToPrescriptions());
                  },
                ),

                const SizedBox(height: 16),

                /// Lab Results
                _sectionCard(
                  context,
                  icon: Icons.science_outlined,
                  title: context.translateSafe('lab_results'),
                  subtitle: context.translateSafe('no_lab_results'),
                  onTap: () {
                    context.read<PatientBloc>().add(NavigateToLabResults());
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Welcome Card
  Widget _welcomeCard(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.translateSafe('welcome'),
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.translateSafe('patient_dashboard'),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Quick Actions Grid
  Widget _quickActions(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
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
    );
  }

  Widget _actionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        leading: Icon(
          icon,
          color: theme.colorScheme.primary,
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  /// Drawer
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
              children: const [
                CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person),
                ),
                SizedBox(height: 12),
                Text(
                  'Patient Name',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  'patient@email.com',
                  style: TextStyle(color: Colors.white70),
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
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
