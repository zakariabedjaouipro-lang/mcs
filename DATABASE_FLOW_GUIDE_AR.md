# دليل تدفق البيانات من قاعدة البيانات
## Database Flow Guide - Complete Architecture

---

## 🔄 تدفق البيانات الكامل

```
┌──────────────────────────────────────────────────────────────┐
│                   قاعدة البيانات Supabase                     │
│              (PostgreSQL + Real-time Features)              │
├──────────────────────────────────────────────────────────────┤
│                  الجداول الرئيسية:                             │
│  • clinics, doctors, patients, appointments                │
│  • subscriptions, payments, registration_requests, etc.    │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
┌──────────────────────────────────────────────────────────────┐
│                   SupabaseService (الطبقة الخدمية)             │
│                                                              │
│  Methods:                                                   │
│  • fetchAll(tableName, filters, orderBy)                  │
│  • fetch(tableName, id)                                   │
│  • insert(tableName, data)                                │
│  • update(tableName, id, data)                            │
│  • delete(tableName, id)                                  │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
┌──────────────────────────────────────────────────────────────┐
│                    AdminBloc (BLoC Layer)                    │
│                                                              │
│  Events:                                                    │
│  • LoadDoctors() ──► _onLoadDoctors()                      │
│  • LoadPatients() ──► _onLoadPatients()                    │
│  • LoadAppointments() ──► _onLoadAppointments()            │
│  • LoadClinics() ──► _onLoadClinics()                      │
│  • LoadPendingApprovals() ──► _onLoadPendingApprovals()    │
│  • LoadPayments() ──► _onLoadPayments()                    │
│                                                              │
│  States:                                                    │
│  • AdminInitial, AdminLoading,AdminError                   │
│  • DoctorsLoaded, PatientsLoaded, AppointmentsLoaded       │
│  • PendingApprovalsLoaded, PaymentsLoaded                  │
│  • DashboardStatsLoaded                                    │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
┌──────────────────────────────────────────────────────────────┐
│            View/Screen (البواجهة - UI Layer)                 │
│                                                              │
│  • SuperAdminDashboardV2                                   │
│  • _buildStatisticsTab() ◄── DashboardStatsLoaded         │
│  • _buildDoctorsTab() ◄── DoctorsLoaded                    │
│  • _buildPatientsTab() ◄── PatientsLoaded                  │
│  • _buildAppointmentsTab() ◄── AppointmentsLoaded          │
│  • _buildApprovalsTab() ◄── PendingApprovalsLoaded         │
│  • _buildPaymentsTab() ◄── PaymentsLoaded                  │
└──────────────────────────────────────────────────────────────┘
```

---

## 📊 مثال عملي: تحميل الأطباء

### الخطوة 1️⃣: إصدار الحدث (Event)

```dart
// في الواجهة (UI) - عند فتح التطبيق
class SuperAdminDashboardV2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminBloc(sl<SupabaseService>())
        ..add(const LoadDoctors()), // ◄── إصدار الحدث
      child: _SuperAdminDashboardView(),
    );
  }
}
```

### الخطوة 2️⃣: معالجة الحدث في BLoC

```dart
// في AdminBloc - معالج الحدث
Future<void> _onLoadDoctors(
  LoadDoctors event,
  Emitter<AdminState> emit,
) async {
  emit(const AdminLoading()); // ◄── إظهار جار التحميل
  
  try {
    // ◄── جلب البيانات من Supabase
    final data = await _supabaseService.fetchAll(
      'doctors', // ◄── اسم الجدول
      orderBy: 'created_at', // ◄── الترتيب
      ascending: false,
    );

    // ◄── تحويل البيانات إلى نماذج (Models)
    final doctors = data.map(DoctorModel.fromJson).toList();

    // ◄── إصدار حالة النجاح
    emit(DoctorsLoaded(doctors));
  } catch (e) {
    // ◄── إصدار حالة الخطأ
    emit(AdminError('فشل تحميل الأطباء: $e'));
  }
}
```

### الخطوة 3️⃣: عرض البيانات في الواجهة

