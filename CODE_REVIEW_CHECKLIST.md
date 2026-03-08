# Code Review Checklist - MCS Project

## 📋 قائمة مراجعة الكود - مشروع MCS

### 🔍 Null Safety (التحقق من Null Safety)

- [ ] جميع القيم Nullable تم التحقق منها قبل الاستخدام
- [ ] استخدام `?.` و `??` بشكل صحيح
- [ ] لا توجد قيم dynamic بدون تحديد النوع
- [ ] استخدام `safe_extensions.dart` للتعامل الآمن مع البيانات
- [ ] جميع المتغيرات Nullable لها قيم افتراضية

### 📦 النماذج (Models)

- [ ] جميع الخصائص المستخدمة موجودة في النموذج
- [ ] النماذج تحتوي على جميع getters المطلوبة
- [ ] fromJson و toJson متوافقان مع قاعدة البيانات
- [ ] جميع الخصائص Nullable لها getters آمنة
- [ ] استخدام Equatable للمقارنة الصحيحة

### 🎨 الشاشات (Screens)

- [ ] جميع const مستخدمة بشكل صحيح
- [ ] لا توجد دوال مهملة (deprecated)
- [ ] جميع المعاملات المطلوبة متوفرة
- [ ] استخدام `withValues()` بدلاً من `withOpacity()`
- [ ] جميع الأحداث (events) موجودة في Bloc المناسب
- [ ] معالجة الأخطاء موجودة في جميع الأماكن

### 🔄 Bloc & Events

- [ ] جميع Events موجودة في Bloc
- [ ] جميع States موجودة في Bloc
- [ ] معالجة الأخطاء موجودة في جميع الـ handlers
- [ ] استخدام const للـ states البسيطة
- [ ] جميع emit calls متسقة

### 🌐 Supabase Integration

- [ ] أسماء الجداول والأعمدة متطابقة مع قاعدة البيانات
- [ ] أنواع البيانات متوافقة مع Supabase
- [ ] RLS policies مفعلة
- [ ] استخدام named parameters في استدعاءات Supabase
- [ ] معالجة أخطاء الشبكة والخادم

### 🧪 الاختبار (Testing)

- [ ] جميع الشاشات تعمل بدون أخطاء
- [ ] جميع الأحداث تعمل بشكل صحيح
- [ ] معالجة الأخطاء تعمل
- [ ] اختبار Null Safety
- [ ] اختبار edge cases

### 🎨 UI/UX

- [ ] جميع الألوان تستخدم `withValues()` بدلاً من `withOpacity()`
- [ ] جميع النصوص تدعم الترجمة (AppLocalizations)
- [ ] جميع الأيقونات موجودة وملونة بشكل صحيح
- [ ] التخطيط (layout) متجاوب
- [ ] معالجة loading states

### 📝 التعليقات (Documentation)

- [ ] جميع الدوال المعقدة لها تعليقات
- [ ] جميع النماذج موثقة
- [ ] جميع Events و States موثقة
- [ ] لا توجد TODOs غير مكتملة
- [ ] استخدام تعليقات بالعربية للأجزاء المهمة

### 🔒 الأمان (Security)

- [ ] لا توجد أسرار (secrets) في الكود
- [ ] التحقق من الصلاحيات (permissions) موجود
- [ ] معالجة البيانات الحساسة بشكل آمن
- [ ] استخدام HTTPS للاتصالات
- [ ] التحقق من المدخلات (input validation)

### ⚡ الأداء (Performance)

- [ ] استخدام const widgets حيثما أمكن
- [ ] تجنب إعادة بناء widgets غير ضرورية
- [ ] استخدام keys بشكل صحيح
- [ ] تحميل البيانات بشكل lazy عند الحاجة
- [ ] تجنب عمليات حسابية ثقيلة في UI thread

---

## 📝 Code Review Checklist - English Version

### 🔍 Null Safety

- [ ] All nullable values are checked before use
- [ ] Proper use of `?.` and `??` operators
- [ ] No dynamic types without explicit typing
- [ ] Use `safe_extensions.dart` for safe data handling
- [ ] All nullable variables have default values

### 📦 Models

- [ ] All used properties exist in the model
- [ ] Models contain all required getters
- [ ] fromJson and toJson are compatible with database
- [ ] All nullable properties have safe getters
- [ ] Use Equatable for proper comparison

