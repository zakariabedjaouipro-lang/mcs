/// Employee Dashboard Screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mcs/core/config/router.dart';
import 'package:mcs/core/enums/appointment_status.dart';
import 'package:mcs/core/localization/app_localizations.dart';
import 'package:mcs/core/models/appointment_model.dart';
import 'package:mcs/core/widgets/loading_widget.dart';
import 'package:mcs/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mcs/features/auth/presentation/bloc/auth_event.dart';
import 'package:mcs/features/employee/presentation/bloc/index.dart';

/// Employee dashboard screen
class EmployeeDashboardScreen extends StatefulWidget {
  const EmployeeDashboardScreen({super.key});

  @override
  State<EmployeeDashboardScreen> createState() =>
      _EmployeeDashboardScreenState();
}

class _EmployeeDashboardScreenState extends State<EmployeeDashboardScreen> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // ✅ لا نستخدم context هنا
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ✅ آمن تماماً هنا
    if (!_isInitialized) {
      _loadData();
      _isInitialized = true;
    }
  }

  void _loadData() {
    context.read<EmployeeBloc>().add(const LoadDashboardStats());
    context
        .read<EmployeeBloc>()
        .add(const LoadAppointments(status: 'scheduled'));
  }

  void _showLogoutConfirmation() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<AuthBloc>().add(const LogoutRequested());
                  context.go(AppRoutes.login);
                },
                child: const Text('Logout'),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.translate('dashboard') ?? 'Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications screen coming soon'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'profile') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile screen coming soon'),
                    duration: Duration(seconds: 2),
                  ),
                );
              } else if (value == 'settings') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Settings screen coming soon'),
                    duration: Duration(seconds: 2),
                  ),
                );
              } else if (value == 'logout') {
                _showLogoutConfirmation();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'profile',
                child: Text(l10n?.translate('profile') ?? 'Profile'),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Text(l10n?.translate('settings') ?? 'Settings'),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'logout',
                child: Text(
                  l10n?.translate('logout') ?? 'Logout',
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
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Card
                  _buildWelcomeCard(context, state),
                  SizedBox(height: 24.h),

                  // Stats Cards
                  _buildStatsGrid(context, state),
                  SizedBox(height: 24.h),

                  // Today's Appointments
                  _buildTodayAppointments(context, state),
                  SizedBox(height: 24.h),

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
      employeeName = state.profile.name ?? 'Employee';
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
                employeeName.isNotEmpty
                    ? employeeName.substring(0, 1).toUpperCase()
                    : 'E',
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
                    AppLocalizations.of(context)?.translate('welcome') ??
                        'Welcome',
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
                              .withValues(alpha: 0.8),
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

  Widget _buildTodayAppointments(BuildContext context, EmployeeState state) {
    final appointments = state is AppointmentsLoaded
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All appointments screen coming soon'),
                    duration: Duration(seconds: 2),
                  ),
                );
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
                                  .add(CheckInPatient(appointment.id));
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
    final l10n = AppLocalizations.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive column count based on screen width
        final crossAxisCount = constraints.maxWidth < 600
            ? 2
            : constraints.maxWidth < 900
                ? 3
                : 4;

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
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _buildQuickActionCard(
                  context,
                  l10n?.translate('register_patient') ?? 'Register Patient',
                  Icons.person_add,
                  Colors.blue,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Patient registration screen coming soon'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                _buildQuickActionCard(
                  context,
                  l10n?.translate('book_appointment') ?? 'Book Appointment',
                  Icons.calendar_month,
                  Colors.green,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Appointment booking screen coming soon'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                _buildQuickActionCard(
                  context,
                  l10n?.translate('inventory') ?? 'Inventory',
                  Icons.inventory_2,
                  Colors.orange,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Inventory screen coming soon'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                _buildQuickActionCard(
                  context,
                  l10n?.translate('invoices') ?? 'Invoices',
                  Icons.receipt,
                  Colors.red,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Invoices screen coming soon'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final l10n = AppLocalizations.of(context);

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
                Text(
                  l10n?.translate('employee') ?? 'Employee',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: Text(l10n?.translate('dashboard') ?? 'Dashboard'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: Text(l10n?.translate('patients') ?? 'Patients'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Patients screen coming soon'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: Text(l10n?.translate('appointments') ?? 'Appointments'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Appointments screen coming soon'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory_2),
            title: Text(l10n?.translate('inventory') ?? 'Inventory'),
            onTap: () {
              Navigator.pop(context);
              context.go(AppRoutes.inventoryList);
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt),
            title: Text(l10n?.translate('invoices') ?? 'Invoices'),
            onTap: () {
              Navigator.pop(context);
              context.go(AppRoutes.invoicesList);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(l10n?.translate('settings') ?? 'Settings'),
            onTap: () {
              Navigator.pop(context);
              context.go(AppRoutes.settings);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              l10n?.translate('logout') ?? 'Logout',
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(const LogoutRequested());
              context.go(AppRoutes.login);
            },
          ),
        ],
      ),
    );
  }
}
