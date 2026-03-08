# قواعد عمل وكلاء الذكاء الاصطناعي

## المبادئ الأساسية

```
┌─────────────────────────────────────────────────────────┐
│   AI AGENT CORE PRINCIPLES FOR MCS PROJECT             │
├─────────────────────────────────────────────────────────┤
│ 1. اتبع معايير المشروع بدقة                             │
│ 2. فهم الهيكلة الموجودة قبل التعديل                     │
│ 3. الحفاظ على التسلسل الهرمي النظيف                    │
│ 4. توثيق جميع التغييرات                                │
│ 5. اختبر قبل الالتزام                                  │
│ 6. تجنب كسر التغييرات (Breaking Changes)               │
│ 7. الالتزام بمعايير الأمان                              │
└─────────────────────────────────────────────────────────┘
```

---

## قواعس الملفات والفولدرات

### ✅ MUST DO

- **اتبع معايير التسمية**: `snake_case.dart` للملفات
- **منظم حسب الطبقات**: data, domain, presentation
- **ملف واحد لكل فئة**: لا تضع فئتان في ملف واحد
- **استخدم مجلدات منطقية**: features, core, platforms
- **الاستيراد المنظم**: Dart → Flutter → external → relative

### ❌ MUST NOT DO

- ❌ لا تنشئ ملفات عشوائية خارج البنية
- ❌ لا تحط فئات متعددة في ملف واحد
- ❌ لا تستخدم الأسماء العامة والغامضة
- ❌ لا تخالط بين الطبقات (presentation يستخدم data مباشرة)
- ❌ لا تنسى إضافة `@override` للدوال المُعاد تعريفها

---

## قواعس الكود

### 1. Naming Conventions

#### Classes (PascalCase)

```dart
✅ class UserModel
✅ class AuthRepository
✅ class LoginBloc

❌ class user_model
❌ class authRepository
```

#### Variables (camelCase)

```dart
✅ String userName;
✅ int userAge;
✅ bool isActive;

❌ String user_name;
❌ int user_age;
❌ bool is_active;
```

#### Constants (kPascalCase or UPPER_SNAKE_CASE)

```dart
✅ static const int kMaxRetries = 3;
✅ static const String kApiUrl = 'https://api.example.com';
✅ static const Duration kDefaultTimeout = Duration(seconds: 30);

❌ static const int max_retries = 3;
❌ static const int MaxRetries = 3;
```

#### Private (leading underscore)

```dart
✅ void _privateMethod() {}
✅ final String _privateVar;

❌ void privateMethod() {} // if intended to be private
```

---

### 2. معايير المعايير الموصى به (Code Quality)

#### Equatable Usage

```dart
✅ use Equatable for models
class UserModel extends Equatable {
  const UserModel({required this.id, required this.name});
  final String id;
  final String name;
  
  @override
  List<Object?> get props => [id, name];
}

❌ manual operator== implementation
```

#### Null Safety

```dart
✅ required named parameters
class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    this.email,
  });
}

❌ positional parameters without required
class UserModel {
  UserModel(this.id, this.name, [this.email]);
}
```

#### Error Handling with Either

```dart
✅ use Either pattern
Future<Either<Failure, User>> getUser(String id) async {
  try {
    final user = await repository.getUser(id);
    return Right(user);
  } catch (e) {
    return Left(GeneralFailure(message: e.toString()));
  }
}

❌ throw exceptions directly
Future<User> getUser(String id) async {
  return repository.getUser(id);
}
```

---

### 3. BLoC Pattern Rules

#### Event/State Naming

```dart
✅ class GetUserEvent extends UserEvent {}
✅ class UserLoading extends UserState {}
✅ class UserLoaded extends UserState {}

❌ class GetUser extends Event {}
❌ class Loading extends State {}
```

#### Event Handling

```dart
✅ use on<EventType> syntax
class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserInitial()) {
    on<GetUserEvent>(_onGetUser);
    on<UpdateUserEvent>(_onUpdateUser);
  }
  
  Future<void> _onGetUser(
    GetUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());
    // ...
  }
}

❌ mapEventToState (old pattern)
```

#### State Management

```dart
✅ emit state changes only
// In handler
result.fold(
  (failure) => emit(UserError(message: failure.message)),
  (user) => emit(UserLoaded(user: user)),
);

❌ setState or mutable state
```

---

## قواعس الهيكل المعماري

### المسارات المسموحة

