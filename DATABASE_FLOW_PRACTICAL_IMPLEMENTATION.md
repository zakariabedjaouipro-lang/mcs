# دليل التطبيق العملي - تدفق البيانات
## Practical Implementation Guide

---

## 🎯 مثال شامل: نظام لوحة التحكم

### الخطوة 1: إنشاء الحدث (Event)

**ملف: `lib/features/admin/presentation/bloc/admin_event.dart`**

```dart
part of 'admin_bloc.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object?> get props => [];
}

// ◄── حدث تحميل الأطباء
class LoadDoctors extends AdminEvent {
  const LoadDoctors();
}

// ◄── حدث تحميل المرضى
class LoadPatients extends AdminEvent {
  const LoadPatients();
}

// ◄── حدث تحميل المواعيد
class LoadAppointments extends AdminEvent {
  const LoadAppointments({
    this.filters,
    this.orderBy = 'created_at',
  });

  final Map<String, dynamic>? filters; // ◄── تصفية إضافية
  final String orderBy;
}

// ◄── حدث تحميل الإحصائيات
class LoadDashboardStats extends AdminEvent {
  const LoadDashboardStats();
}
```

---

### الخطوة 2: تعريف الحالات (States)

**ملف: `lib/features/admin/presentation/bloc/admin_state.dart`**

```dart
part of 'admin_bloc.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object?> get props => [];
}

// ◄── الحالة الابتدائية
class AdminInitial extends AdminState {
  const AdminInitial();
}

// ◄── حالة التحميل (تظهر Spinner)
class AdminLoading extends AdminState {
  const AdminLoading();
}

// ◄── حالة الخطأ
class AdminError extends AdminState {
  final String message;
  
  const AdminError(this.message);

  @override
  List<Object> get props => [message];
}

// ◄── حالة نجاح تحميل الأطباء
class DoctorsLoaded extends AdminState {
  final List<DoctorModel> doctors;
  
  const DoctorsLoaded(this.doctors);

  @override
  List<Object> get props => [doctors];
}

// ◄── حالة نجاح تحميل المرضى
class PatientsLoaded extends AdminState {
  final List<PatientModel> patients;
  
  const PatientsLoaded(this.patients);

  @override
  List<Object> get props => [patients];
}

// ◄── حالة نجاح تحميل المواعيد
class AppointmentsLoaded extends AdminState {
  final List<AppointmentModel> appointments;
  
  const AppointmentsLoaded(this.appointments);

  @override
  List<Object> get props => [appointments];
}

// ◄── حالة نجاح تحميل الإحصائيات
class DashboardStatsLoaded extends AdminState {
  final int totalClinics;
  final int totalDoctors;
  final int totalPatients;
  final int totalAppointments;
  final int pendingApprovals;
  final double totalRevenue;
  
  const DashboardStatsLoaded({
    required this.totalClinics,
    required this.totalDoctors,
    required this.totalPatients,
    required this.totalAppointments,
    required this.pendingApprovals,
    required this.totalRevenue,
  });

  @override
  List<Object> get props => [
    totalClinics,
    totalDoctors,
    totalPatients,
    totalAppointments,
    pendingApprovals,
    totalRevenue,
  ];
}
```

---

### الخطوة 3: منطق BLoC

**ملف: `lib/features/admin/presentation/bloc/admin_bloc.dart`**

