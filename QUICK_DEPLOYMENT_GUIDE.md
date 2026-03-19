# دليل النشر السريع | Quick Deployment Guide
# نظام المصادقة المتقدمة | Advanced Authentication System

---

## 📋 المتطلبات المسبقة | Prerequisites

```
✅ Flutter SDK 3.19.0+
✅ Dart 3.3.0+
✅ Supabase account active
✅ .env file configured with SUPABASE_URL and SUPABASE_ANON_KEY
✅ All 30 migration files present in supabase/migrations/
✅ Database models (4) updated and tested
✅ All services (3) implemented and ready
```

---

## 🚀 خطوات النشر | Deployment Steps

### الخطوة 1: إعداد قاعدة البيانات | Step 1: Database Setup

```bash
# تطبيق الترحيلات على Supabase
# Apply migrations to Supabase

supabase db push --dry-run

# تحقق من الرسائل - ستخبرك بالتغييرات
# Check messages - it will show what will be changed

supabase db push

# تطبيق فعلي للترحيلات
# Actual migration application
```

### الخطوة 2: التحقق من البيانات | Step 2: Verify Data

```bash
# تسجيل الدخول إلى Supabase Console
# Login to Supabase Console
# → Database → Tables

# تحقق من وجود:
# Verify presence of:
- roles (8 rows)
- role_permissions (12+ rows)
- registration_requests (0 rows - new table)
```

### الخطوة 3: إعداد ملفات Dart | Step 3: Setup Dart Files

```bash
# تحديث ملفات Flutter
# Update Flutter files

cd /Users/Administrateur/mcs

# الحصول على التبعيات
# Get dependencies
flutter pub get

# (اختياري) إعادة بناء الكود المولد
# (Optional) Rebuild generated code
dart run build_runner build --delete-conflicting-outputs
```

### الخطوة 4: تشغيل الاختبارات | Step 4: Run Tests

```bash
# اختبار وحدات محددة
# Run specific unit tests
flutter test test/models/auth_models_test.dart

# اختبار الخدمات
# Test services
flutter test test/services/ -k "RoleBasedAuthentication"

# تحليل الأكواد
# Code analysis
flutter analyze
```

### الخطوة 5: اختبار البيئة التطوير | Step 5: Test Development

```bash
# على محاكي أو جهاز
# On emulator or device
flutter run

# أو Desktop (Windows)
# Or Desktop (Windows)
flutter run -d windows

# أو Web
# Or Web
flutter run -d chrome
```

---

## 🧪 سيناريوهات الاختبار | Testing Scenarios

### السيناريو 1: تسجيل مريض عام (Public Role)

```
1. انقر على "تسجيل جديد" | Click "Register"
2. اختر "مريض" | Select "Patient"
3. أدخل البيانات:
   - Email: patient@example.com
   - Password: SecurePass123!
   - Full Name: أحمد محمد (Ahmed Mohammed)
4. انقر "التسجيل" | Click "Register"

النتيجة المتوقعة: ✅
- تحويل إلى التحقق من البريد
- رسالة تحقق مُرسلة
- بعد التحقق: تفعيل حساب فوري
```

### السيناريو 2: تسجيل طبيب (Approval Required Role)

```
1. انقر على "تسجيل جديد" | Click "Register"
2. اختر "طبيب" | Select "Doctor"
3. أدخل البيانات:
   - Email: doctor@example.com
   - Password: SecurePass123!
   - Full Name: أ.د محمد علي (Dr. Mohammed Ali)
   - License: 12345678
4. انقر "التسجيل" | Click "Register"

النتيجة المتوقعة: ✅
- تحويل إلى التحقق من البريد
- بعد التحقق: انتظار الموافقة
- إشعار يُرسل للمسؤول
- المسؤول يراجع الطلب في Dashboard
```

### السيناريو 3: لوحة تحكم المسؤول (Admin Dashboard)

```
1. سجل دخول كمسؤول:
   - Email: admin@demo.com
   - Password: AdminPass123!

2. اذهب إلى "طلبات التسجيل" | Go to "Registration Requests"

3. اختر طلب معلق | Select pending request

4. مرحلتان:
   أ) الموافقة:
      - انقر "الموافقة" | Click "Approve"
      - الطبيب يتلقى إشعار
      - حسابه يُفعّل
   
   ب) الرفض:
      - انقر "رفض" | Click "Reject"
      - أدخل السبب: "ترخيص غير صالح"
      - الطبيب يتلقى إشعار الرفض

النتيجة المتوقعة: ✅
- طلب يُعدّل في قاعدة البيانات
- إشعار يُرسل إلى المستخدم
- Dashboard يُحدّث فوراً
```

### السيناريو 4: المصادقة الثنائية (2FA)

```
للمسؤولين والمسؤولين الأساسيين:

1. الدخول الأول:
   - Email & Password صحيح
   - يُطلب 2FA

2. خياران:
   أ) استخدام تطبيق (Google Authenticator):
      - امسح رمز QR
      - أدخل 6 أرقام من التطبيق
   
   ب) استخدام أكواد الاحتياطي:
      - استعمل أحد أكواز الـ10 الاحتياطية
      - كل كود يُستعمل مرة واحدة فقط

النتيجة المتوقعة: ✅
- تسجيل دخول نجح بـ 2FA
- الأكواد المستخدمة تُحذف
- التطبيق يحفظ حالة 2FA
```

### السيناريو 5: التحقق من الأذونات (Permissions)

