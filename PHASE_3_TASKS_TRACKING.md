# ✅ تتبع مهام المرحلة الثالثة - الإصلاحات المطلوبة

بسم الله الرحمن الرحيم

---

## 📋 ملخص المهام:

**عدد المهام الكلي**: 11 مهمة أساسية  
**الفئات**: 3 فئات (الدوائر + الشاشات + التحقق)  
**المدة المتوقعة**: ساعة و45 دقيقة  
**درجة الصعوبة**: منخفضة (نسخ/لصق + تعديل بسيط)

### توزيع المهام:

```
فئة 1: إصلاح 7 دوائر Dashboards      ├─ 7 مهام ├─ 45 دقيقة
فئة 2: إصلاح شاشتان مشتركتان         ├─ 2 مهام ├─ 30 دقيقة  
فئة 3: التحقق والاختبار              ├─ 2 مهام ├─ 30 دقيقة
────────────────────────────────────────────────────────
المجموع:                            11 مهام   ساعة و45 دقيقة
```

---

## 🔴 الفئة الأولى: إصلاح Dashboards (7 مهام)

المدة المتوقعة: 45 دقيقة (6-7 دقائق لكل ملف)

### مهمة 1️⃣ : Nurse Dashboard
**الملف**: `lib/features/nurse/presentation/screens/nurse_dashboard.dart`
- [ ] فتح الملف
- [ ] استبدل Scaffold بـ UnifiedAppScaffold
- [ ] أضف role parameter
- [ ] اختبر: `flutter run`
**المثال**: انسخ من التوصيات
**الحالة**: ⏳ لم تبدأ بعد

---

### مهمة 2️⃣ : Receptionist Dashboard  
**الملف**: `lib/features/receptionist/presentation/screens/receptionist_dashboard.dart`
- [ ] فتح الملف
- [ ] استبدل Scaffold بـ UnifiedAppScaffold
- [ ] أضف role parameter
- [ ] اختبر: `flutter run`
**المثال**: انسخ من التوصيات
**الحالة**: ⏳ لم تبدأ بعد

---

### مهمة 3️⃣ : Pharmacist Dashboard
**الملف**: `lib/features/pharmacy/presentation/screens/pharmacist_dashboard.dart`
- [ ] فتح الملف
- [ ] استبدل Scaffold بـ UnifiedAppScaffold
- [ ] أضف role parameter
- [ ] اختبر: `flutter run`
**المثال**: انسخ من التوصيات
**الحالة**: ⏳ لم تبدأ بعد

---

### مهمة 4️⃣ : Lab Technician Dashboard
**الملف**: `lib/features/lab/presentation/screens/lab_technician_dashboard.dart`
- [ ] فتح الملف
- [ ] استبدل Scaffold بـ UnifiedAppScaffold
- [ ] أضف role parameter
- [ ] اختبر: `flutter run`
**المثال**: انسخ من التوصيات
**الحالة**: ⏳ لم تبدأ بعد

---

### مهمة 5️⃣ : Radiographer Dashboard
**الملف**: `lib/features/radiology/presentation/screens/radiographer_dashboard.dart`
- [ ] فتح الملف
- [ ] استبدل Scaffold بـ UnifiedAppScaffold
- [ ] أضف role parameter
- [ ] اختبر: `flutter run`
**المثال**: انسخ من التوصيات
**الحالة**: ⏳ لم تبدأ بعد

---

### مهمة 6️⃣ : Clinic Admin Dashboard
**الملف**: `lib/features/clinic_admin/presentation/screens/clinic_dashboard.dart`
- [ ] فتح الملف
- [ ] استبدل Scaffold بـ UnifiedAppScaffold
- [ ] أضف role parameter
- [ ] حافظ على BLoC integration
- [ ] اختبر: `flutter run`
**ملاحظة**: هذا الملف يحتوي على BLoC - احرص على عدم كسره
**المثال**: انسخ من التوصيات
**الحالة**: ⏳ لم تبدأ بعد

---

### مهمة 7️⃣ : Relative Home Screen
**الملف**: `lib/features/relative/presentation/screens/relative_home_screen.dart`
- [ ] فتح الملف
- [ ] استبدل Scaffold بـ UnifiedAppScaffold
- [ ] أضف role parameter
- [ ] اختبر: `flutter run`
**المثال**: انسخ من التوصيات
**الحالة**: ⏳ لم تبدأ بعد

---

## 🟡 الفئة الثانية: إصلاح الشاشات المشتركة (2 مهام)

