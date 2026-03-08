/// Employee Dashboard Screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/localization/app_localizations.dart';
import 'package:mcs/core/models/appointment_model.dart';
import 'package:mcs/core/widgets/loading_widget.dart';
import 'package:mcs/features/employee/presentation/bloc/index.dart';

/// Employee dashboard screen
class EmployeeDashboardScreen extends StatefulWidget {
  const EmployeeDashboardScreen({super.key});

  @override
  State<EmployeeDashboardScreen> createState() =>
      _EmployeeDashboardScreenState();
}

class _EmployeeDashboardScreenState extends State<EmployeeDashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<EmployeeBloc>().add(const LoadDashboardStats());
    context
        .read<EmployeeBloc>()
        .add(const LoadAppointments(status: 'scheduled'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('dashboard')),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'profile') {
                // TODO: Navigate to profile
              } else if (value == 'settings') {
                // TODO: Navigate to settings
              } else if (value == 'logout') {
                // TODO: Implement logout
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'profile',
                child: Text(AppLocalizations.of(context).translate('profile')),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Text(AppLocalizations.of(context).translate('settings')),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'logout',
                child: Text(
                  AppLocalizations.of(context).translate('logout'),
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return const LoadingWidget();
          }

          return RefreshIndicator(
            onRefresh: () async {
              _loadData();
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Card
                  _buildWelcomeCard(context, state),
                  const SizedBox(height: 24),

                  // Stats Cards
                  _buildStatsGrid(context, state),
                  const SizedBox(height: 24),

                  // Today's Appointments
                  _buildTodayAppointments(context, state),
                  const SizedBox(height: 24),

                  // Quick Actions
                  _buildQuickActions(context),
                ],
              ),
            ),
          );
        },
      ),
      drawer: _buildDrawer(context),
    );
  }

  Widget _buildWelcomeCard(BuildContext context, EmployeeState state) {
    var employeeName = 'Employee';
    var role = 'Staff';
    if (state is EmployeeProfileLoaded) {
      employeeName = state.profile.name;
      role = state.profile.role; ?? 'Employee';
      role = state.profile.role ?? 'Staff';
    }

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                employeeName.isNotEmpty ? employeeName.substring(0, 1).toUpperCase() : 'E',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)?.translate('welcome') ?? 'Welcome',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    employeeName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    role,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer
                              .withValues(alpha: 
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, EmployeeState state) {
    var stats = <String, dynamic>{};
    if (state is DashboardStatsLoaded) {
      stats = state.stats;
    }

    final l10n = AppLocalizations.of(context);

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          context,
          l10n?.translate('total_patients') ?? 'Total Patients',
          (stats['total_patients'] ?? 0).toString(),
          Icons.people,
          Colors.blue,
        ),
        _buildStatCard(
          context,
          l10n?.translate('today_appointments') ?? "Today's Appointments",
          (stats['today_appointments'] ?? 0).toString(),
          Icons.calendar_today,
          Colors.green,
        ),
        _buildStatCard(
          context,
          l10n?.translate('pending_appointments') ?? 'Pending Appointments',
          (stats['pending_appointments'] ?? 0).toString(),
          Icons.pending,
          Colors.orange,
        ),
        _buildStatCard(
          context,
          l10n?.translate('pending_invoices') ?? 'Pending Invoices',
          (stats['pending_invoices'] ?? 0).toString(),
          Icons.receipt_long,
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
final List<AppointmentModel> appointments = state is AppointmentsLoaded
        ? state.appointments
        : const <AppointmentModel>[];

    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n?.translate('today_appointments') ?? "Today's Appointments",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to all appointments
              },
              child: Text(l10n?.translate('view_all') ?? 'View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (appointments.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text(
                  l10n?.translate('no_appointments_today') ??
                      'No appointments today',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ),
            ),
          )
        else
          ...appointments.take(3).map((appointment) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(appointment.patientName ?? 'Patient'),
                subtitle: Text(appointment.timeSlot),
                trailing: appointment.status == AppointmentStatus.pending
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              context
                                  .read<EmployeeBloc>()
                                  .add(AcceptAppointment(appointment.id));
                            },
                          ),
                        ],
                      )
                    : appointment.status == AppointmentStatus.confirmed
                        ? IconButton(
                            icon: const Icon(
                              Icons.check_circle_outline,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              context
                                  .read<EmployeeBloc>()
                                  .add(CompleteAppointm
                                  .read<EmployeeBloc>()
                                  .add(CheckOutPatient(appointment.id));
                            },
                          )
                        : const Icon(Icons.check_circle, color: Colors.grey),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n?.translate('quick_actions') ?? 'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildQuickActionCard(
              context,
              l10n?.translate('register_patient') ?? 'Register Patient',
              Icons.person_add,
              Colors.blue,
              () {
                // TODO: Navigate to patient registration
              },
            ),
            _buildQuickActionCard(
              context,
              l10n?.translate('book_appointment') ?? 'Book Appointment',
              Icons.calendar_month,
              Colors.green,
              () {
                // TODO: Navigate to appointment booking
              },
            ),
            _buildQuickActionCard(
              context,
              l10n?.translate('inventory') ?? 'Inventory',
              Icons.inventory_2,
              Colors.orange,
              () {
                // TODO: Navigate to inventory
              },
            ),
            _buildQuickActionCard(
              context,
              l10n?.translate('invoices') ?? 'Invoices',
              Icons.receipt,
              Colors.red,
              () {
                // TODO: Navigate to invoices
              },
            ),
          ],
        ),
      ],
    );
  }
                // TODO: Navigate to invoices
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
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
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Employee Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Role',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: Text(AppLocalizations.of(context).translate('dashboard')),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: Text(AppLocalizations.of(context).translate('appointments')),
            onTap: () {
              // TODO: Navigate to appointments
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: Text(AppLocalizations.of(context).translate('patients')),
            onTap: () {
              // TODO: Navigate to patients
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory_2),
            title: Text(AppLocalizations.of(context).translate('inventory')),
            onTap: () {
              // TODO: Navigate to inventory
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt),
            title: Text(AppLocalizations.of(context).translate('invoices')),
            onTap: () {
              // TODO: Navigate to invoices
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(AppLocalizations.of(context).translate('settings')),
            onTap: () {
              // TODO: Navigate to settings
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