```dart
part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final SupabaseService _supabaseService;

  AdminBloc({required SupabaseService supabaseService})
      : _supabaseService = supabaseService,
        super(const AdminInitial()) {
    // ◄── تسجيل معالجات الأحداث
    on<LoadDoctors>(_onLoadDoctors);
    on<LoadPatients>(_onLoadPatients);
    on<LoadAppointments>(_onLoadAppointments);
    on<LoadDashboardStats>(_onLoadDashboardStats);
  }

  // ╔══════════════════════════════════════════════════════╗
  // ║ معالج 1: تحميل الأطباء                              ║
  // ╚══════════════════════════════════════════════════════╝
  Future<void> _onLoadDoctors(
    LoadDoctors event,
    Emitter<AdminState> emit,
  ) async {
    // 1️⃣ إصدار حالة التحميل
    emit(const AdminLoading());

    try {
      // 2️⃣ جلب البيانات من Supabase
      final data = await _supabaseService.fetchAll(
        'doctors', // ◄── اسم الجدول
        orderBy: 'created_at',
        ascending: false,
      );

      // 3️⃣ تحويل JSON إلى نماذج Dart
      final doctors = data.map(DoctorModel.fromJson).toList();

      // 4️⃣ إصدار حالة النجاح
      emit(DoctorsLoaded(doctors));
    } catch (e) {
      // ❌ إصدار حالة الخطأ
      emit(AdminError('خطأ تحميل الأطباء: ${e.toString()}'));
    }
  }

  // ╔══════════════════════════════════════════════════════╗
  // ║ معالج 2: تحميل المرضى                              ║
  // ╚══════════════════════════════════════════════════════╝
  Future<void> _onLoadPatients(
    LoadPatients event,
    Emitter<AdminState> emit,
  ) async {
    emit(const AdminLoading());

    try {
      final data = await _supabaseService.fetchAll(
        'patients',
        orderBy: 'created_at',
        ascending: false,
      );

      final patients = data.map(PatientModel.fromJson).toList();
      emit(PatientsLoaded(patients));
    } catch (e) {
      emit(AdminError('خطأ تحميل المرضى: ${e.toString()}'));
    }
  }

  // ╔══════════════════════════════════════════════════════╗
  // ║ معالج 3: تحميل المواعيد (مع التصفية)               ║
  // ╚══════════════════════════════════════════════════════╝
  Future<void> _onLoadAppointments(
    LoadAppointments event,
    Emitter<AdminState> emit,
  ) async {
    emit(const AdminLoading());

    try {
      // ◄── باستخدام الفلترة والترتيب
      final data = await _supabaseService.fetchAll(
        'appointments',
        filters: event.filters,
        orderBy: event.orderBy,
        ascending: false,
      );

      final appointments = data.map(AppointmentModel.fromJson).toList();
      emit(AppointmentsLoaded(appointments));
    } catch (e) {
      emit(AdminError('خطأ تحميل المواعيد: ${e.toString()}'));
    }
  }

  // ╔══════════════════════════════════════════════════════╗
  // ║ معالج 4: تحميل الإحصائيات (معقد)                   ║
  // ╚══════════════════════════════════════════════════════╝
  Future<void> _onLoadDashboardStats(
    LoadDashboardStats event,
    Emitter<AdminState> emit,
  ) async {
    emit(const AdminLoading());

    try {
      // جلب البيانات من 6 جداول مختلفة بالتوازي
      final clinicsData = await _supabaseService.fetchAll('clinics');
      final doctorsData = await _supabaseService.fetchAll('doctors');
      final patientsData = await _supabaseService.fetchAll('patients');
      final appointmentsData = await _supabaseService.fetchAll('appointments');
      final pendingApprovalsData = await _supabaseService.fetchAll(
        'registration_requests',
        filters: {'status': 'pending'},
      );
      final paymentsData = await _supabaseService.fetchAll('payments');

      // حساب الإحصائيات
      final totalRevenue = paymentsData
          .fold<double>(0, (sum, payment) => sum + (payment['amount'] as num));

      // إصدار الحالة مع جميع الإحصائيات
      emit(DashboardStatsLoaded(
        totalClinics: clinicsData.length,
        totalDoctors: doctorsData.length,
        totalPatients: patientsData.length,
        totalAppointments: appointmentsData.length,
        pendingApprovals: pendingApprovalsData.length,
        totalRevenue: totalRevenue,
      ));
    } catch (e) {
      emit(AdminError('خطأ تحميل الإحصائيات: ${e.toString()}'));
    }
  }
}
```

