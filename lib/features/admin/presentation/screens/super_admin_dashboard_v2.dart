/// Super Admin Dashboard v2 - مع محتوى عملي حقيقي
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/config/injection_container.dart';
import 'package:mcs/core/services/supabase_service.dart';
import 'package:mcs/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:mcs/features/admin/presentation/bloc/admin_event.dart'
    as admin_events;
import 'package:mcs/features/admin/presentation/bloc/admin_state.dart';

/// Super Admin Dashboard Screen
class SuperAdminDashboardV2 extends StatelessWidget {
  const SuperAdminDashboardV2({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminBloc(sl<SupabaseService>())
        ..add(const admin_events.LoadDashboardStats())
        ..add(const admin_events.LoadDoctors())
        ..add(const admin_events.LoadPatients())
        ..add(const admin_events.LoadAppointments())
        ..add(const admin_events.LoadPayments())
        ..add(const admin_events.LoadClinics())
        ..add(const admin_events.LoadPendingApprovals()),
      child: const _SuperAdminDashboardView(),
    );
  }
}

class _SuperAdminDashboardView extends StatefulWidget {
  const _SuperAdminDashboardView();

  @override
  State<_SuperAdminDashboardView> createState() =>
      _SuperAdminDashboardViewState();
}

class _SuperAdminDashboardViewState extends State<_SuperAdminDashboardView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
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
            isArabic ? 'لوحة تحكم المسؤول الأعلى' : 'Super Admin Dashboard'),
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminInitial || state is AdminLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is AdminError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
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
            length: 6,
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
                    Tab(text: isArabic ? 'الموافقات' : 'Approvals'),
                    Tab(text: isArabic ? 'المدفوعات' : 'Payments'),
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
                      _buildApprovalsTab(context, state, isArabic),
                      _buildPaymentsTab(context, state, isArabic),
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

  // ═══════════════════════════════════════════════════════════════
  // STATISTICS TAB
  // ═══════════════════════════════════════════════════════════════

  Widget _buildStatisticsTab(
    BuildContext context,
    AdminState state,
    bool isArabic,
  ) {
    if (state is DashboardStatsLoaded) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isArabic ? 'إحصائيات النظام' : 'System Statistics',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _buildStatCard(
                  context,
                  label: isArabic ? 'العيادات' : 'Clinics',
                  value: state.totalClinics.toString(),
                  icon: Icons.local_hospital,
                  color: Colors.blue,
                ),
                _buildStatCard(
                  context,
                  label: isArabic ? 'المستخدمون' : 'Users',
                  value: state.totalUsers.toString(),
                  icon: Icons.people,
                  color: Colors.green,
                ),
                _buildStatCard(
                  context,
                  label: isArabic ? 'الإيرادات (USD)' : 'Revenue (USD)',
                  value: '\$${state.totalRevenueUsd.toStringAsFixed(2)}',
                  icon: Icons.attach_money,
                  color: Colors.orange,
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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.1),
              color.withValues(alpha: 0.05),
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
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // DOCTORS TAB
  // ═══════════════════════════════════════════════════════════════

  Widget _buildDoctorsTab(
    BuildContext context,
    AdminState state,
    bool isArabic,
  ) {
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
              onTap: () {},
            ),
          );
        },
      );
    }
    return const SizedBox.shrink();
  }

  // ═══════════════════════════════════════════════════════════════
  // PATIENTS TAB
  // ═══════════════════════════════════════════════════════════════

  Widget _buildPatientsTab(
    BuildContext context,
    AdminState state,
    bool isArabic,
  ) {
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
              subtitle: Text(
                patient.gender != null
                    ? 'Gender: ${patient.gender}'
                    : 'No gender info',
              ),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {},
            ),
          );
        },
      );
    }
    return const SizedBox.shrink();
  }

  // ═══════════════════════════════════════════════════════════════
  // APPOINTMENTS TAB
  // ═══════════════════════════════════════════════════════════════

  Widget _buildAppointmentsTab(
    BuildContext context,
    AdminState state,
    bool isArabic,
  ) {
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
          final appointment = state.appointments[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.event)),
              title: Text('${appointment.patientId} - ${appointment.doctorId}'),
              subtitle: Text(appointment.appointmentDate.toString()),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {},
            ),
          );
        },
      );
    }
    return const SizedBox.shrink();
  }

  // ═══════════════════════════════════════════════════════════════
  // APPROVALS TAB
  // ═══════════════════════════════════════════════════════════════

  Widget _buildApprovalsTab(
    BuildContext context,
    AdminState state,
    bool isArabic,
  ) {
    if (state is PendingApprovalsLoaded) {
      if (state.approvalRequests.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline,
                  size: 64, color: Colors.green),
              const SizedBox(height: 16),
              Text(
                isArabic ? 'لا توجد طلبات معلقة' : 'No pending approvals',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.approvalRequests.length,
        itemBuilder: (context, index) {
          final approval = state.approvalRequests[index];
          final userId = approval['user_id'] ?? 'Unknown';
          final email = approval['email'] ?? 'N/A';
          final fullName = approval['full_name'] ?? 'N/A';
          final role = approval['role'] ?? 'N/A';
          final status = approval['status'] ?? 'pending';
          final createdAt = approval['created_at'] ?? 'N/A';

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            child: ExpansionTile(
              leading: const Icon(Icons.person),
              title: Text(fullName.toString()),
              subtitle: Text(email.toString()),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildApprovalDetail(
                        context,
                        label: isArabic ? 'معرّف المستخدم' : 'User ID',
                        value: userId.toString().substring(0, 8),
                      ),
                      const SizedBox(height: 12),
                      _buildApprovalDetail(
                        context,
                        label: isArabic ? 'الدور' : 'Role',
                        value: role.toString(),
                      ),
                      const SizedBox(height: 12),
                      _buildApprovalDetail(
                        context,
                        label: isArabic ? 'الحالة' : 'Status',
                        value: status.toString(),
                        valueColor: status.toString() == 'approved'
                            ? Colors.green
                            : status.toString() == 'rejected'
                                ? Colors.red
                                : Colors.orange,
                      ),
                      const SizedBox(height: 12),
                      _buildApprovalDetail(
                        context,
                        label: isArabic ? 'تاريخ الطلب' : 'Request Date',
                        value: createdAt.toString().substring(0, 10),
                      ),
                      const SizedBox(height: 16),
                      if (status.toString() == 'pending')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                _showApprovalDialog(
                                  context,
                                  userId.toString(),
                                  fullName.toString(),
                                  isApprove: true,
                                  isArabic: isArabic,
                                );
                              },
                              icon: const Icon(Icons.check),
                              label: Text(isArabic ? 'موافقة' : 'Approve'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                _showApprovalDialog(
                                  context,
                                  userId.toString(),
                                  fullName.toString(),
                                  isApprove: false,
                                  isArabic: isArabic,
                                );
                              },
                              icon: const Icon(Icons.close),
                              label: Text(isArabic ? 'رفض' : 'Reject'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    if (state is AdminLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is AdminError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              state.message,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                context
                    .read<AdminBloc>()
                    .add(const admin_events.LoadPendingApprovals());
              },
              icon: const Icon(Icons.refresh),
              label: Text(isArabic ? 'إعادة محاولة' : 'Retry'),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 64,
            color: Colors.blue.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            isArabic ? 'تحميل الموافقات...' : 'Loading approvals...',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context
                  .read<AdminBloc>()
                  .add(const admin_events.LoadPendingApprovals());
            },
            icon: const Icon(Icons.refresh),
            label: Text(isArabic ? 'تحديث' : 'Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalDetail(
    BuildContext context, {
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: valueColor,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }

  void _showApprovalDialog(
    BuildContext context,
    String userId,
    String userName, {
    required bool isApprove,
    required bool isArabic,
  }) {
    final textController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isApprove
              ? (isArabic ? 'تأكيد الموافقة' : 'Confirm Approval')
              : (isArabic ? 'تأكيد الرفض' : 'Confirm Rejection'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isArabic ? 'المستخدم: $userName' : 'User: $userName',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: isApprove
                    ? (isArabic
                        ? 'ملاحظات الموافقة (اختياري)'
                        : 'Approval notes (optional)')
                    : (isArabic
                        ? 'سبب الرفض (مطلوب)'
                        : 'Rejection reason (required)'),
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // هنا يتم إرسال الحدث للموافقة أو الرفض
              if (isApprove) {
                context.read<AdminBloc>().add(
                      admin_events.ApproveUserEvent(
                        userId: userId,
                        approvalNotes: textController.text,
                      ),
                    );
              } else {
                if (textController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isArabic
                            ? 'يرجى إدخال سبب الرفض'
                            : 'Please enter rejection reason',
                      ),
                    ),
                  );
                  return;
                }
                context.read<AdminBloc>().add(
                      admin_events.RejectUserEvent(
                        userId: userId,
                        rejectionReason: textController.text,
                      ),
                    );
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isApprove ? Colors.green : Colors.red,
            ),
            child: Text(
              isApprove
                  ? (isArabic ? 'موافقة' : 'Approve')
                  : (isArabic ? 'رفض' : 'Reject'),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // PAYMENTS TAB
  // ═══════════════════════════════════════════════════════════════

  Widget _buildPaymentsTab(
    BuildContext context,
    AdminState state,
    bool isArabic,
  ) {
    if (state is PaymentsLoaded) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isArabic ? 'إحصائيات الدفعات' : 'Payment Statistics',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildStatCard(
              context,
              label: isArabic ? 'إجمالي الإيرادات' : 'Total Revenue',
              value: '\$${state.totalRevenue.toStringAsFixed(2)}',
              icon: Icons.attach_money,
              color: Colors.green,
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              context,
              label: isArabic ? 'الدفعات المعلقة' : 'Pending Payments',
              value: state.pendingPayments.toString(),
              icon: Icons.schedule,
              color: Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              context,
              label: isArabic ? 'الدفعات المكتملة' : 'Completed Payments',
              value: state.completedPayments.toString(),
              icon: Icons.check_circle,
              color: Colors.green,
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
