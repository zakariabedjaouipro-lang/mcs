# Demo Accounts (حسابات تجريبية)

## نظرة عامة

تم إنشاء نظام شامل لإدارة حسابات تجريبية (Demo Accounts) في تطبيق MCS. هذا يسهل الاختبار والتطوير بدون الحاجة لإنشاء حسابات يدويًا.

## حسابات تجريبية متاحة

| الدور | البريد الإلكتروني | كلمة المرور | الملاحظات |
|------|-------------------|-----------|---------|
| **Super Admin** | `superadmin@demo.com` | `Demo@123456` | المسؤول الأعلى للنظام |
| **Admin** | `admin@demo.com` | `Demo@123456` | مسؤول العيادة |
| **Doctor** | `doctor@demo.com` | `Demo@123456` | طبيب تجريبي (عام) |
| **Patient** | `patient@demo.com` | `Demo@123456` | مريض تجريبي |
| **Employee** | `employee@demo.com` | `Demo@123456` | موظف تجريبي |

## المكونات الرئيسية

### 1. `DemoAccountService` (`lib/core/services/demo_account_service.dart`)

خدمة رئيسية لإدارة حسابات تجريبية:

```dart
// إنشاء جميع حسابات تجريبية
final service = DemoAccountService();
final results = await service.createAllDemoAccounts();

// إنشاء حساب تجريبي معين
final doctorResult = await service.createDemoAccountByRole('doctor');

// التحقق من وجود حساب تجريبي
final exists = await service.demoAccountExists('patient');

// الحصول على بيانات اعتماد جميع الحسابات
final credentials = service.getAllDemoCredentials();
```

### 2. Use Cases

تم توفير Use Cases للاستخدام مع BLoC:

```dart
// في الـ BLoC
final createDemoUseCase = sl<CreateDemoAccountsUseCase>();
final checkAuthUseCase = sl<CheckDemoAccountExistsUseCase>();

// استدعاء الـ Use Case
final results = await createDemoUseCase(NoParams());
final exists = await checkAuthUseCase('doctor');
```

### 3. `demo_accounts_init.dart`

دوال مساعدة للتهيئة السريعة:

```dart
import 'package:mcs/core/services/demo_accounts_init.dart';

// تهيئة جميع حسابات تجريبية
final service = sl<DemoAccountService>();
final report = await initializeDemoAccounts(
  service,
  verbose: true,
);

// طباعة بيانات الاعتماد
printDemoCredentials(service);
```

## خطوات الاستخدام

### الطريقة 1: من السكريبت SQL (الأسرع)

1. اذهب إلى Supabase Dashboard
2. انسخ محتوى `supabase/migrations/v3_P02_demo_accounts_seed.sql`
3. قم بتشغيله في SQL Editor في Supabase
4. سيتم إنشاء جميع الحسابات التجريبية مباشرة

### الطريقة 2: من تطبيق Flutter

#### في `main.dart`:

```dart
import 'package:mcs/core/config/injection_container.dart' as injection;
import 'package:mcs/core/services/demo_account_service.dart';
import 'package:mcs/core/services/demo_accounts_init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ... إعداد Supabase ...
  
  // تشغيل الإعدادات
  await injection.configureDependencies();
  
  // [اختياري] إنشاء حسابات تجريبية عند التطوير
  if (kDebugMode) {
    final demoService = injection.sl<DemoAccountService>();
    await initializeDemoAccounts(demoService, verbose: true);
    
    // طباعة بيانات الاعتماد (لتسهيل الاختبار)
    printDemoCredentials(demoService);
  }
  
  runApp(const MyApp());
}
```

#### في أي شاشة/BLoC:

```dart
class MyBloc extends Bloc {
  MyBloc(this._createDemoUseCase);
  
  final CreateDemoAccountsUseCase _createDemoUseCase;
  
  Future<void> setupDemoAccounts() async {
    final results = await _createDemoUseCase(NoParams());
    
    for (final result in results.values) {
      print('${result.role}: ${result.message}');
    }
  }
}
```

## هيكل البيانات

### حسابات تم فحصها تلقائيًا

عند إنشاء حساب تجريبي، يتم إنشاء السجلات التالية تلقائيًا:

1. **مستخدم** في جدول `users`
2. **طبيب** في جدول `doctors` (للدور `doctor`)
3. **مريض** في جدول `patients` (للدور `patient`)
4. **موظف** في جدول `employees` (للدور `employee`)

