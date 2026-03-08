# 🎯 أفضل الممارسات - مشروع MCS
## Best Practices Guide - MCS (Medical Clinic System)

---

## 📌 **مقدمة / Introduction**

هذا الدليل يحتوي على أفضل الممارسات المتوافقة مع مشروع MCS المبني على Flutter و Supabase.

---

## 🛡️ **1. Null Safety و Type Safety**

### ✅ الطريقة الصحيحة:

```dart
// 1. استخدام Null Coalescing
final name = user?.fullName ?? 'Unknown User';

// 2. استخدام Safe Extension Methods
final firstName = user?.fullName?.trimSafe ?? '';

// 3. Type-safe generic collections
final List<AppointmentModel> appointments = [];
final Map<String, dynamic> data = <String, dynamic>{};

// 4. الفحص قبل الوصول
if (user != null && user.email.isNotEmpty) {
  sendToEmail(user.email);
}

// 5. استخدام Pattern Matching (Dart 3.0+)
if (state case AppointmentsLoaded(appointments: [var first, ...rest])) {
  // Handle non-empty list
}
```

### ❌ طرق خاطئة:

```dart
// ❌ Unchecked nullable access
final name = user.fullName;  // قد يكون null

// ❌ Unsafe cast
final appointments = state.appointments as List;

// ❌ String concatenation dyanmic
'$value'.toString();

// ❌ Late initialization خطر
late String name;
```

---

## 🏗️ **2. هيكلة النماذج / Model Structure**

### ✅ نموذج كامل جيد:

```dart
class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.email,
    this.fullName,
    this.phone,
    this.createdAt,
  });

  // ── Factory Methods
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      phone: json['phone'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  // ── Fields
  final String id;
  final String email;
  final String? fullName;
  final String? phone;
  final DateTime? createdAt;

  // ── Getters (Computed Properties)
  String get displayName => fullName ?? email;
  bool get isActive => createdAt != null;

  // ── Methods
  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'full_name': fullName,
    'phone': phone,
    'created_at': createdAt?.toIso8601String(),
  };

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phone,
    DateTime? createdAt,
  }) => UserModel(
    id: id ?? this.id,
    email: email ?? this.email,
    fullName: fullName ?? this.fullName,
    phone: phone ?? this.phone,
    createdAt: createdAt ?? this.createdAt,
  );

  // ── Equatable
  @override
  List<Object?> get props => [id, email, fullName, phone, createdAt];
}
```

---

## 🔧 **3. Extensions و Utilities**

### ✅ Custom Extensions:

```dart
extension SafeString on String? {
  // الحصول على الحرف الأول بأمان
  String get firstCharSafe {
    if (this == null || this!.isEmpty) return '';
    return this![0].toUpperCase();
  }

  // القيمة الافتراضية
  String orDefault(String defaultValue) {
    return isNotNullOrEmpty ? this! : defaultValue;
  }

  // التحقق من أنها ليست فارغة
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  // التقليم الآمن
  String get trimSafe => this?.trim() ?? '';
}

// الاستخدام:
final name = user?.fullName?.trimSafe ?? 'User';
final initial = user?.fullName?.firstCharSafe ?? 'U';
```

### ✅ DateTime Extensions:

```dart
extension SafeDateTime on DateTime? {
  bool get isPast => this != null && this!.isBefore(DateTime.now());
  bool get isFuture => this != null && this!.isAfter(DateTime.now());
  
  bool get isToday {
    if (this == null) return false;
    final now = DateTime.now();
    return this!.year == now.year && 
           this!.month == now.month && 
           this!.day == now.day;
  }

  String get formatDMY {
    if (this == null) return 'N/A';
    return '${this!.day}/${this!.month}/${this!.year}';
  }
}

// الاستخدام:
if (appointment.scheduledAt?.isPast == true) {
  print('This appointment is in the past');
}
```

---

## 📱 **4. UI Patterns**

### ✅ BLoC Pattern الصحيح:

```dart
// Event
class LoadAppointments extends AppointmentEvent {
  const LoadAppointments({this.patientId});
  final String? patientId;

  @override
  List<Object?> get props => [patientId];
}

// State
class AppointmentsLoaded extends AppointmentState {
  const AppointmentsLoaded(this.appointments);
  final List<AppointmentModel> appointments;

  @override
  List<Object> get props => [appointments];
}

// BLoC Handler
on<LoadAppointments>((event, emit) async {
  emit(const AppointmentLoading());
  final result = await repository.getAppointments(
    patientId: event.patientId,
  );
  
  result.fold(
    (failure) => emit(AppointmentError(_mapFailureToMsg(failure))),
    (appointments) => emit(AppointmentsLoaded(appointments)),
  );
});
```

### ✅ Widget التوطين الآمن:

```dart
// ❌ غير آمن
Text(AppLocalizations.of(context).translate('key'))

// ✅ آمن
@override
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  
  return Column(
    children: [
      Text(l10n?.translate('title') ?? 'Default Title'),
      Text(l10n?.translate('subtitle') ?? 'Default Subtitle'),
    ],
  );
}
```

