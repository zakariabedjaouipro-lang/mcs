/// Receptionist Dashboard - لوحة تحكم موظف الاستقبال
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/config/injection_container.dart';
import 'package:mcs/core/services/supabase_service.dart';
import 'package:mcs/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:mcs/features/admin/presentation/bloc/admin_event.dart'
    as admin_events;
import 'package:mcs/features/admin/presentation/bloc/admin_state.dart';

class ReceptionistDashboard extends StatelessWidget {
  const ReceptionistDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminBloc(sl<SupabaseService>())
        ..add(const admin_events.LoadAppointments())
        ..add(const admin_events.LoadPatients()),
      child: const _ReceptionistDashboardView(),
    );
  }
}

class _ReceptionistDashboardView extends StatefulWidget {
  const _ReceptionistDashboardView();

  @override
  State<_ReceptionistDashboardView> createState() =>
      _ReceptionistDashboardViewState();
}

class _ReceptionistDashboardViewState extends State<_ReceptionistDashboardView>
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
        title:
            Text(isArabic ? 'لوحة تحكم الاستقبال' : 'Receptionist Dashboard'),
        backgroundColor: Colors.amber,
      ),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading)
            return const Center(child: CircularProgressIndicator());

          return DefaultTabController(
            length: 3,
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(
                        text: isArabic
                            ? 'المواعيد اليومية'
                            : 'Today\'s Appointments'),
                    Tab(text: isArabic ? 'المرضى الجدد' : 'New Patients'),
                    Tab(text: isArabic ? 'الجداول' : 'Schedules'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildAppointmentsTab(context, state, isArabic),
                      _buildPatientsTab(context, state, isArabic),
                      _buildSchedulesTab(context, isArabic),
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

  Widget _buildAppointmentsTab(
      BuildContext context, AdminState state, bool isArabic) {
    if (state is AppointmentsLoaded) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.appointments.length,
        itemBuilder: (_, i) => Card(
          child: ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Text(state.appointments[i].appointmentDate
                .toString()
                .substring(0, 10)),
            subtitle: Text(
                '${state.appointments[i].patientId} - ${state.appointments[i].doctorId}'),
            trailing: ElevatedButton(
              onPressed: () {},
              child: Text(isArabic ? 'تأكيد' : 'Confirm'),
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildPatientsTab(
      BuildContext context, AdminState state, bool isArabic) {
    if (state is PatientsLoaded) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.patients.length,
        itemBuilder: (_, i) => Card(
          child: ListTile(
            leading: const Icon(Icons.person_add),
            title: Text('Patient ${state.patients[i].id.substring(0, 8)}'),
            subtitle: Text(state.patients[i].gender ?? 'N/A'),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildSchedulesTab(BuildContext context, bool isArabic) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.schedule),
          title: Text(
              isArabic ? 'الدكتور أحمد - 08:00 AM' : 'Dr. Ahmed - 08:00 AM'),
        ),
      ],
    );
  }
}