```dart
// في الواجهة - استقبال الحالة (State)
Widget _buildDoctorsTab(
  BuildContext context,
  AdminState state,
  bool isArabic,
) {
  // ◄── التحقق من حالة البيانات
  if (state is DoctorsLoaded) {
    // ◄── عرض لائمة الأطباء
    return ListView.builder(
      itemCount: state.doctors.length,
      itemBuilder: (context, index) {
        final doctor = state.doctors[index];
        return Card(
          child: ListTile(
            title: Text(doctor.fullName ?? 'Unknown'),
            subtitle: Text(doctor.licenseNumber ?? 'Unknown'),
          ),
        );
      },
    );
  }
  
  // ◄── عرض رسالة جار التحميل
  if (state is AdminLoading) {
    return const Center(child: CircularProgressIndicator());
  }
  
  // ◄── عرض رسالة الخطأ
  if (state is AdminError) {
    return Center(child: Text(state.message));
  }

  return const SizedBox.shrink();
}
```

---

## 📱 تدفق كامل للمواعيد (Appointments)

```
┌─────────────────────────────────────────────────────────────┐
│ 1️⃣ الابتداء                                                  │
│ ────────────                                                │
│ المستخدم يفتح قسم "المواعيد"                                │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│ 2️⃣ إصدار الحدث                                              │
│ ────────────────                                            │
│ context.read<AdminBloc>().add(const LoadAppointments())    │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│ 3️⃣ معالجة في BLoC                                           │
│ ───────────────                                             │
│ _onLoadAppointments() {                                   │
│   • emit(AdminLoading) ──► تحديث الواجهة: جار التحميل      │
│   • fetchAll('appointments') من Supabase                  │
│   • emit(AppointmentsLoaded(list)) ──► تحديث الواجهة    │
│ }                                                           │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│ 4️⃣ عرض البيانات في الواجهة                                 │
│ ───────────────────────                                     │
│ if (state is AppointmentsLoaded) {                        │
│   - عرض ListView                                          │
│   - لكل موعد: عرض البيانات                                 │
│ }                                                           │
└─────────────────────────────────────────────────────────────┘
```

---

## 🗂️ هيكل الملفات والطبقات

### 1️⃣ طبقة الخدمات (Services Layer)

```
📁 lib/core/services/
├── supabase_service.dart (الخدمة الرئيسية)
│   ├── fetchAll(table, filters, orderBy)
│   ├── fetch(table, id)
│   ├── insert(table, data)
│   ├── update(table, id, data)
│   └── delete(table, id)
└── role_based_authentication_service.dart
```

### 2️⃣ طبقة النماذج (Models Layer)

```
📁 lib/core/models/
├── doctor_model.dart
│   • DoctorModel.fromJson(json) ◄── تحويل JSON إلى Dart
│   • toJson() ◄── تحويل Dart إلى JSON
├── patient_model.dart
├── appointment_model.dart
├── clinic_model.dart
├── subscription_model.dart
└── payment_model.dart
```

### 3️⃣ طبقة BLoC

```
📁 lib/features/admin/presentation/bloc/
├── admin_event.dart
│   • LoadDoctors
│   • LoadPatients
│   • LoadAppointments
│   • LoadClinics
│   • LoadPendingApprovals
│   • LoadPayments
│   • LoadDashboardStats
├── admin_state.dart
│   • AdminInitial
│   • AdminLoading
│   • AdminError
│   • DoctorsLoaded
│   • PatientsLoaded
│   • AppointmentsLoaded
│   • PendingApprovalsLoaded
│   • DashboardStatsLoaded
└── admin_bloc.dart
    • _onLoadDoctors()
    • _onLoadPatients()
    • _onLoadAppointments()
    • _onLoadClinics()
    • _onLoadPendingApprovals()
    • _onLoadDashboardStats()
```

### 4️⃣ طبقة الواجهات (View Layer)

```
📁 lib/features/admin/presentation/screens/
└── super_admin_dashboard_v2.dart
    ├── _buildDoctorsTab()
    ├── _buildPatientsTab()
    ├── _buildAppointmentsTab()
    ├── _buildApprovalsTab()
    ├── _buildPaymentsTab()
    └── _buildStatisticsTab()
```

---

## 🔍 اتصال البيانات خطوة بخطوة

### مثال: تحميل المرضى