### ✅ Safe Color Usage:

```dart
// ❌ مهمل (deprecated)
Colors.blue.withOpacity(0.5)

// ✅ حديث و صحيح
Colors.blue.withValues(alpha: 0.5)

// أو
Color.fromARGB(128, 0, 0, 255)  // 128/255 ≈ 0.5
```

---

## 💾 **5. Repository Pattern**

### ✅ Pattern الصحيح:

```dart
class UserRepositoryImpl implements UserRepository {
  final SupabaseService _supabase;

  @override
  Future<Either<Failure, UserModel>> getUserById(String id) async {
    try {
      final data = await _supabase.fetchById('users', id);
      final user = UserModel.fromJson(data);
      return Right(user);
    } on SocketException {
      return Left(NetworkFailure());
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateUser(UserModel user) async {
    try {
      final updated = await _supabase.update(
        'users',
        user.id,
        user.toJson(),
      );
      return Right(UserModel.fromJson(updated));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
```

---

## 🎨 **6. State Management**

### ✅ Immutability و Const Constructors:

```dart
// ✅ صحيح
abstract class UserEvent extends Equatable {
  const UserEvent();
}

class LoadUser extends UserEvent {
  const LoadUser(this.userId);
  final String userId;

  @override
  List<Object> get props => [userId];
}

// ❌ خطأ - mutable event
class LoadUser extends UserEvent {
  LoadUser(this.userId);  // غير const
  String userId;  // غير final

  @override
  List<Object> get props => [userId];
}
```

### ✅ State Classes:

```dart
// ✅ صحيح
abstract class UserState extends Equatable {
  const UserState();
}

const class UserInitial extends UserState {
  @override
  List<Object?> get props => [];
}

const class UserLoading extends UserState {
  @override
  List<Object?> get props => [];
}
```

---

## 🧪 **7. Testing**

### ✅ اختبار BLoC:

```dart
void main() {
  late MockUserRepository mockRepository;
  late UserBloc userBloc;

  setUp(() {
    mockRepository = MockUserRepository();
    userBloc = UserBloc(mockRepository);
  });

  group('UserBloc', () {
    test('emit [UserLoading, UserLoaded] when successful', () async {
      // Arrange
      const userId = 'user-123';
      final user = UserModel(
        id: userId,
        email: 'test@example.com',
      );
      when(() => mockRepository.getUserById(userId))
          .thenAnswer((_) async => Right(user));

      // Act
      userBloc.add(const LoadUser(userId));

      // Assert
      await expectLater(
        userBloc.stream,
        emitsInOrder([
          const UserLoading(),
          UserLoaded(user),
        ]),
      );
    });
  });
}
```

---

## 📁 **8. مثال مشروع منظم / Project Structure**

```
lib/
├── main.dart
├── core/
│   ├── config/
│   ├── constants/
│   ├── enums/
│   ├── errors/
│   ├── extensions/
│   │   └── safe_extensions.dart
│   ├── localization/
│   ├── models/
│   │   ├── appointment_model.dart
│   │   ├── doctor_model.dart
│   │   ├── patient_model.dart
│   │   └── user_model.dart
│   ├── services/
│   │   └── supabase_service.dart
│   ├── theme/
│   ├── usecases/
│   └── widgets/
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── patient/
│   │   ├── data/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   └── repositories/
│   │   └── presentation/
│   │       ├── bloc/
│   │       └── screens/
│   └── doctor/
│       └── ...
│
└── main_*.dart  // Platform-specific entry points
```

---

## 🔒 **9. أمان البيانات / Security**

### ✅ آمن:

```dart
// 1. Validate input
String validateEmail(String email) {
  if (email.isEmpty) throw ArgumentError('Email required');
  if (!email.contains('@')) throw ArgumentError('Invalid email');
  return email.trim();
}

// 2. Use secure storage
final secureStorage = FlutterSecureStorage();
await secureStorage.write(key: 'token', value: token);

// 3. اختبر البيانات
if (user.email?.contains('@') != true) {
  return const Left(ValidationFailure());
}
```

---

## ⚡ **10. Performance Tips**

### ✅ سريع وفعّال:

```dart
// 1. استخدم const constructors
const AppBar(title: Text('Title'))

// 2. استخدم ListView.builder للقوائس الطويلة
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)

// 3. استخدم BlocBuilder فقط للأجزاء التي تحتاج update
BlocBuilder<UserBloc, UserState>(
  buildWhen: (previous, current) {
    return current is UserLoaded;
  },
  builder: (context, state) => ...,
)

// 4. تجنب rebuild غير الضروري
@immutable
class MyModel {
  final int value;
  const MyModel(this.value);
}
```

---

## 📚 **مراجع إضافية / Additional Resources**

- [Flutter Best Practices](https://flutter.dev/docs/testing/best-practices)
- [Dart null safety](https://dart.dev/null-safety)
- [BLoC Pattern](https://bloclibrary.dev)
- [Clean Architecture](https://resocoder.com/flutter-clean-architecture)

---

**آخر تحديث:** 8 مارس 2026  
**الحالة:** ✅ جاهز الاستخدام