### بيانات الحساب التجريبي للطبيب

```json
{
  "id": "uuid...",
  "email": "doctor@demo.com",
  "full_name": "Dr. Demo Doctor",
  "phone": "+213612345672",
  "role": "doctor",
  "is_active": true,
  "specialization": "عام",
  "bio": "طبيب تجريبي لاختبار النظام",
  "license_number": "LIC-DEMO-001",
  "years_of_experience": 5,
  "consultation_fee": 100
}
```

## ميزات مهمة

### ✅ عدم التكرار
- إذا كان الحساب موجودًا بالفعل، سيتم تخطيه بدلاً من محاولة إنشاؤه مرة أخرى
- يمكن تشغيل الأمر عدة مرات دون مشاكل

### ✅ معالجة الأخطاء
- جميع الأخطاء يتم اكتشافها وتسجيلها
- يتم إرجاع تقرير مفصل عن كل محاولة

### ✅ التكامل الكامل
- يتم إنشاء جميع البيانات المرتبطة تلقائيًا
- كل حساب جاهز للاستخدام الفوري

### ✅ توثيق شامل
- جميع الدوال موثقة بوضوح
- أمثلة استخدام مفصلة في كل ملف

## استكشاف الأخطاء

### المشكلة: حسابات التجريب لا تُنشأ

**السبب المحتمل:** Supabase لم يتم إعداده بشكل صحيح

```dart
// تحقق من الاتصال
final service = sl<DemoAccountService>();
final superAdminExists = await service.demoAccountExists('super_admin');
print('Super Admin exists: $superAdminExists');
```

### المشكلة: لا يوجد رسالة خطأ واضحة

**الحل:** استخدم الوضع المفصل

```dart
await initializeDemoAccounts(service, verbose: true);
```

### المشكلة: محاولة تسجيل الدخول تفشل

**التحقق:**
1. تأكد من وجود الحساب: `await service.demoAccountExists('role')`
2. تأكد من كلمة المرور: استخدم `Demo@123456`
3. تحقق من بيانات Supabase Auth في Supabase Dashboard

## أفضل الممارسات

### ✓ في بيئة التطوير
```dart
if (kDebugMode) {
  await initializeDemoAccounts(service, verbose: true);
}
```

### ✓ في الاختبار المتكامل
```dart
Future<void> setUpAllTestDemoAccounts() async {
  final service = DemoAccountService();
  await service.createAllDemoAccounts();
}
```

### ✗ في الإنتاج
```dart
// لا تنادي هذا في الإنتاج!
// احذف هذا الكود تماماً قبل النشر:
if (kDebugMode) {
  await initializeDemoAccounts(service);
}
```

## الملفات المتعلقة

| الملف | الوصف |
|------|-------|
| `lib/core/services/demo_account_service.dart` | الخدمة الرئيسية |
| `lib/core/services/demo_accounts_init.dart` | دوال المساعدة |
| `lib/core/usecases/demo_accounts_usecase.dart` | Use Cases |
| `lib/core/config/injection_container.dart` | تسجيل الخدمات |
| `supabase/migrations/v3_P02_demo_accounts_seed.sql` | سكريبت SQL |

## الخطوات التالية

### اختياري: تخصيص بيانات التجريب

إذا أردت تعديل البيانات التجريبية (الأسماء، التخصصات، إلخ):

1. عدّل `_getDemoFullName()` في `DemoAccountService`
2. عدّل `_createDoctorRecord()` و`_createPatientRecord()`
3. عدّل السكريبت SQL إذا أردت استخدامه

### إضافة حسابات تجريبية إضافية

```dart
// أضف إلى map demoAccounts في DemoAccountService
static const Map<String, String> demoAccounts = {
  // ...existing...
  'clinic_admin': 'clinicadmin@demo.com',
};

// ثم أضف الدالة المرتبطة:
Future<void> _createClinicAdminRecord(String userId) async {
  // محتوى الإنشاء
}
```

## ملاحظات أمان

⚠️ **تهديد أمني:** حسابات التجريب الهذه يجب أن تكون **للتطوير والاختبار فقط**.

```dart
// تأكد من هذا في الكود:
if (!kDebugMode) {
  // لا تنشئ حسابات تجريبية في الإنتاج
  return;
}
```

لا تستخدم كلمات مرور حقيقية أو حسابات حقيقية كـ demo accounts.

---

تم الإنشاء بواسطة: GitHub Copilot
التاريخ: 2026-03-12
