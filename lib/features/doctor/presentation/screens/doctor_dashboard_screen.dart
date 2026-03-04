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
    context.read<DoctorBloc>().add(LoadDashboardStats());
    context.read<DoctorBloc>().add(LoadAppointments(status: 'scheduled'));
    context.read<DoctorBloc>().add(LoadRemoteSessionRequests());
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
    String doctorName = 'Doctor';
    if (state is DoctorProfileLoaded) {
      doctorName = state.profile.name;
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
                doctorName.substring(0, 1).toUpperCase(),
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
                    AppLocalizations.of(context).translate('welcome'),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctorName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
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
    Map<String, dynamic> stats = {};
    if (state is DashboardStatsLoaded) {
      stats = state.stats;
    }

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
          AppLocalizations.of(context).translate('total_patients'),
          (stats['total_patients'] ?? 0).toString(),
          Icons.people,
          Colors.blue,
        ),
        _buildStatCard(
          context,
          AppLocalizations.of(context).translate('today_appointments'),
          (stats['today_appointments'] ?? 0).toString(),
          Icons.calendar_today,
          Colors.green,
        ),
        _buildStatCard(
          context,
          AppLocalizations.of(context).translate('upcoming_appointments'),
          (stats['upcoming_appointments'] ?? 0).toString(),
          Icons.upcoming,
          Colors.orange,
        ),
        _buildStatCard(
          context,
          AppLocalizations.of(context).translate('pending_appointments'),
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
    List appointments = [];
    if (state is AppointmentsLoaded) {
      appointments = state.appointments;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context).translate('today_appointments'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to all appointments
              },
              child: Text(AppLocalizations.of(context).translate('view_all')),
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
                  AppLocalizations.of(context).translate('no_appointments_today'),
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
                subtitle: Text('${appointment.appointmentDate.hour}:${appointment.appointmentDate.minute.toString().padLeft(2, '0')}'),
                trailing: Icon(
                  appointment.type == 'remote' ? Icons.video_call : Icons.calendar_month,
                  color: appointment.type == 'remote' ? Colors.blue : Colors.green,
                ),
              ),
            );
          }).toList(),
      ],
    );
  }

  Widget _buildRemoteSessionRequests(BuildContext context, DoctorState state) {
    List requests = [];
    if (state is RemoteSessionRequestsLoaded) {
      requests = state.requests;
    }

    if (requests.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).translate('remote_session_requests'),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ...requests.map((request) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            color: Colors.blue[50],
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.video_call, color: Colors.white),
              ),
              title: Text(request.patientName ?? 'Patient'),
              subtitle: Text('${request.appointmentDate.day}/${request.appointmentDate.month}/${request.appointmentDate.year}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () {
                      context.read<DoctorBloc>().add(ApproveRemoteSessionRequest(request.id));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      _showRejectDialog(context, request.id);
                    },
                  ),
                ],
              ),
            ),
          );
        }).toList(),
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
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Text(
                  'Doctor Name',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Specialty',
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
            leading: const Icon(Icons.video_call),
            title: Text(AppLocalizations.of(context).translate('remote_sessions')),
            onTap: () {
              // TODO: Navigate to remote sessions
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.medication),
            title: Text(AppLocalizations.of(context).translate('prescriptions')),
            onTap: () {
              // TODO: Navigate to prescriptions
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.science),
            title: Text(AppLocalizations.of(context).translate('lab_results')),
            onTap: () {
              // TODO: Navigate to lab results
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

  void _showRejectDialog(BuildContext context, String appointmentId) {
    final reasonController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).translate('reject_request')),
        content: TextField(
          controller: reasonController,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).translate('enter_reason'),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).translate('cancel')),
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
              AppLocalizations.of(context).translate('reject'),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}