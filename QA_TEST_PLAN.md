# 🧪 خطة اختبار QA شاملة - مشروع MCS

**التاريخ**: مارس 9، 2026  
**المرحلة**: Post-Refactoring Testing  
**الهدف**: التأكد من أن جميع التغييرات تعمل بدون أخطاء

---

## 📋 جدول المحتويات

1. [النقاط الحرجة](#المخاطر-الحرجة)
2. [خطة الاختبار التفصيلية](#خطة-الاختبار-التفصيلية)
3. [معايير النجاح](#معايير-النجاح)
4. [الملاحظات المرحلية](#الملاحظات-المرحلية)

---

## 🔴 المخاطر الحرجة

### المخاطر التي يجب اختبارها:

| # | المخاطر | الاحتمالية | الأثر | الأولوية | الحالة |
|----|--------|----------|------|---------|--------|
| 1 | Agora Token Generation Failure | 60% | عالي جداً | 🔴 حرج | ⏳ معلق |
| 2 | Session State Inconsistency (Logout) | 40% | عالي | 🔴 حرج | ⏳ معلق |
| 3 | FCM Token Missing (Notifications) | 50% | عالي | 🔴 حرج | ⏳ معلق |
| 4 | Undefined Routes | 30% | متوسط | 🟡 عادي | ⏳ معلق |
| 5 | BuildContext Crashes | 20% | متوسط | 🟡 عادي | ⏳ معلق |
| 6 | Performance Degradation | 40% | متوسط | 🟡 عادي | ⏳ معلق |

---

## 🧪 خطة الاختبار التفصيلية

### 1️⃣ Agora Token Generation Tests

**السيناريو 1**: توليد token بنجاح
```
الخطوات:
1. اختبر مستقيماً عن طريق Unit Tests
2. تحقق من أن الـ token يتم توليده بنجاح
3. تحقق من أن الـ token ليس فارغاً

النتيجة المتوقعة: ✅ Token returned successfully
```

**السيناريو 2**: فشل توليد الـ token
```
الخطوات:
1. محاكاة فشل الـ API
2. تحقق من معالجة الخطأ
3. تحقق من retry logic

النتيجة المتوقعة: ✅ Proper error handling + Retry
```

**السيناريو 3**: Timeout
```
الخطوات:
1. محاكاة timeout (> 10 ثوان)
2. تحقق من exponential backoff
3. تحقق من max retries

النتيجة المتوقعة: ✅ Timeout handled + Retries with delay
```

---

### 2️⃣ Session State Consistency Tests (Logout)

**السيناريو 1**: Logout كامل
```
الخطوات:
1. اختبر تسجيل دخول
2. اختبر تسجيل خروج
3. تحقق من:
   - ✓ Supabase session cleared
   - ✓ Local storage cleared
   - ✓ Secure storage cleared
   - ✓ Cache invalidated
   - ✓ User == null

النتيجة المتوقعة: ✅ Complete cleanup
```

**السيناريو 2**: محاولة الوصول بعد الخروج
```
الخطوات:
1. تسجيل خروج
2. محاولة الوصول للـ private screens
3. تحقق من redirect إلى login

النتيجة المتوقعة: ✅ Redirected to login
```

**السيناريو 3**: Logout عند الفشل
```
الخطوات:
1. محاكاة فشل في الـ logout process
2. تحقق من rollback

النتيجة المتوقعة: ✅ State rolled back
```

---

### 3️⃣ FCM Token Tests (Notifications)

**السيناريو 1**: إرسال notification بنجاح
```
الخطوات:
1. تحقق من وجود FCM token
2. أرسل notification
3. تحقق من الاستقبال

النتيجة المتوقعة: ✅ Notification received
```

**السيناريو 2**: FCM Token مفقود
```
الخطوات:
1. أزل FCM token من DB
2. حاول إرسال notification
3. تحقق من الخطأ

النتيجة المتوقعة: ✅ Error: Token missing
```

**السيناريو 3**: Token معطل/منتهي
```
الخطوات:
1. استخدم token قديم
2. حاول الإرسال
3. تحقق من Auto-refresh

النتيجة المتوقعة: ✅ Auto-refreshed or Error
```

---

### 4️⃣ Navigation Tests (Routes)

**السيناريو 1**: Navigation من Dashboard
```
الخطوات:
1. من Employee Dashboard
2. اختبر كل navigation items:
   - ✓ Inventory
   - ✓ Invoices
   - ✓ Settings

النتيجة المتوقعة: ✅ All routes work
```

**السيناريو 2**: Deep Linking
```
الخطوات:
1. جرّب appointment details link
2. جرّب reschedule link
3. تحقق من parameter passing

النتيجة المتوقعة: ✅ Links work + Parameters passed
```

---

### 5️⃣ BuildContext Safety Tests

**السيناريو 1**: Settings screen after async
```
الخطوات:
1. افتح Settings screen
2. انقر Logout
3. انتظر 1 ثانية
4. تحقق من عدم crash

النتيجة المتوقعة: ✅ No crash + Proper message
```

**السيناريو 2**: Widget unmount
```
الخطوات:
1. افتح screen
2. اتركه (navigate away)
3. حرّك العملية الـ async
4. تحقق من mounted check

النتيجة المتوقعة: ✅ No crash
```

---

### 6️⃣ Performance Tests

**السيناريو 1**: Landing page rendering
```
الخطوات:
1. قس build time medical_crescent_logo
2. قس rendering time

النتيجة المتوقعة: ✅ < 100ms
```

**السيناريو 2**: Dashboard loading
```
الخطوات:
1. قس startup time
2. قس data loading time

النتيجة المتوقعة: ✅ < 2 seconds total
```

---

## ✅ معايير النجاح

### لن نعتبر الاختبار كامل إلا إذا:

```
من الضروري:
✅ 0 Lint warnings (flutter analyze)
✅ جميع Unit tests تمر
✅ جميع Widget tests تمر
✅ لا توجد crashes
✅ Authentication يعمل بدون مشاكل

مهم:
✅ Performance مقبول (< 3 حوانب للـ startup)
✅ Navigation يعمل بدون مشاكل
✅ Notifications تصل بنجاح

اختياري:
✅ Offline mode يعمل
✅ Network resilience جيدة
```

---

## 📝 الملاحظات المرحلية

### الآن (مارس 9):
- [ ] قراءة التقارير ✅
- [ ] إعداد خطة الاختبار ✅
- [ ] الانتظار لتطبيق التغييرات

### بعد تطبيق التغييرات:
- [ ] تشغيل flutter analyze
- [ ] تشغيل flutter test
- [ ] اختبار يدوي
- [ ] توثيق النتائج

---

## 🎯 الحالة الحالية

**جاري الانتظار**: انتظار تطبيق التغييرات من فريق التطوير...

---

**آخر تحديث**: مارس 9، 2026  
**الحالة**: ⏳ في الانتظار للبدء