المدة المتوقعة: 30 دقيقة (15 دقيقة لكل شاشة)

### مهمة 8️⃣ : Settings Screen
**الملف**: `lib/features/settings/presentation/screens/settings_screen.dart`
- [ ] فتح الملف
- [ ] أزل Scaffold
- [ ] أضف UnifiedAppScaffold كـ wrapper
- [ ] أزل Theme.of(context) واستخدم UnifiedAppScaffold بدلاً منها
- [ ] اختبر: `flutter run`
**ملاحظة**: هذا الملف يستخدم BLoC - احرص على الحفاظ عليه
**المثال**: انسخ من التوصيات
**التعقيد**: متوسط (يحتوي على Theme management)
**الحالة**: ⏳ لم تبدأ بعد

---

### مهمة 9️⃣ : Appointments Screen
**الملف**: `lib/features/appointment/presentation/screens/appointments_screen.dart`
- [ ] فتح الملف
- [ ] أزل Scaffold
- [ ] أضف UnifiedAppScaffold كـ wrapper
- [ ] أزل TabBar من AppBar وضعه داخل الـ body
- [ ] اختبر: `flutter run`
**ملاحظة**: يحتوي على TabController - احفظ التاب التبديل
**المثال**: انسخ من التوصيات
**التعقيد**: متوسط (يحتوي على TabBar)
**الحالة**: ⏳ لم تبدأ بعد

---

## 🟢 الفئة الثالثة: التحقق والاختبار (2 مهام)

المدة المتوقعة: 30 دقيقة

### مهمة 🔟 : التحليل والفحص
**الأمر**: `flutter analyze --no-pub`
- [ ] افتح Terminal
- [ ] اذهب لجذر المشروع
- [ ] شغل الأمر
- [ ] اقرأ النتائج
- [ ] إذا كانت هناك أخطاء → اصلح
**النتيجة المتوقعة**: 0 أخطاء حرجة ✅
**الوقت**: 5 دقائق
**الحالة**: ⏳ لم تبدأ بعد

---

### مهمة 1️⃣1️⃣ : اختبار يدوي شامل
**الخطوات**:
- [ ] شغل: `flutter run`
- [ ] جرب كل دور (10 أدوار):
  - [ ] Super Admin
  - [ ] Clinic Admin
  - [ ] Doctor
  - [ ] Nurse
  - [ ] Receptionist
  - [ ] Pharmacist
  - [ ] Lab Technician
  - [ ] Radiographer
  - [ ] Patient
  - [ ] Relative
- [ ] تحقق من الأزرار الموحدة (5 أزرار كل واحد):
  - [ ] Notification Button
  - [ ] Theme Toggle
  - [ ] Language Toggle
  - [ ] Profile Button
  - [ ] Back Button
- [ ] اختبر تبديل اللغة (AR ↔ EN)
- [ ] اختبر تبديل المظهر (Light ↔ Dark)

**النتيجة المتوقعة**: جميع الاختبارات تمر ✅  
**الوقت**: 20-25 دقيقة  
**الحالة**: ⏳ لم تبدأ بعد

---

## 📊 جدول تتبع التقدم:

### الحالة الحالية:

```
فئة 1 (Dashboards)      ░░░░░░░░░░ 0% (لم تبدأ بعد)
├─ مهمة 1: Nurse         ░░░░░░░░░░ 0%
├─ مهمة 2: Receptionist  ░░░░░░░░░░ 0%
├─ مهمة 3: Pharmacist    ░░░░░░░░░░ 0%
├─ مهمة 4: Lab Tech      ░░░░░░░░░░ 0%
├─ مهمة 5: Radiographer  ░░░░░░░░░░ 0%
├─ مهمة 6: Clinic Admin  ░░░░░░░░░░ 0%
└─ مهمة 7: Relative      ░░░░░░░░░░ 0%

فئة 2 (Shared Screens)  ░░░░░░░░░░ 0% (لم تبدأ بعد)
├─ مهمة 8: Settings      ░░░░░░░░░░ 0%
└─ مهمة 9: Appointments  ░░░░░░░░░░ 0%

فئة 3 (Verification)    ░░░░░░░░░░ 0% (لم تبدأ بعد)
├─ مهمة 10: Analyze      ░░░░░░░░░░ 0%
└─ مهمة 11: Manual Test  ░░░░░░░░░░ 0%
```

---

## 📅 جدول زمني مقترح:

