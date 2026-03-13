/// Doctor Dashboard Screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mcs/core/constants/app_routes.dart';
import 'package:mcs/core/enums/appointment_status.dart';
import 'package:mcs/core/localization/app_localizations.dart';
import 'package:mcs/core/models/appointment_model.dart';
import 'package:mcs/core/services/auth_service.dart';
import 'package:mcs/core/widgets/loading_widget.dart';
import 'package:mcs/features/doctor/presentation/bloc/index.dart';
import 'package:mcs/features/localization/presentation/bloc/localization_bloc.dart';
import 'package:mcs/features/localization/presentation/bloc/localization_event.dart';
import 'package:mcs/features/theme/presentation/bloc/theme_bloc.dart';
import 'package:mcs/features/theme/presentation/bloc/theme_event.dart';

/// Doctor dashboard screen
class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({this.isPremium = false, super.key});

  final bool isPremium;

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // ✅ لا نستخدم context هنا
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ✅ آمن تماماً هنا - الـ widget مُدرج بالكامل
    if (!_isInitialized) {
      _loadData();
      _isInitialized = true;
    }
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications screen coming soon'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          // زر تبديل اللغة
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: 'اللغة',
            onPressed: () {
              context.read<LocalizationBloc>().add(const ToggleLanguageEvent());
            },
          ),
          // زر تبديل الثيم
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            tooltip: 'الثيم',
            onPressed: () {
              context.read<ThemeBloc>().add(const ToggleThemeEvent());
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
                _showLogoutConfirmation(context);
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
    var doctorName = 'Doctor';

    if (state is DoctorProfileLoaded) {
      // استخدام fullName إذا كان متوفراً، أو name
      doctorName = (state.profile.fullName ?? state.profile.name ?? 'Doctor')
              .trim()
              .isEmpty
          ? 'Doctor'
          : (state.profile.fullName ?? state.profile.name ?? 'Doctor');
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
          'Upcoming',
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
    final appointments = state is AppointmentsLoaded
        ? state.appointments
        : const <AppointmentModel>[];

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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All appointments screen coming soon'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text(
                'View All',
              ),
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
            final appointmentDate = appointment.appointmentDate;
            final timeString =
                '${appointmentDate.hour}:${appointmentDate.minute.toString().padLeft(2, '0')}';

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(
                  appointment.patientName ?? 'Patient',
                ),
                subtitle: Text(timeString),
                trailing: Icon(
                  appointment.type == AppointmentType.remote
                      ? Icons.video_call
                      : Icons.calendar_month,
                  color: appointment.type == AppointmentType.remote
                      ? Colors.blue
                      : Colors.green,
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildRemoteSessionRequests(BuildContext context, DoctorState state) {
    final localizations = AppLocalizations.of(context);
    final requests = state is RemoteSessionRequestsLoaded
        ? state.requests
        : const <AppointmentModel>[];

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
          final dateString =
              '${requestDate.day}/${requestDate.month}/${requestDate.year}';

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            color: Colors.blue.withValues(alpha: 0.1),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.video_call, color: Colors.white),
              ),
              title: Text(
                request.patientName ?? 'Patient',
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
                      _showRejectDialog(context, request.id);
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
                  'Specialty',
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
            leading: const Icon(Icons.people),
            title: Text(localizations?.patients ?? 'Patients'),
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
            leading: const Icon(Icons.video_call),
            title: Text(
              localizations?.videoCalls ?? 'Remote Sessions',
            ),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Remote sessions screen coming soon'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.medication),
            title: Text(localizations?.prescriptions ?? 'Prescriptions'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Prescriptions screen coming soon'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.science),
            title: Text(localizations?.labResults ?? 'Lab Results'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Lab results screen coming soon'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(localizations?.settings ?? 'Settings'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings screen coming soon'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
              AuthService().signOut();
              if (mounted) {
                context.go(AppRoutes.login);
              }
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(BuildContext context, String appointmentId) {
    final reasonController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Request'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            hintText: 'Enter reason',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (reasonController.text.isNotEmpty) {
                Navigator.of(context).pop();
                context.read<DoctorBloc>().add(
                      RejectRemoteSessionRequest(
                        appointmentId,
                        reasonController.text,
                      ),
                    );
              }
            },
            child: const Text(
              'Reject',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
