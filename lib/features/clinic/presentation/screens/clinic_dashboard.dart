/// Clinic Admin Dashboard - لوحة تحكم مدير العيادة
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/config/injection_container.dart';
import 'package:mcs/core/services/supabase_service.dart';
import 'package:mcs/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:mcs/features/admin/presentation/bloc/admin_event.dart'
    as admin_events;
import 'package:mcs/features/admin/presentation/bloc/admin_state.dart';

/// Clinic Admin Dashboard Screen
class ClinicDashboard extends StatelessWidget {
  const ClinicDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminBloc(sl<SupabaseService>())
        ..add(const admin_events.LoadDashboardStats())
        ..add(const admin_events.LoadDoctors())
        ..add(const admin_events.LoadPatients())
        ..add(const admin_events.LoadAppointments()),
      child: const _ClinicDashboardView(),
    );
  }
}

class _ClinicDashboardView extends StatefulWidget {
  const _ClinicDashboardView();

  @override
  State<_ClinicDashboardView> createState() => _ClinicDashboardViewState();
}

class _ClinicDashboardViewState extends State<_ClinicDashboardView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(
            isArabic ? 'لوحة تحكم مدير العيادة' : 'Clinic Admin Dashboard'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminInitial || state is AdminLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AdminError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<AdminBloc>()
                          .add(const admin_events.LoadDashboardStats());
                    },
                    child: Text(isArabic ? 'إعادة محاولة' : 'Retry'),
                  ),
                ],
              ),
            );
          }

          return DefaultTabController(
            length: 5,
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: [
                    Tab(text: isArabic ? 'الإحصائيات' : 'Statistics'),
                    Tab(text: isArabic ? 'الأطباء' : 'Doctors'),
                    Tab(text: isArabic ? 'المرضى' : 'Patients'),
                    Tab(text: isArabic ? 'المواعيد' : 'Appointments'),
                    Tab(text: isArabic ? 'الإعدادات' : 'Settings'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildStatisticsTab(context, state, isArabic),
                      _buildDoctorsTab(context, state, isArabic),
                      _buildPatientsTab(context, state, isArabic),
                      _buildAppointmentsTab(context, state, isArabic),
                      _buildSettingsTab(context, isArabic),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatisticsTab(
      BuildContext context, AdminState state, bool isArabic) {
    if (state is DashboardStatsLoaded) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isArabic ? 'إحصائيات العيادة' : 'Clinic Statistics',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _buildStatCard(
                  context,
                  label: isArabic ? 'المرضى النشطون' : 'Active Patients',
                  value: state.totalUsers.toString(),
                  icon: Icons.people,
                  color: Colors.teal,
                ),
                _buildStatCard(
                  context,
                  label: isArabic ? 'الأطباء' : 'Doctors',
                  value: state.totalClinics.toString(),
                  icon: Icons.medical_services,
                  color: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.1),
              color.withValues(alpha: 0.05)
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(value,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: color, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(label,
                  style: Theme.of(context).textTheme.labelSmall, maxLines: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorsTab(
      BuildContext context, AdminState state, bool isArabic) {
    if (state is DoctorsLoaded) {
      if (state.doctors.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.medical_services_outlined,
                  size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(isArabic ? 'لا توجد بيانات للأطباء' : 'No doctors found'),
            ],
          ),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.doctors.length,
        itemBuilder: (context, index) {
          final doctor = state.doctors[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(doctor.fullName ?? doctor.name ?? 'Unknown'),
              subtitle: Text(doctor.licenseNumber ?? 'No license'),
              trailing: const Icon(Icons.arrow_forward),
            ),
          );
        },
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildPatientsTab(
      BuildContext context, AdminState state, bool isArabic) {
    if (state is PatientsLoaded) {
      if (state.patients.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.people_outline, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(isArabic ? 'لا توجد بيانات للمرضى' : 'No patients found'),
            ],
          ),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.patients.length,
        itemBuilder: (context, index) {
          final patient = state.patients[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text('Patient ${patient.id.substring(0, 8)}'),
              subtitle: Text(patient.gender != null
                  ? 'Gender: ${patient.gender}'
                  : 'No gender info'),
              trailing: const Icon(Icons.arrow_forward),
            ),
          );
        },
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildAppointmentsTab(
      BuildContext context, AdminState state, bool isArabic) {
    if (state is AppointmentsLoaded) {
      if (state.appointments.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_today_outlined,
                  size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(isArabic ? 'لا توجد مواعيد' : 'No appointments found'),
            ],
          ),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.appointments.length,
        itemBuilder: (context, index) {
          final apt = state.appointments[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.event)),
              title: Text('${apt.patientId} - ${apt.doctorId}'),
              subtitle: Text(apt.appointmentDate.toString()),
              trailing: const Icon(Icons.arrow_forward),
            ),
          );
        },
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildSettingsTab(BuildContext context, bool isArabic) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.edit),
          title: Text(isArabic ? 'تعديل معلومات العيادة' : 'Edit Clinic Info'),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.people),
          title: Text(isArabic ? 'إدارة الموظفين' : 'Manage Staff'),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.security),
          title: Text(isArabic ? 'الأمان والخصوصية' : 'Security & Privacy'),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {},
        ),
      ],
    );
  }
}