### 🎨 Screens

- [ ] All const used correctly
- [ ] No deprecated functions
- [ ] All required parameters are provided
- [ ] Use `withValues()` instead of `withOpacity()`
- [ ] All events exist in the appropriate Bloc
- [ ] Error handling exists in all places

### 🔄 Bloc & Events

- [ ] All events exist in Bloc
- [ ] All states exist in Bloc
- [ ] Error handling exists in all handlers
- [ ] Use const for simple states
- [ ] All emit calls are consistent

### 🌐 Supabase Integration

- [ ] Table and column names match database
- [ ] Data types are compatible with Supabase
- [ ] RLS policies are enabled
- [ ] Use named parameters in Supabase calls
- [ ] Handle network and server errors

### 🧪 Testing

- [ ] All screens work without errors
- [ ] All events work correctly
- [ ] Error handling works
- [ ] Test Null Safety
- [ ] Test edge cases

### 🎨 UI/UX

- [ ] All colors use `withValues()` instead of `withOpacity()`
- [ ] All text supports translation (AppLocalizations)
- [ ] All icons exist and are properly colored
- [ ] Layout is responsive
- [ ] Handle loading states

### 📝 Documentation

- [ ] All complex functions have comments
- [ ] All models are documented
- [ ] All events and states are documented
- [ ] No incomplete TODOs
- [ ] Use Arabic comments for important parts

### 🔒 Security

- [ ] No secrets in code
- [ ] Permission checks exist
- [ ] Sensitive data handled securely
- [ ] Use HTTPS for communications
- [ ] Input validation exists

### ⚡ Performance

- [ ] Use const widgets where possible
- [ ] Avoid unnecessary widget rebuilds
- [ ] Use keys correctly
- [ ] Lazy load data when needed
- [ ] Avoid heavy computations in UI thread

---

## 🚀 Quick Checklist Before Commit

### Pre-Commit Checks

```bash
# 1. Run Flutter analyze
flutter analyze

# 2. Run Flutter format
flutter format .

# 3. Run tests
flutter test

# 4. Check for deprecated APIs
flutter analyze --no-fatal-infos | grep "deprecated"
```

### Git Commit Checklist

- [ ] Code follows project conventions
- [ ] All tests pass
- [ ] No lint errors
- [ ] Documentation updated
- [ ] Commit message follows conventions
- [ ] Changes are in separate commits
- [ ] No debugging code left
- [ ] No commented-out code

---

## 📊 Common Issues to Watch For

### ❌ Common Mistakes

1. **Null Safety Issues**
   ```dart
   // ❌ Bad
   Text(user.name.substring(0, 1))
   
   // ✅ Good
   Text(user.name?.firstCharSafe ?? 'U')
   ```

2. **Deprecated APIs**
   ```dart
   // ❌ Bad
   color: Colors.blue.withOpacity(0.1)
   
   // ✅ Good
   color: Colors.blue.withAlphaSafe(0.1)
   ```

3. **Dynamic Types**
   ```dart
   // ❌ Bad
   Map<String, dynamic> data
   final List<dynamic> items
   
   // ✅ Good
   Map<String, int> stats
   final List<AppointmentModel> appointments
   ```

4. **Missing Null Checks**
   ```dart
   // ❌ Bad
   Text(appointment.timeSlot)
   
   // ✅ Good
   Text(appointment.timeSlot ?? 'N/A')
   ```

5. **Const Issues**
   ```dart
   // ❌ Bad
   emit(PatientLoading())
   
   // ✅ Good
   emit(const PatientLoading())
   ```

---

## 🎯 Best Practices Summary

### ✅ DO

- Use `safe_extensions.dart` for safe data handling
- Use `const` widgets where possible
- Use `withValues()` instead of `withOpacity()`
- Handle all errors gracefully
- Write tests for critical functionality
- Document complex logic
- Follow naming conventions
- Use type-safe operations

### ❌ DON'T

- Use `dynamic` without explicit typing
- Ignore nullable values
- Use deprecated APIs
- Skip error handling
- Leave TODOs incomplete
- Use hardcoded strings for UI
- Ignore lint warnings
- Commit without testing

---

## 📞 Contact

For questions or clarifications about this checklist, contact the development team.

**Last Updated:** 2026-03-08
**Version:** 1.0.0