```
1. سجل دخول كأدوار مختلفة
2. تحقق من الأذونات المتاحة:

مريض (Patient):
  ✅ patients.view_profile
  ✅ patients.edit_profile
  ✅ patients.view_appointments
  ✅ patients.create_appointments

طبيب (Doctor):
  ✅ doctors.view_profile
  ✅ doctors.view_appointments
  ✅ doctors.create_prescriptions
  ✅ doctors.view_patients

مسؤول (Admin):
  ✅ admin.view_all_patients
  ✅ admin.approve_requests
  ✅ admin.view_analytics

النتيجة المتوقعة: ✅
- الأزرار الممنوعة مخفية
- الخيارات غير المسموحة معطلة
- الرسائل واضحة عند المحاولة
```

---

## 🐛 عند مواجهة مشاكل | Troubleshooting

### مشكلة 1: "Failed to connect to Supabase"

```
الحل:
1. تحقق من .env يتضمن:
   SUPABASE_URL=https://xxx.supabase.co
   SUPABASE_ANON_KEY=eyJ...

2. تحقق من الاتصال الإنترنت

3. تحقق من أن Supabase project نشط:
   → Supabase dashboard → Project

4. أعد تشغيل التطبيق:
   flutter clean
   flutter pub get
   flutter run
```

### مشكلة 2: "Table 'roles' doesn't exist"

```
الحل:
1. تأكد من تطبيق جميع الترحيلات:
   supabase db list   # اعرض الترحيلات المطبقة

2. إذا كانت ناقصة، طبّق يدوياً:
   supabase db push

3. تحقق في Supabase Console:
   → Database → Tables → يجب أن تكون موجودة
```

### مشكلة 3: "RLS Policy Violation"

```
الحل:
1. تأكد من أن المستخدم مسجل دخول:
   - التحقق من auth.uid()

2. تحقق من RLS Policies:
   → Supabase Console → Database → Policies

3. للاختبار، يمكن إيقاف RLS مؤقتاً (فقط في التطوير):
   ALTER TABLE roles DISABLE ROW LEVEL SECURITY;
```

### مشكلة 4: "Permission denied"

```
الحل:
1. تحقق من دور المستخدم:
   SELECT role_id FROM profiles WHERE id = auth.uid();

2. تحقق من الأذونات:
   SELECT * FROM role_permissions
   WHERE role_id = 'xxx';

3. تأكد من أن الأذن موجودة وصحيحة
```

### مشكلة 5: "Email verification token expired"

```
الحل:
1. طلب رسالة تحقق جديدة (أعد إرسال)

2. الرموز تنتهي بعد 24 ساعة

3. إذا كان اختباراً، تحقق من وقت الخادم
```

---

## 📊 مؤشرات النجاح | Success Indicators

### ✅ جاهز للإنتاج عندما:

```
قاعدة البيانات:
  ✅ 30 ملف ترحيل مطبق
  ✅ 27 جدول موجود
  ✅ RLS Policies نشطة
  ✅ البيانات الافتراضية مدرجة

التطبيق:
  ✅ flutter analyze بدون أخطاء
  ✅ flutter test ناجحة
  ✅ جميع الشاشات تعرض بشكل صحيح
  ✅ التسجيل يعمل بدون أخطاء

المصادقة:
  ✅ تسجيل الدخول يعمل
  ✅ التحقق من البريد يعمل
  ✅ الأدوار تُعيّن بشكل صحيح
  ✅ الأذونات تُفرض بشكل صحيح
```

---

## 🎯 الخطوات التالية | Next Steps

### بعد التحقق الناجح:

```
1. إعدادات البيئة الإنتاجية:
   - استبدال المفاتيح بمفاتيح الإنتاج
   - تفعيل HTTPS
   - إعداد النسخ الاحتياطية

2. نشر على:
   - iOS: App Store
   - Android: Google Play
   - Web: Firebase Hosting أو Vercel
   - Windows/macOS: Direct Distribution

3. المراقبة:
   - إعداد Sentry للرصد
   - تتبع الأخطاء
   - تحليل الاستخدام
```

---

## 📞 المساعدة والدعم | Help & Support

### موارد مفيدة:

- 📖 [ADVANCED_AUTH_TESTING_GUIDE.md](ADVANCED_AUTH_TESTING_GUIDE.md) - اختبار شامل
- 📖 [ADVANCED_AUTH_INTEGRATION_GUIDE.md](ADVANCED_AUTH_INTEGRATION_GUIDE.md) - تكامل النظام
- 📖 [ADVANCED_AUTH_DEPENDENCY_INJECTION_SETUP.md](ADVANCED_AUTH_DEPENDENCY_INJECTION_SETUP.md) - إعداد DI
- 📖 [DATABASE_AUDIT_REPORT.md](DATABASE_AUDIT_REPORT.md) - تدقيق قاعدة البيانات

### الاتصال:

- إذا واجهت مشكلة، راجع التقارير أعلاه
- تحقق من الملفات قبل طلب الدعم

---

## ✨ الملخص | Summary

```
╔════════════════════════════════════════════════════════╗
║                                                        ║
║         نظام المصادقة المتقدم جاهز للنشر               ║
║    Advanced Authentication System Ready to Deploy      ║
║                                                        ║
║  الزمن المتوقع: 30 دقيقة للنشر الأول                 ║
║  Expected Time: 30 minutes for first deployment       ║
║                                                        ║
║  الخطوات الأساسية: 5 خطوات بسيطة                      ║
║  Basic Steps: 5 simple steps                          ║
║                                                        ║
║  ✅ مجهز بالكامل | Fully prepared                     ║
║  ✅ موثق بالكامل | Fully documented                  ║
║  ✅ مختبر بالكامل | Fully tested                      ║
║                                                        ║
║  🚀 ابدأ الآن | Start Now!                           ║
║                                                        ║
╚════════════════════════════════════════════════════════╝
```

---

**آخر تحديث**: 18 مارس 2026 | **Last Updated**: March 18, 2026
**الحالة**: جاهز للنشر الفوري | **Status**: Ready for immediate deployment

