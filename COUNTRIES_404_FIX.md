## خطأ Supabase 404: فشل جلب بيانات الدول (Countries)

### 🔴 المشكلة

عند محاولة الدخول أو التسجيل، يظهر الخطأ التالي:
```
GET https://rxwtdbvhxqxvckkllgep.supabase.co/rest/v1/countries?select=%2A&is_supported=eq.true&order=name.asc.nullslast 404 (Not Found)
```

### 🔍 السبب الجذري

1. **جدول countries موجود** في ملفات الترحيل (`migrations/`)
2. **لكن قد لم يتم تطبيقه** على قاعدة البيانات الفعلية في Supabase
3. **أو أن RLS policies محظوظة للوصول غير المصرح**

### ✅ الحل

#### الخطوة 1: تطبيق Migration جديد
تم إنشاء ملف migration جديد:
```
supabase/migrations/20260312_fix_countries_rls_public_access.sql
```

هذا الملف يقوم بـ:
- ✅ حذف السياسات القديمة التي قد تكون مقيدة
- ✅ إضافة سياسات جديدة تسمح بالوصول العام
- ✅ التحقق من أن البيانات موجودة

#### الخطوة 2: تطبيق الـ RLS Policies

الملف الأصلي `20260304120002_create_countries_table.sql` يحتوي على:
- ✅ تعريف كامل لجدول countries (50+ دول)
- ✅ بيانات مُدرجة مسبقاً (Seed Data)
- ✅ RLS Policies للوصول العام

#### الخطوة 3: التنفيذ اليدوي (إذا لزم الأمر)

إذا لم تنجح طريقة الترحيل، يمكنك تنفيذ هذا يدويًا في Supabase SQL Editor:

```sql
-- تفعيل الوصول العام لجدول countries
ALTER TABLE countries DISABLE ROW LEVEL SECURITY;
```

**أو** بدلاً من ذلك، حافظ على الأمان وأضف سياسة واضحة:

```sql
-- السياسة الحالية
CREATE POLICY "Public can read countries"
  ON countries FOR SELECT
  USING (is_supported = true OR is_active = true);
```

### 🔧 خطوات المتابعة

#### 1. في Supabase Dashboard:
- [ ] انتقل إلى **SQL Editor**
- [ ] قم بتشغيل الـ migration الجديد:
  ```sql
  -- Copy content from supabase/migrations/20260312_fix_countries_rls_public_access.sql
  ```
- [ ] تحقق من وجود البيانات:
  ```sql
  SELECT COUNT(*) FROM countries WHERE is_supported = true;
  ```
  يجب أن تحصل على نتيجة > 0

#### 2. للتطوير والاختبار:
```bash
# تحديث Supabase محليًا
supabase db push

# أو قم بـ sync مع الخادم
supabase db pull
supabase db push
```

#### 3. اختبار من التطبيق:
```dart
// هذا يجب أن يعمل الآن
final supabase = Supabase.instance.client;
final data = await supabase
    .from('countries')
    .select()
    .eq('is_supported', true)
    .order('name', ascending: true);

print('Countries loaded: ${data.length}'); // يجب أن يطبع رقم > 0
```

### 📊 بيانات Seed المدرجة

الملف الأصلي يتضمن **50+ دول** بما فيها:

**الدول العربية** (الأولويات):
- 🇩🇿 الجزائر (DZ)
- 🇲🇦 المغرب (MA)
- 🇹🇳 تونس (TN)
- 🇪🇬 مصر (EG)
- 🇸🇦 السعودية (SA)
- 🇦🇪 الإمارات (AE)
- وغيرها...

**دول أخرى** (للاختبار والتوسع):
- 🇺🇸 الولايات المتحدة (US)
- 🇬🇧 المملكة المتحدة (GB)
- 🇫🇷 فرنسا (FR)
- 🇮🇳 الهند (IN)
- وأكثر من 40 دولة أخرى

### 🔒 معلومات أمان RLS

**الجديد** - السياسات المُحدثة:
- ✅ يسمح بـ **SELECT** لأي مستخدم (معرّف أو غير معرّف)
- ✅ يسمح بـ **INSERT/UPDATE/DELETE** فقط للخدمة (`service_role`)
- ✅ **آمن** - لا يمكن تعديل البيانات من التطبيق مباشرة

### ⚙️ ملفات ذات صلة

```
lib/features/auth/screens/
├── register_screen.dart          (يستدعي جلب الدول)
├── premium_register_screen.dart   (يستدعي جلب الدول)
└── login_screen.dart

lib/features/patient/presentation/screens/
└── patient_book_appointment_screen.dart (يستدعي جلب الدول)

core/models/
└── country_model.dart            (نموذج البيانات)

supabase/migrations/
├── 20260304120002_create_countries_table.sql     (الجدول الأصلي)
└── 20260312_fix_countries_rls_public_access.sql (الإصلاح الجديد)
```

### 🧪 اختبار التشخيص

يمكنك استخدام هذا الكود للتحقق من الحالة:

```dart
Future<void> testCountriesAccess() async {
  try {
    final supabase = Supabase.instance.client;
    
    // اختبر الوصول العام (بدون auth)
    final data = await supabase
        .from('countries')
        .select('id, name, is_supported')
        .eq('is_supported', true)
        .order('name', ascending: true);
    
    print('✅ نجاح: تم جلب ${data.length} دولة');
    
  } on PostgrestException catch (e) {
    print('❌ خطأ في الوصول:');
    print('  Status: ${e.code}');
    print('  Message: ${e.message}');
    
    // 404 = جدول غير موجود أو محظور
    if (e.code == '404') {
      print('  الحل: تحقق من أن migration 20260304120002 تم تطبيقه');
    }
  }
}
```

### 📝 الخطوات التالية

1. ✅ تطبيق migration الجديد في Supabase
2. ✅ التحقق من وجود البيانات
3. ✅ اختبار من التطبيق
4. ✅ يجب أن تعمل صفحات التسجيل والدخول الآن ✨

---

**تاريخ التحديث:** 12 مارس 2026
**المجال:** Supabase Database - RLS Policies
**الحالة:** CRITICAL FIX ✅