```
✅ presentation → domain
✅ presentation → data (through repository interfaces)
✅ data ← domain
✅ core ← features

❌ presentation → core/services directly
❌ domain → data
❌ features → features (cross-feature dependency)
```

### التسلسل الهرمي الصحيح

```
Layer Hierarchy:
1. Presentation (Screens, Widgets, BLoC)
   ↓ depends on
2. Domain (Entities, Use Cases, Repository Interfaces)
   ↓ depends on
3. Data (Models, Repository Implementations, Data Sources)
   ↓ depends on
4. Core (Services, Utils, Constants)
```

---

## قواعس الـ Testing

### Unit Test Naming

```dart
✅ testGetUserReturnsUserWhenSuccessful()
✅ testLoginThrowsExceptionWhenCredentialsAreWrong()
✅ testCalculatePriceAppliesTaxCorrectly()

❌ test1()
❌ testUser()
❌ testSomething()
```

### Mock Objects

```dart
✅ create proper mocks
class MockUserRepository extends Mock implements UserRepository {}
class MockLoginUseCase extends Mock implements LoginUseCase {}

final mockRepository = MockUserRepository();

❌ use real objects in tests
final repository = UserRepositoryImpl(...);
```

### Test Structure

```dart
✅ Arrange-Act-Assert pattern
test('should return user when ID is valid', () async {
  // Arrange
  when(mockRepository.getUserById('123'))
    .thenAnswer((_) async => user);
  
  // Act
  final result = await bloc.getUser('123');
  
  // Assert
  expect(result, equals(user));
  verify(mockRepository.getUserById('123')).called(1);
});
```

---

## قواعس المستودعات (Repositories)

### تطبيق الواجهة

```dart
✅ implement interface completely
class UserRepositoryImpl implements UserRepository {
  @override
  Future<Either<Failure, User>> getUser(String id) async {
    // implementation
  }
  
  @override
  Future<Either<Failure, void>> updateUser(User user) async {
    // implementation
  }
}

❌ partial implementation or missing methods
```

### معالجة الأخطاء

```dart
✅ catch specific exceptions
Future<Either<Failure, User>> getUser(String id) async {
  try {
    final response = await supabaseService.getUser(id);
    return Right(UserModel.fromJson(response));
  } on ServerException catch (e) {
    return Left(ServerFailure(message: e.message));
  } on NetworkException catch (e) {
    return Left(NetworkFailure(message: e.message));
  }
}

❌ catch all exceptions
Future<Either<Failure, User>> getUser(String id) async {
  try {
    return Right(await repository.getUser(id));
  } catch (e) {
    return Left(UnknownFailure());
  }
}
```

---

## قواعس البيانات

### Models

```dart
✅ JSONserialization
class UserModel extends Equatable {
  final String id;
  final String name;
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}

❌ without serialization support
```

### Entities

```dart
✅ domain entities (pure)
class User extends Equatable {
  final String id;
  final String name;
  // business logic only
}

❌ serialization in domain entity
// User should NOT have fromJson/toJson
```

---

## قواعس الخدمات

### Service Methods

```dart
✅ return Result types
Future<Either<Failure, T>> performAction() async {}

❌ throw exceptions
Future<T> performAction() async {
  throw Exception('Error');
}
```

### Dependency Injection

```dart
✅ inject through constructor
class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserUseCase getUserUseCase;
  
  UserBloc({required this.getUserUseCase}) : super(const UserInitial());
}

❌ use ServiceLocator directly in BLoC
```

---

## قواعس الشاشات والـ Widgets

### Screen Structure

```dart
✅ separate BLoC providers
class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserBloc(sl()),
      child: const UserView(),
    );
  }
}

class UserView extends StatefulWidget {}

❌ mixing BLoC setup with UI
```

### Widget Rebuilds

```dart
✅ use buildWhen to optimize
BlocBuilder<UserBloc, UserState>(
  buildWhen: (previous, current) {
    return previous.user != current.user;
  },
  builder: (context, state) => UserWidget(),
);

❌ rebuild entire widget tree
BlocBuilder<UserBloc, UserState>(
  builder: (context, state) => ExpensiveWidget(),
);
```

---

## قواعس المحليات والترجمة

### Localization Keys

```dart
✅ hierarchical naming
'auth.login.title'
'auth.login.error'
'patient.appointments.empty'
'doctor.patients.list'

❌ flat naming
'login_title'
'patient_appointments'
```

### RTL Support

```dart
✅ use textDirection widget
Directionality(
  textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
  child: widget,
);

❌ assume LTR
```

