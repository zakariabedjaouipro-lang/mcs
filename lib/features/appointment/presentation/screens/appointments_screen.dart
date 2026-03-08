/// Appointments Screen with Tab Navigation
/// Displays appointments with tabs for Today, Upcoming, and History
library;

import 'package:flutter/material.dart';

import 'package:mcs/core/components/empty_error_state.dart';
import 'package:mcs/core/components/medical_info_card.dart';
import 'package:mcs/core/components/skeleton_loaders.dart';
import 'package:mcs/core/theme/medical_colors.dart';
import 'package:mcs/core/utils/extensions.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAppointmentData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAppointmentData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Simulate API call
      await Future<void>.delayed(const Duration(milliseconds: 1500));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Appointments',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        elevation: 1,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? Colors.grey[800]! : MedicalColors.mediumGrey,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: MedicalColors.primary,
              labelColor: MedicalColors.primary,
              unselectedLabelColor: Colors.grey[600],
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'Today'),
                Tab(text: 'Upcoming'),
                Tab(text: 'History'),
              ],
            ),
          ),
        ),
      ),
      body: _hasError
          ? Center(
              child: ErrorStateWidget(
                message: 'Unable to fetch appointment data',
                onRetry: _loadAppointmentData,
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildTodayTab(),
                _buildUpcomingTab(),
                _buildHistoryTab(),
              ],
            ),
    );
  }

  /// Tab 1: Today's Appointments
  Widget _buildTodayTab() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: ListSkeletonLoader(itemCount: 4),
      );
    }

    final appointments = [
      {
        'patient': 'Fatima Al-Mazrouei',
        'doctor': 'Dr. Ahmed Al-Mansoori',
        'time': '09:00 AM',
        'type': 'General Checkup',
        'status': 'Confirmed',
        'icon': Icons.calendar_today,
      },
      {
        'patient': 'Mohammed Al-Qasimi',
        'doctor': 'Dr. Layla Al-Kaabi',
        'time': '10:30 AM',
        'type': 'Diabetes Follow-up',
        'status': 'In Progress',
        'icon': Icons.calendar_today,
      },
      {
        'patient': 'Amira Al-Dhaheri',
        'doctor': 'Dr. Hassan Al-Suwaidi',
        'time': '02:00 PM',
        'type': 'Post-Operative',
        'status': 'Scheduled',
        'icon': Icons.calendar_today,
      },
      {
        'patient': 'Layla Al-Kaabi',
        'doctor': 'Dr. Rashid Al-Mansouri',
        'time': '03:30 PM',
        'type': 'Consultation',
        'status': 'Waiting',
        'icon': Icons.calendar_today,
      },
    ];

    return appointments.isEmpty
        ? Center(
            child: EmptyStateWidget(
              icon: Icons.calendar_today,
              title: 'No Appointments Today',
              message: 'You have no appointments scheduled for today',
              onRefresh: _loadAppointmentData,
            ),
          )
        : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: appointments.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              final statusColor =
                  _getStatusColor(appointment['status']! as String);

              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(12),
                  color: statusColor.withValues(alpha: 0.05),
                ),
                child: MedicalInfoCard(
                  icon: appointment['icon']! as IconData,
                  title: appointment['patient']! as String,
                  subtitle:
                      '${appointment['doctor']} • ${appointment['type']}\n${appointment['time']}',
                  iconColor: MedicalColors.primary,
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      appointment['status']! as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Appointment with ${appointment['patient']}'),
                      ),
                    );
                  },
                ),
              );
            },
          );
  }

  /// Tab 2: Upcoming Appointments
  Widget _buildUpcomingTab() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: ListSkeletonLoader(),
      );
    }

    final appointments = [
      {
        'patient': 'Hassan Al-Mansouri',
        'doctor': 'Dr. Fatima Al-Suwaidi',
        'date': 'Tomorrow, 10:00 AM',
        'type': 'Blood Pressure Check',
        'status': 'Confirmed',
        'icon': Icons.calendar_month,
      },
      {
        'patient': 'Rashid Al-Suwaidi',
        'doctor': 'Dr. Mohammed Al-Kaabi',
        'date': 'Jan 25, 2:30 PM',
        'type': 'Lab Work Review',
        'status': 'Scheduled',
        'icon': Icons.calendar_month,
      },
      {
        'patient': 'Amina Al-Mazrouei',
        'doctor': 'Dr. Sara Al-Mansouri',
        'date': 'Jan 28, 11:00 AM',
        'type': 'Regular Checkup',
        'status': 'Confirmed',
        'icon': Icons.calendar_month,
      },
      {
        'patient': 'Ali Al-Kaabi',
        'doctor': 'Dr. Ahmed Al-Suwaidi',
        'date': 'Feb 1, 3:00 PM',
        'type': 'Consultation',
        'status': 'Scheduled',
        'icon': Icons.calendar_month,
      },
      {
        'patient': 'Salma Al-Dhaheri',
        'doctor': 'Dr. Layla Al-Mansouri',
        'date': 'Feb 5, 9:30 AM',
        'type': 'Follow-up Visit',
        'status': 'Confirmed',
        'icon': Icons.calendar_month,
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        final statusColor = _getStatusColor(appointment['status']! as String);

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: statusColor.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(12),
            color: statusColor.withValues(alpha: 0.05),
          ),
          child: MedicalInfoCard(
            icon: appointment['icon']! as IconData,
            title: appointment['patient']! as String,
            subtitle:
                '${appointment['doctor']} • ${appointment['type']}\n${appointment['date']}',
            iconColor: MedicalColors.secondary,
            trailing: Text(
              appointment['status']! as String,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Appointment with ${appointment['patient']}'),
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Tab 3: Appointment History
  Widget _buildHistoryTab() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: ListSkeletonLoader(),
      );
    }

    final appointments = [
      {
        'patient': 'Noor Al-Qasimi',
        'doctor': 'Dr. Ahmed Al-Mansoori',
        'date': 'Jan 10, 2024',
        'type': 'General Checkup',
        'status': 'Completed',
        'icon': Icons.history,
      },
      {
        'patient': 'Zainab Al-Kaabi',
        'doctor': 'Dr. Fatima Al-Suwaidi',
        'date': 'Jan 5, 2024',
        'type': 'Diabetes Review',
        'status': 'Completed',
        'icon': Icons.history,
      },
      {
        'patient': 'Omar Al-Mansouri',
        'doctor': 'Dr. Hassan Al-Dhaheri',
        'date': 'Dec 28, 2023',
        'type': 'Post-Op Checkup',
        'status': 'Completed',
        'icon': Icons.history,
      },
      {
        'patient': 'Hind Al-Suwaidi',
        'doctor': 'Dr. Mohammed Al-Kaabi',
        'date': 'Dec 20, 2023',
        'type': 'Consultation',
        'status': 'Completed',
        'icon': Icons.history,
      },
      {
        'patient': 'Karim Al-Mazrouei',
        'doctor': 'Dr. Sara Al-Mansouri',
        'date': 'Dec 15, 2023',
        'type': 'Laboratory Follow-up',
        'status': 'Completed',
        'icon': Icons.history,
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final appointment = appointments[index];

        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.withValues(alpha: 0.05),
          ),
          child: MedicalInfoCard(
            icon: appointment['icon']! as IconData,
            title: appointment['patient']! as String,
            subtitle:
                '${appointment['doctor']} • ${appointment['type']}\n${appointment['date']}',
            iconColor: MedicalColors.accent,
            trailing: Text(
              appointment['status']! as String,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4CAF50),
              ),
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Appointment with ${appointment['patient']}'),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFF4CAF50); // Green
      case 'scheduled':
        return MedicalColors.primary; // Turquoise
      case 'in progress':
        return const Color(0xFFFF9800); // Orange
      case 'waiting':
        return const Color(0xFFFF9800); // Orange
      case 'completed':
        return const Color(0xFF4CAF50); // Green
      default:
        return Colors.grey;
    }
  }
}