### الجلسة الأولى (ساعة و15 دقيقة):
```
الوقت      | المهمة
─────────────────────────────────
0:00-0:06  | مهمة 1: Nurse Dashboard
0:06-0:12  | مهمة 2: Receptionist Dashboard
0:12-0:18  | مهمة 3: Pharmacist Dashboard
0:18-0:24  | مهمة 4: Lab Tech Dashboard
0:24-0:30  | مهمة 5: Radiographer Dashboard
0:30-0:36  | مهمة 6: Clinic Admin Dashboard
0:36-0:42  | مهمة 7: Relative Home Screen
0:42-0:50  | استراحة + flutter clean (10 دقائق)
0:50-0:55  | مهمة 10: flutter analyze
0:55-1:00  | مراجعة والتحضير للجلسة القادمة
1:00-1:15  | وقت احتياطي للمشاكل
```

### الجلسة الثانية (45 دقيقة):
```
الوقت      | المهمة
─────────────────────────────────
0:00-0:15  | مهمة 8: Settings Screen
0:15-0:30  | مهمة 9: Appointments Screen
0:30-0:35  | flutter analyze
0:35-0:45  | مهمة 11: Manual Testing (كل الأدوار والأزرار)
```

---

## 🔑 العوامل الحرجة:

### لا تنسَ:
- ✅ اختبار كل ملف بـ `flutter run` مباشرة بعده
- ✅ نسخ الأمثلة من ملف التوصيات
- ✅ الحفاظ على imports القديمة
- ✅ التحقق من عدم كسر BLoC
- ✅ اختبار اللغة والمظهر بعد الانتهاء

### احذر من:
- ❌ عدم استبدال جميع الـ Scaffold
- ❌ نسيان import UnifiedAppScaffold
- ❌ عدم تمرير role parameter
- ❌ تغيير المنطق الداخلي للشاشات
- ❌ نسيان الفواصل والعلامات

---

## 📚 المراجع السريعة:

### الملفات المساعدة:
- [UNIFIED_SCAFFOLD_FIX_RECOMMENDATIONS.md](UNIFIED_SCAFFOLD_FIX_RECOMMENDATIONS.md) - الأمثلة الكاملة
- [UNIFIED_SCAFFOLD_VERIFICATION_REPORT.md](UNIFIED_SCAFFOLD_VERIFICATION_REPORT.md) - التفاصيل الدقيقة
- [HOW_TO_USE_VERIFICATION_REPORTS.md](HOW_TO_USE_VERIFICATION_REPORTS.md) - دليل الاستخدام

### الملفات المراد تعديلها:
```
lib/features/nurse/presentation/screens/nurse_dashboard.dart
lib/features/receptionist/presentation/screens/receptionist_dashboard.dart
lib/features/pharmacy/presentation/screens/pharmacist_dashboard.dart
lib/features/lab/presentation/screens/lab_technician_dashboard.dart
lib/features/radiology/presentation/screens/radiographer_dashboard.dart
lib/features/clinic_admin/presentation/screens/clinic_dashboard.dart
lib/features/relative/presentation/screens/relative_home_screen.dart
lib/features/settings/presentation/screens/settings_screen.dart
lib/features/appointment/presentation/screens/appointments_screen.dart
```

---

## ✨ نموذج الإصلاح السريع:

```dart
// قبل:
Scaffold(
  appBar: AppBar(...),
  body: ...
)

// بعد:
UnifiedAppScaffold(
  role: userRole,
  body: ... // نفس content
)
```

**المدة**: 30 ثانية لكل ملف  
**الصعوبة**: سهل جداً

---

## 🎯 معايير النجاح النهائية:

بعد انتهاء جميع المهام:

- [ ] جميع 9 ملفات معدلة
- [ ] `flutter analyze` = نجح (0 أخطاء حرجة)
- [ ] `flutter run` = بدون crash
- [ ] كل دور يرى أزرار موحدة
- [ ] تبديل اللغة يعمل في كل شاشة
- [ ] تبديل المظهر يعمل في كل شاشة
- [ ] القائمة الجانبية تظهر بشكل صحيح

---

## 🏁 ملخص بسيط:

```
المطلوب:    تبديل Scaffold → UnifiedAppScaffold في 9 ملفات
الوقت:     ساعة و45 دقيقة فقط
الصعوبة:   سهلة جداً (نسخ/لصق + تعديل بسيط)
الفائدة:   نظام موحد 100% في التطبيق

بعد الانتهاء → احتفل! 🎉
```

---

**آخر تحديث**: 20 مارس 2026  
**الحالة**: جاهزة للبدء ✅