---

### الخطوة 4: الواجهة (UI)

**ملف: `lib/features/admin/presentation/screens/super_admin_dashboard_v2.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SuperAdminDashboardV2 extends StatefulWidget {
  const SuperAdminDashboardV2({Key? key}) : super(key: key);

  @override
  State<SuperAdminDashboardV2> createState() => _SuperAdminDashboardV2State();
}

class _SuperAdminDashboardV2State extends State<SuperAdminDashboardV2>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);

    // ◄── تحميل البيانات عند فتح الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final adminBloc = context.read<AdminBloc>();
      adminBloc.add(const LoadDashboardStats());
      adminBloc.add(const LoadDoctors());
      adminBloc.add(const LoadPatients());
      adminBloc.add(const LoadAppointments());
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة التحكم'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'الإحصائيات'),
            Tab(text: 'الأطباء'),
            Tab(text: 'المرضى'),
            Tab(text: 'المواعيد'),
            Tab(text: 'الطلبات'),
            Tab(text: 'المدفوعات'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStatsTab(),
          _buildDoctorsTab(),
          _buildPatientsTab(),
          _buildAppointmentsTab(),
          _buildApprovalsTab(),
          _buildPaymentsTab(),
        ],
      ),
    );
  }

  // ◄── عرض الإحصائيات
  Widget _buildStatsTab() {
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (context, state) {
        if (state is AdminLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DashboardStatsLoaded) {
          return GridView(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            children: [
              _StatCard(
                title: 'العيادات',
                value: state.totalClinics.toString(),
                color: Colors.blue,
              ),
              _StatCard(
                title: 'الأطباء',
                value: state.totalDoctors.toString(),
                color: Colors.green,
              ),
              _StatCard(
                title: 'المرضى',
                value: state.totalPatients.toString(),
                color: Colors.orange,
              ),
              _StatCard(
                title: 'المواعيد',
                value: state.totalAppointments.toString(),
                color: Colors.red,
              ),
              _StatCard(
                title: 'الطلبات المعلقة',
                value: state.pendingApprovals.toString(),
                color: Colors.purple,
              ),
              _StatCard(
                title: 'الإيرادات',
                value: '\$${state.totalRevenue.toStringAsFixed(2)}',
                color: Colors.teal,
              ),
            ],
          );
        }

        if (state is AdminError) {
          return Center(child: Text('خطأ: ${state.message}'));
        }

        return const SizedBox.shrink();
      },
    );
  }

  // ◄── عرض الأطباء
  Widget _buildDoctorsTab() {
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (context, state) {
        if (state is AdminLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DoctorsLoaded) {
          if (state.doctors.isEmpty) {
            return const Center(child: Text('لا توجد أطباء'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: state.doctors.length,
            itemBuilder: (context, index) {
              final doctor = state.doctors[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      doctor.name
                          ?.toUpperCase()
                          .substring(0, 1) ?? '?',
                    ),
                  ),
                  title: Text(
                    doctor.fullName ?? doctor.name ?? 'Unknown',
                  ),
                  subtitle: Text(
                    'License: ${doctor.licenseNumber ?? 'N/A'}',
                  ),
                  trailing: Text(
                    '${doctor.experienceYears ?? 0} سنة',
                  ),
                ),
              );
            },
          );
        }

        if (state is AdminError) {
          return Center(child: Text('خطأ: ${state.message}'));
        }

        return const SizedBox.shrink();
      },
    );
  }

  // ◄── عرض المرضى
  Widget _buildPatientsTab() {
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (context, state) {
        if (state is AdminLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PatientsLoaded) {
          if (state.patients.isEmpty) {
            return const Center(child: Text('لا يوجد مرضى'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: state.patients.length,
            itemBuilder: (context, index) {
              final patient = state.patients[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text('Patient ID: ${patient.id.substring(0, 8)}'),
                  subtitle: Text(
                    'Gender: ${patient.gender ?? 'Unknown'} | '
                    'Blood: ${patient.bloodType ?? 'Unknown'}',
                  ),
                  trailing: Text(
                    'Age: ${_calculateAge(patient.dateOfBirth)}',
                  ),
                ),
              );
            },
          );
        }

        if (state is AdminError) {
          return Center(child: Text('خطأ: ${state.message}'));
        }

        return const SizedBox.shrink();
      },
    );
  }

  // ◄── عرض المواعيد
  Widget _buildAppointmentsTab() {
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (context, state) {
        if (state is AdminLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AppointmentsLoaded) {
          if (state.appointments.isEmpty) {
            return const Center(child: Text('لا توجد مواعيد'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: state.appointments.length,
            itemBuilder: (context, index) {
              final apt = state.appointments[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text('Appointment ID: ${apt.id.substring(0, 8)}'),
                  subtitle: Text(
                    'Status: ${apt.status} | Duration: ${apt.duration} min',
                  ),
                  trailing: Text(apt.scheduledTime?.toString() ?? 'N/A'),
                ),
              );
            },
          );
        }

        if (state is AdminError) {
          return Center(child: Text('خطأ: ${state.message}'));
        }

        return const SizedBox.shrink();
      },
    );
  }

  // ◄── عرض الطلبات (إضافي)
  Widget _buildApprovalsTab() {
    return Center(
      child: Text('سيتم تحديثه قريباً'),
    );
  }

  // ◄── عرض المدفوعات (إضافي)
  Widget _buildPaymentsTab() {
    return Center(
      child: Text('سيتم تحديثه قريباً'),
    );
  }

  // ◄── دالة مساعدة: حساب العمر
  int _calculateAge(DateTime? dateOfBirth) {
    if (dateOfBirth == null) return 0;
    final now = DateTime.now();
    return now.year - dateOfBirth.year;
  }
}

// ◄── Widget بطاقة الإحصائية
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}
```