#### 1. الحدث (Event) - admin_event.dart
```dart
class LoadPatients extends AdminEvent {
  const LoadPatients();

  @override
  List<Object> get props => [];
}
```

#### 2. المعالج - admin_bloc.dart
```dart
Future<void> _onLoadPatients(
  LoadPatients event,
  Emitter<AdminState> emit,
) async {
  emit(const AdminLoading()); // ⏳ جاري التحميل

  try {
    // جلب من Supabase
    final data = await _supabaseService.fetchAll(
      'patients', // اسم الجدول
      orderBy: 'created_at',
      ascending: false,
    );

    // تحويل إلى نماذج
    final patients = data.map(PatientModel.fromJson).toList();

    // إصدار حالة النجاح
    emit(PatientsLoaded(patients)); // ✅ تم التحميل
  } catch (e) {
    // إصدار حالة الخطأ
    emit(AdminError('فشل تحميل المرضى: $e')); // ❌ خطأ
  }
}
```

#### 3. الحالة (State) - admin_state.dart
```dart
class PatientsLoaded extends AdminState {
  final List<PatientModel> patients;

  const PatientsLoaded(this.patients);

  @override
  List<Object> get props => [patients];
}
```

#### 4. الواجهة (View) - super_admin_dashboard_v2.dart
```dart
Widget _buildPatientsTab(BoxContext context, AdminState state, bool isArabic) {
  // التحقق من الحالة
  if (state is PatientsLoaded) {
    return ListView.builder(
      itemCount: state.patients.length,
      itemBuilder: (context, index) {
        final patient = state.patients[index];
        
        // عرض البيانات
        return Card(
          child: ListTile(
            title: Text('Patient ID: ${patient.id}'),
            subtitle: Text('Gender: ${patient.gender}'),
          ),
        );
      },
    );
  }

  // حالات أخرى
  if (state is AdminLoading) {
    return const Center(child: CircularProgressIndicator());
  }

  if (state is AdminError) {
    return Center(child: Text(state.message));
  }

  return const SizedBox.shrink();
}
```

---

## 📊 تدفق الإحصائيات (Dashboard Stats)

```
┌────────────────────────────────────────────────────────┐
│ 1️⃣ جلب البيانات من 7 جداول مختلفة                     │
├────────────────────────────────────────────────────────┤
│ • clinics: العيادات                                   │
│ • users: المستخدمون                                   │
│ • doctors: الأطباء                                    │
│ • patients: المرضى                                    │
│ • appointments: المواعيد                              │
│ • payments: المدفوعات                                │
│ • registration_requests: طلبات الموافقة                │
└────────────────────┬─────────────────────────────────┘
                     │
                     ▼
┌────────────────────────────────────────────────────────┐
│ 2️⃣ حساب العدادات                                       │
├────────────────────────────────────────────────────────┤
│ totalClinics = data.length                            │
│ totalUsers = data.length                              │
│ totalDoctors = data.length                            │
│ totalPatients = data.length                           │
│ activeAppointments = data.where(...).length           │
│ totalRevenue = data.fold(...)                         │
│ pendingApprovals = data.where(...).length             │
└────────────────────┬─────────────────────────────────┘
                     │
                     ▼
┌────────────────────────────────────────────────────────┐
│ 3️⃣ إنشاء state مع جميع الإحصائيات                      │
├────────────────────────────────────────────────────────┤
│ emit(DashboardStatsLoaded(                            │
│   totalClinics: 24,                                   │
│   totalDoctors: 156,                                  │
│   totalPatients: 2341,                                │
│   // ... المزيد من الإحصائيات                         │
│ ))                                                    │
└────────────────────┬─────────────────────────────────┘
                     │
                     ▼
┌────────────────────────────────────────────────────────┐
│ 4️⃣ عرض في الواجهة                                      │
├────────────────────────────────────────────────────────┤
│ StatCard(value: '24', label: 'Clinics')              │
│ StatCard(value: '156', label: 'Doctors')             │
│ StatCard(value: '2341', label: 'Patients')           │
│ // ... المزيد من البطاقات                            │
└────────────────────────────────────────────────────────┘
```

---

## 🔐 الترتيب والتصفية

### مثال: تحميل المواعيد اليومية

