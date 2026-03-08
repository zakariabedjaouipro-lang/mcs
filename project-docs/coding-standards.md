# معايير كتابة الكود

## قواعد التسمية (Naming Conventions)

### قواعس الملفات

```dart
// ✅ CORRECT: snake_case
user_model.dart
auth_repository.dart
login_screen.dart
get_user_usecase.dart

// ❌ WRONG: PascalCase
UserModel.dart
AuthRepository.dart

// ❌ WRONG: camelCase
userModel.dart
authRepository.dart
```

### قواعد الفئات والواجهات

```dart
// ✅ CORRECT: PascalCase
class UserModel {}
class AuthRepository {}
abstract class UserRepository {}
mixin UserMixin {}

// ❌ WRONG
class user_model {}
class authRepository {}
```

### قواعد المتغيرات والدوال

```dart
// ✅ CORRECT: camelCase
String userName;
int userAge;
Future<void> fetchUserData() async {}
void _privateMethod() {}
const String apiEndpoint = 'https://api.example.com';

// ❌ WRONG
String user_name;
int user_age;
void FetchUserData() {}
const String API_ENDPOINT = 'https://api.example.com';
```

### قواعد الثوابت

```dart
// ✅ CORRECT
const int kMaxRetries = 3;
const String kDefaultApiUrl = 'https://api.example.com';
const Duration kDefaultTimeout = Duration(seconds: 30);

// Alternative (also acceptable)
static const int MAX_RETRIES = 3;

// ❌ WRONG
const int max_retries = 3;
const int MaxRetries = 3;
```

### قواعد العديات (Enums)

```dart
// ✅ CORRECT
enum UserRole { admin, doctor, patient, employee }
enum AppStatus { loading, success, failure }

// ❌ WRONG
enum user_role { ADMIN, DOCTOR, PATIENT }
enum AppStatus { LOADING, SUCCESS, FAILURE }
```

---

## تنظيم الاستيراد (Import Organization)

### ترتيب الاستيراد الصحيح

```dart
// 1. Dart imports
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

// 2. Flutter imports
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 3. Package imports (من pub.dev)
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// 4. Relative imports (ملفات محلية)
import '../models/user_model.dart';
import '../repositories/user_repository.dart';
import '../services/auth_service.dart';
```

---

## تنسيق الكود (Code Formatting)

### طول السطر

```dart
// ✅ كود مقروء - سطور قصيرة
class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  final String id;
  final String name;
  final String email;

  @override
  List<Object?> get props => [id, name, email];
}

// ❌ سطور طويلة جداً
class UserModel extends Equatable {const UserModel({required this.id, required this.name, required this.email});final String id;final String name;final String email;@override List<Object?>get props=>[id,name,email];}
```

### المسافات والأقواس

```dart
// ✅ تنسيق صحيح
if (condition) {
  doSomething();
} else {
  doSomethingElse();
}

// المسافات حول المعاملات
int result = a + b;
bool isValid = x > 5 && y < 10;

// ❌ تنسيق خاطئ
if(condition){doSomething();}else{doSomethingElse();}

int result = a+b;
bool isValid = x>5&&y<10;
```

---

## تنظيم الفئة (Class Organization)

### ترتيب أعضاء الفئة

```dart
class UserModel extends Equatable {
  // 1. Constants
  static const String tableName = 'users';
  
  // 2. Static fields
  static final logger = Logger();
  
  // 3. Instance fields
  final String id;
  final String name;
  final String email;
  
  // 4. Constructor(s)
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
  });
  
  // 5. Factory constructors
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }
  
  // 6. Getters
  String get displayName => '$name ($email)';
  
  // 7. Methods
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
  
  // 8. Override methods
  @override
  List<Object?> get props => [id, name, email];
}
```

---

## التوثيق والتعليقات

### تعليقات التوثيق (Documentation Comments)

```dart
/// توثيق الفئة - استخدم ثلاث شرطات
/// 
/// هذه الفئة تمثل نموذج المستخدم مع البيانات الأساسية.
/// يمكن تحويله من/إلى JSON.
class UserModel {
  /// معرف فريد للمستخدم
  final String id;
  
  /// اسم المستخدم الكامل
  final String name;
  
  /// بريد المستخدم الإلكتروني
  final String email;
  
  /// منشئ الفئة
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
  });
  
  /// تحويل من JSON إلى كائن
  /// 
  /// يتوقع JSON يحتوي على:
  /// - id: معرف فريد
  /// - name: الاسم الكامل
  /// - email: البريد الإلكتروني
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }
}
```

### التعليقات المنتظمة

```dart
// استخدم تعليق واحد للشرح السريع
int count = 0; // عداد الأصوات

/// استخدم ثلاث شرطات للتوثيق الرسمي المفصل
void complexMethod() {}

// ❌ تجنب التعليقات الغير ضرورية
int x = 5; // تعيين 5 إلى x
```

---

## معالجة الأخطاء والاستثناءات

### نمط Either + Failure

```dart
// ✅ استخدم Either للنتائج
Future<Either<Failure, UserModel>> getUser(String id) async {
  try {
    final user = await repository.getUserById(id);
    return Right(user);
  } on ServerException catch (e) {
    return Left(ServerFailure(message: e.message));
  } on NetworkException catch (e) {
    return Left(NetworkFailure(message: e.message));
  }
}

// ❌ تجنب رمي الاستثناءات مباشرة
Future<UserModel> getUser(String id) async {
  final user = await repository.getUserById(id);
  return user;
}
```

