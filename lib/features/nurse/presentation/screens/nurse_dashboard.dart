/// Nurse Dashboard - لوحة تحكم الممرض
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/config/injection_container.dart';
import 'package:mcs/core/services/supabase_service.dart';
import 'package:mcs/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:mcs/features/admin/presentation/bloc/admin_event.dart'
    as admin_events;
import 'package:mcs/features/admin/presentation/bloc/admin_state.dart';

/// Nurse Dashboard Screen
class NurseDashboard extends StatelessWidget {
  const NurseDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminBloc(sl<SupabaseService>())
        ..add(const admin_events.LoadPatients())
        ..add(const admin_events.LoadAppointments()),
      child: const _NurseDashboardView(),
    );
  }
}

class _NurseDashboardView extends StatefulWidget {
  const _NurseDashboardView();

  @override
  State<_NurseDashboardView> createState() => _NurseDashboardViewState();
}

class _NurseDashboardViewState extends State<_NurseDashboardView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: Text(isArabic ? 'لوحة تحكم الممرض' : 'Nurse Dashboard'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminInitial || state is AdminLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return DefaultTabController(
            length: 3,
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(text: isArabic ? 'المرضى' : 'Patients'),
                    Tab(text: isArabic ? 'المواعيد' : 'Appointments'),
                    Tab(text: isArabic ? 'المهام' : 'Tasks'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildPatientsTab(context, state, isArabic),
                      _buildAppointmentsTab(context, state, isArabic),
                      _buildTasksTab(context, isArabic),
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

  Widget _buildPatientsTab(
      BuildContext context, AdminState state, bool isArabic) {
    if (state is PatientsLoaded && state.patients.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.patients.length,
        itemBuilder: (_, i) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text('Patient ${state.patients[i].id.substring(0, 8)}'),
            subtitle: Text(state.patients[i].gender ?? 'N/A'),
          ),
        ),
      );
    }
    return Center(child: Text(isArabic ? 'لا توجد بيانات' : 'No data'));
  }

  Widget _buildAppointmentsTab(
      BuildContext context, AdminState state, bool isArabic) {
    if (state is AppointmentsLoaded && state.appointments.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.appointments.length,
        itemBuilder: (_, i) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(Icons.event),
            title: Text(state.appointments[i].appointmentDate.toString()),
            subtitle: Text(
                '${state.appointments[i].patientId} - ${state.appointments[i].doctorId}'),
          ),
        ),
      );
    }
    return Center(child: Text(isArabic ? 'لا توجد مواعيد' : 'No appointments'));
  }

  Widget _buildTasksTab(BuildContext context, bool isArabic) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        CheckboxListTile(
          value: true,
          onChanged: (_) {},
          title: Text(isArabic ? 'مراقبة المرضى' : 'Patient Monitoring'),
        ),
        CheckboxListTile(
          value: false,
          onChanged: (_) {},
          title:
              Text(isArabic ? 'تسجيل العلامات الحيوية' : 'Record Vital Signs'),
        ),
      ],
    );
  }
}
