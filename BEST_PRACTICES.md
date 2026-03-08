# Best Practices Guide - MCS Project

## 📚 دليل أفضل الممارسات - مشروع MCS

---

## 🎯 مقدمة (Introduction)

هذا الدليل يحتوي على أفضل الممارسات والمعايير التي يجب اتباعها عند التطوير في مشروع MCS (Medical Clinic System).

---

## 📋 المحتويات (Table of Contents)

1. [Null Safety](#1-null-safety)
2. [نماذج البيانات (Models)](#2-نماذج-البيانات-models)
3. [الشاشات (Screens)](#3-الشاشات-screens)
4. [Bloc Pattern](#4-bloc-pattern)
5. [Supabase Integration](#5-supabase-integration)
6. [UI/UX](#6-uiux)
7. [الأداء (Performance)](#7-الأداء-performance)
8. [الأمان (Security)](#8-الأمان-security)
9. [الاختبار (Testing)](#9-الاختبار-testing)
10. [التوثيق (Documentation)](#10-التوثيق-documentation)

---

## 1. Null Safety

### ✅ أفضل الممارسات

```dart
// ✅ استخدام null-aware operators
String? name;
String displayName => name ?? 'Anonymous';

// ✅ التحقق من null قبل الاستخدام
if (user.name != null && user.name!.isNotEmpty) {
  print(user.name![0].toUpperCase());
}

// ✅ استخدام safe_extensions.dart
Text(user.name?.firstCharSafe ?? 'U')
```

### ❌ تجنب

```dart
// ❌ استخدام ! بدون التحقق
Text(user.name![0].toUpperCase())

// ❌ تجاهل null
Text(user.name.substring(0, 1))

// ❌ استخدام dynamic بدلاً من nullable
dynamic name = user.name;
```

---

## 2. نماذج البيانات (Models)

### ✅ أفضل الممارسات

```dart
// ✅ استخدام Equatable للمقارنة
class AppointmentModel extends Equatable {
  const AppointmentModel({
    required this.id,
    required this.patientId,
    this.notes,
  });

  // ✅ استخدام getters للحسابات المشتقة
  String get timeSlot => 
    '${scheduledAt.hour.toString().padLeft(2, '0')}:${scheduledAt.minute.toString().padLeft(2, '0')}';

  bool get isPast => scheduledAt.isBefore(DateTime.now());

  // ✅ استخدام const للمنشئ
  const AppointmentModel copyWith({...});

  @override
  List<Object?> get props => [id, patientId, notes];
}
```

### ❌ تجنب

```dart
// ❌ بدون Equatable
class AppointmentModel {
  // ...
}

// ❌ حسابات في الشاشات بدلاً من getters
Text('${appointment.scheduledAt.hour}:${appointment.scheduledAt.minute}')

// ❌ استخدام dynamic في fromJson/toJson
Map<String, dynamic> toJson() => {...};
```

---

## 3. الشاشات (Screens)

### ✅ أفضل الممارسات

```dart
// ✅ استخدام const widgets
const SizedBox(height: 16);
const CircularProgressIndicator();
const Icon(Icons.calendar_today);

// ✅ استخدام withValues بدلاً من withOpacity
color: Colors.blue.withValues(alpha: 0.1)

// ✅ معالجة الأخطاء
BlocBuilder<PatientBloc, PatientState>(
  builder: (context, state) {
    if (state is PatientError) {
      return ErrorWidget(state.message);
    }
    // ...
  },
)

// ✅ استخدام AppLocalizations للترجمة
Text(AppLocalizations.of(context).translate('appointments'))
```

### ❌ تجنب

```dart
// ❌ بدون const
SizedBox(height: 16);

// ❌ استخدام withOpacity المهمل
color: Colors.blue.withOpacity(0.1)

// ❌ نصوص ثابتة بدون ترجمة
Text('Appointments')

// ❌ بدون معالجة أخطاء
BlocBuilder<PatientBloc, PatientState>(
  builder: (context, state) {
    return ListView(...);  // قد يفشل إذا حدث خطأ
  },
)
```

---

## 4. Bloc Pattern

### ✅ أفضل الممارسات

```dart
// ✅ استخدام const للـ states البسيطة
class PatientInitial extends PatientState {
  const PatientInitial();
}

class PatientLoading extends PatientState {
  const PatientLoading();
}

// ✅ معالجة الأخطاء
Future<void> _onLoadAppointments(
  LoadAppointments event,
  Emitter<PatientState> emit,
) async {
  emit(const PatientLoading());
  final result = await _patientRepository.getAppointments();
  result.fold(
    (failure) => emit(PatientError(_mapFailureToMessage(failure))),
    (appointments) => emit(AppointmentsLoaded(appointments)),
  );
}

// ✅ استخدام named parameters في Events
class BookAppointment extends PatientEvent {
  const BookAppointment({
    required this.clinicId,
    required this.doctorId,
    required this.appointmentDate,
    this.notes,
  });
}
```

### ❌ تجنب

```dart
// ❌ بدون const
class PatientLoading extends PatientState {}

// ❌ بدون معالجة أخطاء
Future<void> _onLoadAppointments(...) async {
  final appointments = await _patientRepository.getAppointments();
  emit(AppointmentsLoaded(appointments));  // قد يسبب خطأ
}

// ❌ استخدام positional parameters
class BookAppointment extends PatientEvent {
  const BookAppointment(this.clinicId, this.doctorId, this.appointmentDate);
}
```

---

## 5. Supabase Integration

### ✅ أفضل الممارسات

```dart
// ✅ استخدام named parameters
final data = await _supabaseService.fetchAll(
  'appointments',
  filters: {'patient_id': _supabaseService.currentUserId},
);

// ✅ معالجة الأخطاء
Future<Either<Failure, List<AppointmentModel>>> getAppointments() async {
  try {
    final data = await _supabaseService.fetchAll('appointments');
    final appointments = data.map(AppointmentModel.fromJson).toList();
    return Right(appointments);
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}

// ✅ استخدام أنواع محددة
final List<AppointmentModel> appointments = ...
final Map<String, int> stats = ...
```

### ❌ تجنب

```dart
// ❌ استخدام positional parameters
final data = await _supabaseService.fetchAll('appointments', patientId);

// ❌ بدون معالجة أخطاء
Future<List<AppointmentModel>> getAppointments() async {
  final data = await _supabaseService.fetchAll('appointments');
  return data.map(AppointmentModel.fromJson).toList();  // قد يسبب خطأ
}

// ❌ استخدام dynamic
final Map<String, dynamic> stats = ...
final List<dynamic> items = ...
```

---

## 6. UI/UX

### ✅ أفضل الممارسات

```dart
// ✅ استخدام Material Design
Card(
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: Padding(...),
)

// ✅ معالجة loading states
if (state is PatientLoading) {
  return const Center(child: CircularProgressIndicator());
}

// ✅ معالجة empty states
if (state is AppointmentsLoaded && state.appointments.isEmpty) {
  return _buildEmptyState();
}

// ✅ استخدام ألوان متسقة
color: Theme.of(context).colorScheme.primary
```

### ❌ تجنب

```dart
// ❌ بدون Material Design
Container(
  decoration: BoxDecoration(
    border: Border.all(),
  ),
  child: Padding(...),
)

// ❌ بدون معالجة loading
BlocBuilder<PatientBloc, PatientState>(
  builder: (context, state) {
    return ListView(...);  // لا يوجد loading indicator
  },
)

// ❌ ألوان عشوائية
color: Color(0xFF123456)
```

---

## 7. الأداء (Performance)

### ✅ أفضل الممارسات

```dart
// ✅ استخدام const widgets
const SizedBox(height: 16);
const Icon(Icons.calendar_today);

// ✅ استخدام keys بشكل صحيح
ListView.builder(
  key: const PageStorageKey('appointments_list'),
  itemCount: appointments.length,
  itemBuilder: (context, index) {
    return AppointmentCard(
      key: ValueKey(appointments[index].id),
      appointment: appointments[index],
    );
  },
)

// ✅ تحميل البيانات بشكل lazy
FutureBuilder(
  future: _loadData(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      return _buildContent(snapshot.data);
    }
    return const CircularProgressIndicator();
  },
)
```

### ❌ تجنب

```dart
// ❌ بدون const
SizedBox(height: 16);

// ❌ بدون keys
ListView.builder(
  itemCount: appointments.length,
  itemBuilder: (context, index) {
    return AppointmentCard(appointment: appointments[index]);
  },
)

// ❌ تحميل كل البيانات مرة واحدة
final allData = await Future.wait([...]);
```

---

## 8. الأمان (Security)

### ✅ أفضل الممارسات

```dart
// ✅ عدم تخزين أسرار في الكود
// ❌ سيء
final apiKey = 'sk-1234567890abcdef';

// ✅ جيد - استخدام environment variables
final apiKey = dotenv.env['API_KEY'];

// ✅ التحقق من الصلاحيات
if (user.role != UserRole.admin) {
  return AccessDeniedWidget();
}

// ✅ التحقق من المدخلات
if (email == null || !email.contains('@')) {
  return ValidationError('Invalid email');
}

// ✅ استخدام HTTPS
final response = await http.get(Uri.parse('https://api.example.com/data'));
```

### ❌ تجنب

```dart
// ❌ تخزين أسرار في الكود
final apiKey = 'sk-1234567890abcdef';

// ❌ بدون التحقق من الصلاحيات
final data = await _repository.getAllData();

// ❌ بدون التحقق من المدخلات
await _repository.createUser(email: email);

// ❌ استخدام HTTP
final response = await http.get(Uri.parse('http://api.example.com/data'));
```

---

## 9. الاختبار (Testing)

### ✅ أفضل الممارسات

```dart
// ✅ اختبار الوحدات
test('should return appointments when successful', () async {
  // Arrange
  final mockRepository = MockPatientRepository();
  final bloc = PatientBloc(mockRepository);
  
  // Act
  bloc.add(LoadAppointments());
  await Future.delayed(const Duration(milliseconds: 100));
  
  // Assert
  expect(bloc.state, isA<AppointmentsLoaded>());
});

// ✅ اختبار الـ widgets
testWidgets('should show loading indicator when loading', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider(
        create: (_) => PatientBloc(mockRepository),
        child: PatientAppointmentsScreen(),
      ),
    ),
  );
  
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});

// ✅ اختبار الـ integration
test('should load and display appointments', () async {
  // ...
});
```

### ❌ تجنب

```dart
// ❌ بدون اختبارات
void main() {
  runApp(MyApp());
}

// ❌ اختبارات غير كاملة
test('should work', () {
  expect(true, true);
});
```

---

## 10. التوثيق (Documentation)

### ✅ أفضل الممارسات

```dart
// ✅ تعليقات للدوال المعقدة
/// Loads appointments for the current patient.
/// 
/// Returns [Either<Failure, List<AppointmentModel>>] containing:
/// - Right with list of appointments on success
/// - Left with Failure error on failure
/// 
/// Throws [ServerException] if network error occurs
Future<Either<Failure, List<AppointmentModel>>> getAppointments() async {
  // ...
}

// ✅ تعليقات للنماذج
/// Represents a medical appointment in the MCS system.
/// 
/// Contains information about the appointment date, time,
/// doctor, patient, and status.
class AppointmentModel extends Equatable {
  // ...
}

// ✅ تعليقات للـ getters
/// Time slot formatted as "HH:MM".
/// 
/// Example: "14:30" for 2:30 PM
String get timeSlot => ...;
```

### ❌ تجنب

```dart
// ❌ بدون تعليقات
Future<Either<Failure, List<AppointmentModel>>> getAppointments() async {
  // ...
}

// ❌ تعليقات غير مفيدة
/// Function to get appointments
Future<Either<Failure, List<AppointmentModel>>> getAppointments() async {
  // ...
}
```

---

## 🎯 الخلاصة (Summary)

### ✅ DO

- استخدم `safe_extensions.dart` للتعامل الآمن مع البيانات
- استخدم `const` widgets حيثما أمكن
- استخدم `withValues()` بدلاً من `withOpacity()`
- عالج جميع الأخطاء بشكل صحيح
- اكتب اختبارات للوظائف الحرجة
- وثق الكود المعقد
- اتبع اتفاقيات التسمية
- استخدم عمليات type-safe

### ❌ DON'T

- استخدم `dynamic` بدون تحديد النوع
- تجاهل القيم nullable
- استخدم APIs مهملة
- تخطي معالجة الأخطاء
- اترك TODOs غير مكتملة
- استخدم نصوص ثابتة للـ UI
- تجاهل تحذيرات lint
- ارتكب بدون اختبار

---

## 📞 الدعم (Support)

للأسئلة أو الاستفسارات حول هذه الممارسات، اتصل بفريق التطوير.

**آخر تحديث:** 2026-03-08
**الإصدار:** 1.0.0