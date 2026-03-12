# تعليمات التكامل - حسابات تجريبية

## كيفية إضافة نظام حسابات التجريبية إلى main.dart

### الخطوة 1: أضف الـ imports

في `lib/main.dart`، أضف هذه الـ imports:

```dart
import 'package:flutter/foundation.dart'; // للتحقق من kDebugMode
import 'package:mcs/core/services/demo_account_service.dart';
import 'package:mcs/core/services/demo_accounts_init.dart';
```

### الخطوة 2: أضف هذا الكود بعد `await configureDependencies()` في `main()`

```dart
// ─────────────────────────────────────────────────────────────┐
// [OPTIONAL] Initialize demo accounts for development
// ─────────────────────────────────────────────────────────────┘
if (kDebugMode) {
  developer.log(
    'Initializing demo accounts for development...',
    name: 'AppInit',
    level: 800,
  );
  
  try {
    final demoService = sl<DemoAccountService>();
    final report = await initializeDemoAccounts(
      demoService,
      verbose: true,
    );

    developer.log(
      report.toString(),
      name: 'DemoAccounts',
      level: 800,
    );

    // Print to console for easy reference
    if (report.isSuccessful) {
      printDemoCredentials(demoService);
    }
  } catch (e, st) {
    developer.log(
      'Demo account initialization failed: $e',
      name: 'DemoAccounts',
      level: 1000,
      stackTrace: st,
    );
    // Don't fail the app if demo setup fails
  }
}
```

### الخطوة 3: تشغيل التطبيق

عند تشغيل التطبيق في وضع Debug:
- سيتم إنشاء جميع حسابات التجريب تلقائياً
- ستظهر بيانات الاعتماد في console
- إذا كانت الحسابات موجودة بالفعل، سيتم تخطيها

## البديل: إنشاء حسابات تجريبية أثناء التطوير فقط

### غير آمن (لا تستخدمه في الإنتاج):

```dart
// ❌ غير آمن - قد ينسى المطور حذف الكود
if (true) { // خطأ! قد ننسى تغيير هذا
  await initializeDemoAccounts(...);
}
```

### ✅ آمن (استخدم دائماً):

```dart
// ✅ آمن - سيتم تجميع هذا الكود فقط في وضع Debug
if (kDebugMode) {
  await initializeDemoAccounts(...);
}
```

## كيفية استخدام حسابات التجريب بعد الإنشاء

### في شاشة تسجيل الدخول:

```dart
// استيراد helper
import 'package:mcs/core/services/demo_accounts_init.dart';

// في Widget
ElevatedButton(
  onPressed: () async {
    // تسجيل دخول سريع كطبيب تجريبي
    await quickLoginWithDemoAccount('doctor');
  },
  child: const Text('Demo Login - Doctor'),
),
```

### التحقق من وجود حساب قبل العرض:

```dart
// استيراد المساعد
import 'package:mcs/core/services/demo_account_examples.dart';

// في build():
if (await DemoLoginHelper.isDemoDoctorAvailable()) {
  demoLoginButton()
}
```

## استكشاف الأخطاء

### المشكلة: رسائل خطأ غير واضحة

**الحل:** استخدم الوضع المفصل

```dart
final report = await initializeDemoAccounts(
  demoService,
  verbose: true,
);

print(report); // يطبع تقرير مفصل
```

### المشكلة: الحسابات قد لا تكون موجودة

**التحقق:** اختبر كل حساب على حدة

```dart
final service = sl<DemoAccountService>();

for (final role in ['doctor', 'patient', 'admin']) {
  final exists = await service.demoAccountExists(role);
  print('$role exists: $exists');
}
```

### المشكلة: Supabase لم يتم إعداده بشكل صحيح

**الحل:** قم بتشغيل سكريبت SQL السداد أولاً

```sql
-- في Supabase SQL Editor:
-- انسخ محتوى: supabase/migrations/v3_P02_demo_accounts_seed.sql
-- والصقه هنا وقم بالتشغيل
```

## نصائح مهمة

### ✅ استخدم دائماً `kDebugMode`
```dart
if (kDebugMode) {
  // هذا الكود سيُحذف تلقائياً من build الإنتاج
  await initializeDemoAccounts(...);
}
```

### ✅ اختبر كل الأدوار
```dart
// Test script للتحقق من جميع الحسابات:
Future<void> testAllDemoAccounts() async {
  final service = sl<DemoAccountService>();
  for (final entry in DemoAccountService.demoAccounts.entries) {
    final exists = await service.demoAccountExists(entry.key);
    print('${entry.key}: ${exists ? '✅' : '❌'}');
  }
}
```

### ✅ حفظ بيانات الاعتماد آمنة
```dart
// لا تخزن بيانات الاعتماد في الكود!
// استخدم demo_account_service.dart بدلاً من ذلك:
final credentials = service.getAllDemoCredentials();
```

## خطوات التحقق

بعد إضافة الكود إلى `main.dart`:

1. قم بتشغيل التطبيق في Debug:
   ```bash
   flutter run
   ```

2. افتح console في IDE وابحث عن:
   ```
   ✅ Demo accounts successfully verified
   ```

3. انسخ بيانات الاعتماد من Console:
   ```
   ╔════════════════════════════════════════════════════════════╗
   ║            DEMO ACCOUNT CREDENTIALS (DEV ONLY)            ║
   ...
   ```

4. جرب تسجيل الدخول برقم واحد من الحسابات

## الملفات المعدلة/الجديدة

| الملف | الحالة | الملاحظات |
|------|--------|---------|
| `lib/core/services/demo_account_service.dart` | ✅ جديد | الخدمة الرئيسية |
| `lib/core/services/demo_accounts_init.dart` | ✅ جديد | دوال مساعدة |
| `lib/core/usecases/demo_accounts_usecase.dart` | ✅ جديد | Use Cases |
| `lib/core/config/injection_container.dart` | ✅ معدل | تسجيل الخدمات |
| `lib/main.dart` | 🔄 يحتاج تعديل | أضف الـ initialization |
| `supabase/migrations/v3_P02_demo_accounts_seed.sql` | ✅ جديد | سكريبت SQL |

## أسئلة شائعة

**س: هل سيؤثر نظام حسابات التجريب على الإنتاج؟**\
ج: لا، استخدام `kDebugMode` يضمن أن الكود لن يعمل في بناء الإنتاج.

**س: ماذا لو أنسيت حذف الكود قبل النشر؟**\
ج: لا تقلق، `if (kDebugMode)` سيمنع تنفيذه تلقائياً.

**س: كيف أختبر الأدوار المختلفة؟**\
ج: استخدم حسابات التجريب المختلفة:
- `doctor@demo.com` للأطباء
- `patient@demo.com` للمرضى
- إلخ

**س: هل يمكن تخصيص بيانات التجريب؟**\
ج: نعم، عدّل البيانات في `DemoAccountService` و `demo_accounts_seed.sql`.

---

الآن أنت جاهز لاستخدام نظام حسابات التجريب! 🎉