### معالجة الأخطاء في BLoC

```dart
on<GetUserEvent>((event, emit) async {
  emit(UserLoading());
  
  final result = await getUserUseCase(event.userId);
  
  result.fold(
    (failure) {
      // Left = Failure
      emit(UserError(message: failure.message));
    },
    (user) {
      // Right = Success
      emit(UserLoaded(user: user));
    },
  );
});
```

---

## نمط البناء (Design Patterns)

### نمط Equatable

```dart
// ✅ استخدم Equatable للمقارنة
class UserModel extends Equatable {
  final String id;
  final String name;

  const UserModel({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

// ❌ تجنب المقارنة اليدوية
@override
bool operator ==(Object other) =>
    identical(this, other) ||
    other is UserModel &&
        runtimeType == other.runtimeType &&
        id == other.id &&
        name == other.name;
```

### نمط CopyWith

```dart
// ✅ وفر طريقة copyWith للتعديل
class UserModel {
  final String id;
  final String name;
  final String email;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}

// الاستخدام
final updatedUser = user.copyWith(name: 'New Name');
```

---

## نمط BLoC

### هيكل BLoC الصحيح

```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
  }) : super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await loginUseCase(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await logoutUseCase();
    emit(const AuthInitial());
  }
}
```

---

## حجم الملف والدوال

### حجم الملف

```
- ✅ المثالي: 200-400 سطر
- ✅ المقبول: حتى 600 سطر
- ❌ طويل جداً: أكثر من 1000 سطر
```

### حجم الدالة

```dart
// ✅ دالة مناسبة الحجم
void _handleLogin(String email, String password) {
  if (email.isEmpty) return;
  
  context.read<AuthBloc>().add(
    AuthLoginRequested(email: email, password: password),
  );
}

// ❌ دالة ضخمة جداً
void handleEverything(/* 20+ parameters */) {
  // 500 سطر من الكود...
}
```

---

## تجنب المضادات (Anti-Patterns)

### تجنب Global Mutables

```dart
// ❌ تجنب المتغيرات العامة المتغيرة
var globalUser; // سيء!

// ✅ استخدم BLoC بدلاً منه
class AuthBloc extends Bloc<AuthEvent, AuthState> {}
```

### تجنب Deep Nesting

```dart
// ❌ تداخل عميق
if (condition1) {
  if (condition2) {
    if (condition3) {
      doSomething();
    }
  }
}

// ✅ تقليل التداخل
if (!condition1 || !condition2 || !condition3) return;
doSomething();
```

### تجنب Magic Numbers

```dart
// ❌ أرقام سحرية
if (items.length > 10) {}
Duration timeout = Duration(milliseconds: 5000);

// ✅ استخدم ثوابت
static const int kMaxItemsPerPage = 10;
static const Duration kDefaultTimeout = Duration(seconds: 5);

if (items.length > kMaxItemsPerPage) {}
Duration timeout = kDefaultTimeout;
```

---

## الأداء والتحسينات

### تجنب Rebuilds غير الضرورية

```dart
// ❌ سيُعاد بناء الكل في كل مرة
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyCubit, MyState>(
      builder: (context, state) {
        return Column(
          children: [
            _buildExpensiveWidget(), // يُعاد بناؤه دائماً
            _buildAnotherWidget(),
          ],
        );
      },
    );
  }
}

// ✅ استخدم buildWhen للتحكم
BlocBuilder<MyCubit, MyState>(
  buildWhen: (previous, current) {
    return previous.user != current.user;
  },
  builder: (context, state) {
    return UserWidget(user: state.user);
  },
);
```

### تجنب Widget Trees الكبيرة

```dart
// ❌ شجرة ضخمة في ملف واحد
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 500 سطر من الكود...
    );
  }
}

// ✅ فك الأجزاء إلى widgets منفصلة
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFAB(),
    );
  }
  
  Widget _buildAppBar() => AppBar(/* ... */);
  Widget _buildBody() => CustomBody();
  Widget _buildFAB() => FloatingActionButton(/* ... */);
}
```

---

## الاختبار (Testing)

### قواعس الاختبار

```dart
// ✅ اختبار واضح ومنظم
void main() {
  group('LoginBloc', () {
    late LoginBloc loginBloc;
    late MockLoginUseCase mockLoginUseCase;

    setUp(() {
      mockLoginUseCase = MockLoginUseCase();
      loginBloc = LoginBloc(loginUseCase: mockLoginUseCase);
    });

    tearDown(() => loginBloc.close());

    test('emits [Loading, Success] when login succeeds', () async {
      when(mockLoginUseCase.call(
        email: 'test@test.com',
        password: 'password',
      )).thenAnswer((_) async => Right(user));

      expect(
        loginBloc.stream,
        emitsInOrder([
          isA<AuthLoading>(),
          isA<AuthSuccess>(),
        ]),
      );

      loginBloc.add(LoginRequested(
        email: 'test@test.com',
        password: 'password',
      ));
    });
  });
}
```

---

## قائمة التحقق قبل الـ Commit

- [ ] الكود يتبع معايير التسمية
- [ ] تم تنسيق الكود بشكل صحيح
- [ ] لا توجد تعليقات معطوبة
- [ ] الاستيراد منظم بشكل صحيح
- [ ] لا توجد متغيرات غير مستخدمة
- [ ] تم اختبار الكود
- [ ] الأداء مقبول
- [ ] لا توجد أخطاء dart analyze

