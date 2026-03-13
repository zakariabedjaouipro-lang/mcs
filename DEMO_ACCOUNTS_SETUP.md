# 🎯 حسابات التجريب - Demo Accounts

## 📋 الحسابات المتاحة

| الدور | Email | كلمة المرور | الوصف |
|------|-------|-----------|--------|
| **Doctor** 👨‍⚕️ | doctor@mcs.demo | Demo123456 | حساب الطبيب |
| **Patient** 🏥 | patient@mcs.demo | Demo123456 | حساب المريض |
| **Admin** ⚙️ | admin@mcs.demo | Demo123456 | مسؤول العيادة |
| **Super Admin** 👑 | superadmin@mcs.demo | Demo123456 | المسؤول الأساسي |
| **Staff** 👨‍💼 | staff@mcs.demo | Demo123456 | حساب الموظف |

## 🚀 كيفية الاستخدام

### الطريقة 1️⃣ - عبر واجهة التطبيق
1. افتح صفحة تسجيل الدخول: `/login`
2. اضغط على زر **"Demo"** الأزرق
3. سيظهر قائمة بجميع حسابات التجريب
4. اضغط على الحساب الذي تريد اختباره = سيتم ملء بيانات تسجيل الدخول تلقائياً
5. اضغط "Login" للدخول

### الطريقة 2️⃣ - اختبار مباشر عبر URLs
استخدم هذه المسارات للذهاب مباشرة للشاشات:

```
/test-admin          → شاشة Admin Dashboard
/test-super-admin    → شاشة Super Admin
/test-doctor         → شاشة Doctor Dashboard  
/test-patient        → شاشة Patient Home
/test-employee       → شاشة Employee Dashboard
```

### الطريقة 3️⃣ - إنشاء حسابات جديدة في Supabase
إذا كنت تريد إنشاء حسابات تجريب جديدة في قاعدة البيانات:

```bash
# قم بتشغيل ملف إنشاء الحسابات
dart run create_demo_accounts.dart
```

## ⚠️ ملاحظات مهمة

1. **قبل النشر** - تأكد من حذف مسارات `/test-*` من ملف `router.dart`
2. **كلمات المرور** - جميع الحسابات تستخدم نفس كلمة المرور للتجريب السهل
3. **البيانات** - قد تحتاج إلى إنشاء الحسابات يدويًا في Supabase إذا لم تكن موجودة

## 🔑 الأدوار والصلاحيات

| الدور | الوصول |
|------|--------|
| `super_admin` | جميع الأنظمة والتكوينات |
| `clinic_admin` | إدارة العيادة والعيادات |
| `doctor` | إدارة المرضى والمواعيد |
| `patient` | الوصول للملف الصحي والمواعيد |
| `staff` | إدارة المخزون والفواتير |

## 📱 حالات الاستخدام

### ✅ لاختبار Admin Dashboard
1. استخدم `admin@mcs.demo` في صفحة الدخول
2. أو اذهب مباشرة لـ `/test-admin`

### ✅ لاختبار Super Admin
1. استخدم `superadmin@mcs.demo` في صفحة الدخول
2. أو اذهب مباشرة لـ `/test-super-admin`

### ✅ لاختبار Doctor Dashboard
1. استخدم `doctor@mcs.demo` في صفحة الدخول
2. أو اذهب مباشرة لـ `/test-doctor`

## 🔄 مراجع إضافية

- صفحة تسجيل الدخول: `lib/features/auth/screens/premium_login_screen.dart`
- الموجهات: `lib/core/config/router.dart`
- إنشاء الحسابات: `create_demo_accounts.dart`