---

## 📱 التطبيق العملي خطوة بخطوة

### 1. تشغيل التطبيق
```dart
// المستخدم يفتح التطبيق
// 1: initState() يُستدعى
// 2: يُصدار إحداث LoadDashboardStats و LoadDoctors و LoadPatients
```

### 2. استقبال أول حدث
```dart
// BLoC يستقبل LoadDashboardStats
// 1: emit(AdminLoading) ──► الشاشة تظهر Spinner
// 2: جلب من 6 جداول مختلفة
```

### 3. معالجة البيانات
```dart
// تحويل JSON إلى نماذج
// حساب الإحصائيات
// emit(DashboardStatsLoaded(...))
```

### 4. عرض النتائج
```dart
// BlocBuilder يلتقط الحالة الجديدة
// يظهر الشاشة مع البيانات الحقيقية
```

---

## 🔄 تدفق مثال عملي كامل

```
1️⃣ المستخدم يضغط على tab "الأطباء"
        ↓
2️⃣ _tabController يتغير
        ↓
3️⃣ build() يُستدعى مرة أخرى
        ↓
4️⃣ BlocBuilder يبني _buildDoctorsTab()
        ↓
5️⃣ "إذا لم تكن البيانات محملة بعد" → أصدر LoadDoctors
        ↓
6️⃣ AdminBloc يستقبل LoadDoctors
        ↓
7️⃣ emit(AdminLoading) ──► شاشة تظهر Spinner
        ↓
8️⃣ await _supabaseService.fetchAll('doctors')
        ↓
9️⃣ استقبال List<Map> من Supabase
        ↓
1️⃣0️⃣ تحويل إلى List<DoctorModel>
        ↓
1️⃣1️⃣ emit(DoctorsLoaded(doctors))
        ↓
1️⃣2️⃣ BlocBuilder يمسك الحالة الجديدة
        ↓
1️⃣3️⃣ يرسم ListView بالأطباء
        ↓
1️⃣4️⃣ المستخدم يرى قائمة الأطباء الفعلية! ✅
```

---

