import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/extensions/context_extensions.dart';
import 'package:mcs/features/doctor/presentation/bloc/doctor_bloc.dart';

/// Doctor Dashboard Screen
class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({this.isPremium = false, super.key});

  final bool isPremium;

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translateSafe('doctor_dashboard')),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => _handleNotifications(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _handleSettings(context),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Welcome Card
            _buildWelcomeCard(context),
            const SizedBox(height: 20),

            /// Quick Stats
            _buildQuickStats(context),
            const SizedBox(height: 20),

            /// Quick Actions
            _buildQuickActions(context),
            const SizedBox(height: 20),

            /// Recent Appointments
            _buildRecentAppointments(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.translateSafe('welcome'),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.translateSafe('doctor_dashboard'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              context,
              '12',
              context.translateSafe('today_appointments'),
              Icons.calendar_today,
            ),
            _buildStatItem(
              context,
              '45',
              context.translateSafe('total_patients'),
              Icons.people,
            ),
            _buildStatItem(
              context,
              '8',
              context.translateSafe('pending'),
              Icons.pending_actions,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.translateSafe('quick_actions'),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildActionCard(
              context,
              Icons.calendar_today,
              context.translateSafe('view_appointments'),
              () {
                // Navigate to appointments
              },
            ),
            _buildActionCard(
              context,
              Icons.people,
              context.translateSafe('view_patients'),
              () {
                // Navigate to patients
              },
            ),
            _buildActionCard(
              context,
              Icons.medication,
              context.translateSafe('manage_prescriptions'),
              () {
                // Navigate to prescriptions
              },
            ),
            _buildActionCard(
              context,
              Icons.science,
              context.translateSafe('view_lab_results'),
              () {
                // Navigate to lab results
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return Expanded(
      flex: 1,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: SizedBox(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon,
                    size: 32, color: Theme.of(context).colorScheme.primary),
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
      ),
    );
  }

  Widget _buildRecentAppointments(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.translateSafe('recent_appointments'),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildAppointmentItem(
                  context,
                  'Ahmed Ali',
                  '10:00 AM',
                  'New Consultation',
                ),
                const Divider(height: 20),
                _buildAppointmentItem(
                  context,
                  'Fatima Mohamed',
                  '10:30 AM',
                  'Follow-up',
                ),
                const Divider(height: 20),
                _buildAppointmentItem(
                  context,
                  'Omar Hassan',
                  '11:00 AM',
                  'Check-up',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentItem(
    BuildContext context,
    String patientName,
    String time,
    String type,
  ) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.person, size: 20),
      ),
      title: Text(patientName),
      subtitle: Text('$time • $type'),
      trailing: const Icon(Icons.chevron_right),
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person),
                ),
                const SizedBox(height: 12),
                Text(
                  context.translateSafe('doctor_name'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'doctor@email.com',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(context.translateSafe('profile')),
            onTap: () {
              // Navigate to profile
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text(context.translateSafe('settings')),
            onTap: () {
              _handleSettings(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(context.translateSafe('logout')),
            onTap: () => _handleLogout(context),
          ),
        ],
      ),
    );
  }

  void _handleNotifications(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.translateSafe('no_notifications')),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleSettings(BuildContext context) {
    // Navigate to settings
  }

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
                // Handle logout
              },
              child: Text(context.translateSafe('logout')),
            ),
          ],
        );
      },
    );
  }
}
