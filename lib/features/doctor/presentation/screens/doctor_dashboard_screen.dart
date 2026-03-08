/// Doctor Dashboard Screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/localization/app_localizations.dart';
import 'package:mcs/core/widgets/loading_widget.dart';
import 'package:mcs/features/doctor/presentation/bloc/index.dart';

/// Doctor dashboard screen
class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<DoctorBloc>().add(const LoadDashboardStats());
    context.read<DoctorBloc>().add(const LoadAppointments(status: 'scheduled'));
    context.read<DoctorBloc>().add(const LoadRemoteSessionRequests());
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations?.home ?? 'Dashboard',
        ), // استخدام home بدلاً من dashboard
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
                child: Text(localizations?.profile ?? 'Profile'),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Text(localizations?.settings ?? 'Settings'),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'logout',
                child: Text(
                  localizations?.logout ?? 'Logout',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<DoctorBloc, DoctorState>(
        builder: (context, state) {
          if (state is DoctorLoading) {
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

                  // Remote Session Requests
                  _buildRemoteSessionRequests(context, state),
                ],
              ),
            ),
          );
        },
      ),
      drawer: _buildDrawer(context),
    );
  }

  Widget _buildWelcomeCard(BuildContext context, DoctorState state) {
    final localizations = AppLocalizations.of(context);
    var doctorName = localizations?.doctor ?? 'Doctor';

    if (state is DoctorProfileLoaded) {
      // استخدام fullName إذا كان متوفراً، أو name
      doctorName = state.profile.fullName ?? state.profile.name ?? doctorName;
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
                doctorName.isNotEmpty ? doctorName[0].toUpperCase() : 'D',
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
                    localizations?.welcome ?? 'Welcome back,',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctorName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
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

  Widget _buildStatsGrid(BuildContext context, DoctorState state) {
    final localizations = AppLocalizations.of(context);
    final stats =
        state is DashboardStatsLoaded ? state.stats : <String, dynamic>{};

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
          localizations?.patients ?? 'Total Patients',
          (stats['total_patients'] ?? 0).toString(),
          Icons.people,
          Colors.blue,
        ),
        _buildStatCard(
          context,
          localizations?.appointments ?? "Today's Appointments",
          (stats['today_appointments'] ?? 0).toString(),
          Icons.calendar_today,
          Colors.green,
        ),
        _buildStatCard(
          context,
          localizations?.upcoming ??
              'Upcoming', // upcoming موجود في الـ getters
          (stats['upcoming_appointments'] ?? 0).toString(),
          Icons.upcoming,
          Colors.orange,
        ),
        _buildStatCard(
          context,
          localizations?.pending ?? 'Pending', // pending موجود في الـ getters
          (stats['pending_appointments'] ?? 0).toString(),
          Icons.pending,
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

  Widget _buildTodayAppointments(BuildContext context, DoctorState state) {
    final localizations = AppLocalizations.of(context);
    final appointments =
        state is AppointmentsLoaded ? state.appointments : const <AppointmentModel>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localizations?.appointments ?? "Today's Appointments",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to all appointments
              },
              child: Text(
                localizations?.viewAll ?? 'View All',
              ), // viewAll غير موجود، استخدام نص ثابت
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
                  localizations?.noAppointments ??
                      'No appointments today', // noAppointments غير موجود
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ),
            ),
          )
        else
          ...appointments.take(3).map((appointment) {
            final appointmentDate = appointment.appointmentDate;
            final timeString = appointmentDate != null
                ? '${appointmentDate.hour}:${appointmentDate.minute.toString().padLeft(2, '0')}'
                : '';

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(
                  appointment.patientName?.toString() ??
                      localizations?.patient ??
                      'Patient',
                ),
                subtitle: Text(timeString),
                trailing: Icon(
                  appointment.type == 'remote'
                      ? Icons.video_call
                      : Icons.calendar_month,
                  color:
                      appointment.type == 'remote' ? Colors.blue : Colors.green,
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildRemoteSessionRequests(BuildContext context, DoctorState state) {
    final localizations = AppLocalizations.of(context);
    final requests =
        state is RemoteSessionRequestsLoaded ? state.requests : const <AppointmentModel>[];

    if (requests.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations?.videoCalls ??
              'Remote Session Requests', // استخدام videoCalls بدلاً من remoteSessions
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ...requests.map((request) {
          final requestDate = request.appointmentDate;
          final dateString = requestDate != null
              ? '${requestDate.day}/${requestDate.month}/${requestDate.year}'
              : '';

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            color: Colors.blue.withValues(alpha: 0.1),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.video_call, color: Colors.white),
              ),
              title: Text(
                request.patientName?.toString() ??
                    localizations?.patient ??
                    'Patient',
              ),
              subtitle: Text(dateString),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () {
                      context
                          .read<DoctorBloc>()
                          .add(ApproveRemoteSessionRequest(request.id));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      _showRejectDialog(context, request.id.toString());
                    },
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final localizations = AppLocalizations.of(context);

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
                  localizations?.doctor ?? 'Doctor Name',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  localizations?.specialty ??
                      'Specialty', // specialty غير موجود
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: Text(
              localizations?.home ?? 'Dashboard',
            ), // استخدام home بدلاً من dashboard
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: Text(localizations?.appointments ?? 'Appointments'),
            onTap: () {
              // TODO: Navigate to appointments
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: Text(localizations?.patients ?? 'Patients'),
            onTap: () {
              // TODO: Navigate to patients
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_call),
            title: Text(
              localizations?.videoCalls ?? 'Remote Sessions',
            ), // استخدام videoCalls
            onTap: () {
              // TODO: Navigate to remote sessions
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.medication),
            title: Text(localizations?.prescriptions ?? 'Prescriptions'),
            onTap: () {
              // TODO: Navigate to prescriptions
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.science),
            title: Text(localizations?.labResults ?? 'Lab Results'),
            onTap: () {
              // TODO: Navigate to lab results
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(localizations?.settings ?? 'Settings'),
            onTap: () {
              // TODO: Navigate to settings
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(BuildContext context, String appointmentId) {
    final localizations = AppLocalizations.of(context);
    final reasonController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text(localizations?.reject ?? 'Reject Request'), // reject غير موجود
        content: TextField(
          controller: reasonController,
          decoration: InputDecoration(
            hintText: localizations?.enterReason ??
                'Enter reason', // enterReason غير موجود
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations?.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (reasonController.text.isNotEmpty) {
                Navigator.pop(context);
                context.read<DoctorBloc>().add(
                      RejectRemoteSessionRequest(
                        appointmentId,
                        reasonController.text,
                      ),
                    );
              }
            },
            child: Text(
              localizations?.reject ?? 'Reject', // reject غير موجود
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