```dart
Future<void> _onLoadAppointments(
  LoadAppointments event,
  Emitter<AdminState> emit,
) async {
  emit(const AdminLoading());

  try {
    // جلب مع شروط تصفية
    final today = DateTime.now();
    final tomorrow = today.add(Duration(days: 1));

    final data = await _supabaseService.fetchAll(
      'appointments',
      // ◄── تصفية: فقط المواعيد اليومية
      filters: {
        'appointment_date': {
          'gte': today.toIso8601String(),
          'lt': tomorrow.toIso8601String(),
        }
      },
      orderBy: 'appointment_time', // ◄── الترتيب حسب الوقت
      ascending: true, // ◄── من الأقدم إلى الأحدث
    );

    final appointments = data.map(AppointmentModel.fromJson).toList();
    emit(AppointmentsLoaded(appointments));
  } catch (e) {
    emit(AdminError('خطأ: $e'));
  }
}
```

---

## ⚡ التحديثات الفورية (Real-time)

### استماع للتغييرات في الجداول

```dart
// استخدام Supabase Realtime
SupabaseConfig.client
    .from('appointments')
    .on(RealtimeListenTypes.all, (payload) {
  // عند حدوث أي تغيير في الجدول
  // أعد تحميل البيانات تلقائياً
  add(const LoadAppointments());
})
.subscribe();
```

---

## 🎯 ملخص التدفق

```
المستخدم ──► حدث Event ──► BLoC معالج ──► Supabase DB
                                    ▲
                                    │
                        جلب البيانات ◄─┘
                                    │
                           تحويل إلى Models
                                    │
                           إصدار State جديد
                                    │
                                    ▼
                          الواجهة تستقبل State
                                    │
                           BlocBuilder اختبار الحالة
                                    │
                                    ▼
                           عرض البيانات للمستخدم
```

---

## 🛠️ العمليات الأساسية

### ✅ القراءة (Read)
```dart
// جلب كل الأطباء
await _supabaseService.fetchAll('doctors');

// جلب طبيب واحد
await _supabaseService.fetch('doctors', doctorId);

// جلب مع تصفية
await _supabaseService.fetchAll(
  'doctors',
  filters: {'specialty_id': specialtyId}
);
```

### ✏️ الإنشاء (Create)
```dart
await _supabaseService.insert('doctors', {
  'user_id': userId,
  'clinic_id': clinicId,
  'full_name': 'محمد أحمد',
  'created_at': DateTime.now().toIso8601String(),
});
```

### 🔄 التحديث (Update)
```dart
await _supabaseService.update('doctors', doctorId, {
  'full_name': 'محمد محمود',
  'updated_at': DateTime.now().toIso8601String(),
});
```

### ❌ الحذف (Delete)
```dart
await _supabaseService.delete('doctors', doctorId);
```

---

## 📋 جداول قاعدة البيانات الرئيسية

| الجدول | الوصف | الأعمدة الرئيسية |
|--------|-------|-----------------|
| **users** | المستخدمون الأساسيون | id, email, phone, role |
| **clinics** | العيادات الطبية | id, name, address, phone |
| **doctors** | الأطباء | id, user_id, clinic_id, specialty_id |
| **patients** | المرضى | id, user_id, date_of_birth, gender |
| **appointments** | المواعيد | id, doctor_id, patient_id, appointment_date |
| **payments** | المدفوعات | id, appointment_id, amount, status |
| **subscriptions** | الاشتراكات | id, clinic_id, type, status |
| **registration_requests** | طلبات الموافقة | id, user_id, role_id, status |

---

## 🚀 الأداء والتحسينات

### 1. التخزين المؤقت (Caching)
```dart
// حفظ البيانات محلياً
List<DoctorModel> _cachedDoctors = [];

// استخدام الكاش
if (_cachedDoctors.isNotEmpty) {
  emit(DoctorsLoaded(_cachedDoctors));
} else {
  // جلب من Supabase
}
```

### 2. التصفية المبكرة
```dart
// صفّ البيانات قبل الإرسال
final activeDoctors = data
    .where((doc) => doc.isAvailable)
    .toList();
```

### 3. الترتيب الذكي
```dart
// رتب حسب المعايير
final sorted = doctors
    .sorted((a, b) => b.experienceYears.compareTo(a.experienceYears))
    .toList();
```

---