---

## قواعس الأداء

### Avoid

```dart
❌ setState في production
setState(() => _counter++);

❌ عدم استخدام const constructors
Widget build() {
  return Container(); // should be const
}

❌ large widget trees
// فك إلى widgets صغيرة

❌ images بدون caching
Image.network(url);

❌ synchronous operations في main thread
final data = fetchDataSync();
```

### Optimize

```dart
✅ const constructors
const Container()

✅ cached images
CachedNetworkImage(imageUrl: url);

✅ lazy loading
LazyLoadingListView()

✅ استخدام ListView.builder
ListView.builder(itemCount: items.length)
```

---

## قواعس التعليقات والتوثيق

### Documentation Comments

```dart
✅ توثيق واضح
/// الحصول على المستخدم من معرفه
/// 
/// [userId] معرف المستخدم الفريد
/// 
/// Returns: Future يحتوي على User أو Failure
Future<Either<Failure, User>> getUser(String userId) async {}

❌ عدم وجود توثيق
Future<Either<Failure, User>> getUser(String userId) async {}
```

### Comments in Code

```dart
✅ شرح السبب
// تخزين مؤقت للمستخدم لتقليل استدعاءات الـ API
final cachedUsers = <String, User>{};

❌ شرح الواضح
// إضافة مستخدم إلى القائمة
users.add(user);
```

---

## قواعس الأمان

### Never Expose Secrets

```dart
✅ use .env files
static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');

❌ hardcode secrets
static const String supabaseUrl = 'https://...';
static const String apiKey = 'sk_live_123...';
```

### Validate Input

```dart
✅ validate user input
if (email.isEmpty || !isEmailValid(email)) {
  return Left(ValidationFailure());
}

❌ assume valid input
final user = User(email: email);
```

### Secure Storage

```dart
✅ store tokens securely
await secureStorage.write(key: 'token', value: token);

❌ store in SharedPreferences
await prefs.setString('token', token);
```

---

## قواعس الـ Git

### Commit Messages

```bash
✅ conventional commits
feat: add login functionality
fix: resolve authentication error
docs: update readme
test: add login tests

❌ vague messages
fixed stuff
update
changes
```

### Branch Names

```bash
✅ descriptive names
feature/auth-login
bugfix/video-call-crash
chore/update-dependencies

❌ unclear names
fix1
update
new-feature
```

---

## Checklist قبل الـ Commit

### Code Quality

- [ ] الكود يتبع معايير المشروع
- [ ] لا توجد أخطاء من `flutter analyze`
- [ ] تم استخدام `const` constructors
- [ ] الاستيراد منظم بشكل صحيح
- [ ] لا توجد متغيرات غير مستخدمة

### Testing

- [ ] تم كتابة unit tests
- [ ] جميع الاختبارات تمر
- [ ] الاختبارات تغطي الحالات الرئيسية

### Documentation

- [ ] تم توثيق الدوال الجديدة
- [ ] تم تحديث README إن لزم
- [ ] التعليقات واضحة

### Security

- [ ] لا توجد secrets مكشوفة
- [ ] تم التحقق من المدخلات
- [ ] البيانات الحساسة محفوظة بأمان

### Performance

- [ ] لا توجد unused imports
- [ ] تم تحسين الاستعلامات
- [ ] الصور مخزنة مؤقتاً

---

## التعاون مع وكلاء آخرين

### عند التوسعة

```
1. اقرأ المستندات أولاً
2. افهم الهيكل القائم
3. اتبع نفس النمط
4. لا تكسر التغييرات الموجودة
5. أضف tests
6. وثق التغييرات
```

### عند الإصلاح

```
1. فهم السبب الجذري
2. الحد الأدنى من التغييرات
3. اختبر على كل الحالات
4. تأكد من عدم إصلاح شيء وكسر آخر
```

---

## استراتيجية المشاريع الكبيرة

### عند العمل على مشروع معقد

1. **اقرأ المستندات أولاً**
   - project-overview.md
   - system-architecture.md
   - folder-structure.md

2. **افهم الأنماط المستخدمة**
   - Clean Architecture
   - BLoC Pattern
   - Either + Failure Pattern

3. **ابدأ بملف مثال**
   - انسخ هيكل ملف موجود
   - عدّل حسب احتياجك
   - اتبع نفس النمط

4. **اختبر وثق**
   - أضف tests
   - وثق في PRغ
   - شارك التغييرات

