# 🔐 حسابات التجريب | Demo Accounts

## إنشاء حسابات التجريب | Creating Demo Accounts

لإنشاء حسابات التجريب، قم بتشغيل الأمر التالي:

To create demo accounts, run:

```bash
dart run create_demo_accounts.dart
```

---

## حسابات متاحة | Available Accounts

| الدور | Role | البريد الإلكتروني | Email | كلمة المرور | Password | الوصف | Description |
|-------|------|-------------------|-------|-------------|----------|---------|-------------|
| 👨‍⚕️ طبيب | Doctor | `doctor@demo.com` | doctor@demo.com | `Demo@123456` | Demo@123456 | حساب الطبيب | Doctor Account |
| 🏥 مريض | Patient | `patient@demo.com` | patient@demo.com | `Demo@123456` | Demo@123456 | حساب المريض | Patient Account |
| ⚙️ مسؤول | Admin | `admin@demo.com` | admin@demo.com | `Demo@123456` | Demo@123456 | مسؤول العيادة | Clinic Admin |
| 👑 مسؤول أساسي | Super Admin | `superadmin@demo.com` | superadmin@demo.com | `Demo@123456` | Demo@123456 | المسؤول الأساسي | Super Admin |
| 👨‍💼 موظف | Staff | `staff@demo.com` | staff@demo.com | `Demo@123456` | Demo@123456 | حساب الموظف | Staff Account |

---

## الأدوار والصلاحيات | Roles & Permissions

### 👨‍⚕️ طبيب (Doctor)
- عرض بيانات المرضى المسندة
- إنشاء ومراجعة الوصفات الطبية
- إدارة الفحوصات والنتائج
- الإجابة على استفسارات المرضى

### 🏥 مريض (Patient)
- عرض بيانات صحتهم الشخصية
- حجز وإدارة المواعيد
- عرض الوصفات الطبية
- التواصل مع الأطباء

### ⚙️ مسؤول (Clinic Admin)
- إدارة شاملة للعيادة
- إدارة الموظفين والأطباء
- إدارة المريضين
- إدارة الفواتير والاشتراكات

### 👑 مسؤول أساسي (Super Admin)
- تحكم كامل في النظام
- إدارة جميع العيادات
- إدارة الإعدادات النظام
- الموافقة على الحسابات الجديدة

### 👨‍💼 موظف (Staff)
- إدارة المخزون
- معالجة الفواتير
- تنظيم المواعيد
- دعم العملاء

---

## ملاحظات أمان | Security Notes

⚠️ **هام**: هذه الحسابات **للاختبار فقط** ولا يجب استخدامها في الإنتاج.

⚠️ **Important**: These accounts are **for testing only** and should not be used in production.

---

## استكشاف الأخطاء | Troubleshooting

### الخطأ: "البريد الإلكتروني موجود بالفعل"
**الحل**: قم بحذف الحساب من Supabase أولاً ثم أعد التشغيل

### Error: "Email already exists"
**Solution**: Delete the account from Supabase first, then retry

### الخطأ: فشل الاتصال بـ Supabase
**الحل**: تأكد من أن المفاتيح صحيحة وأن الإنترنت متصل

### Error: Failed to connect to Supabase
**Solution**: Verify that keys are correct and internet is connected

---

## الخطوات التالية | Next Steps

1. ✅ شغّل `create_demo_accounts.dart`
2. ✅ استخدم الحسابات المدرجة أعلاه للدخول
3. ✅ اختبر كل دور والفعاليات الخاصة به
4. ✅ حذّر جميع الحسابات قبل الإطلاق الفعلي

1. ✅ Run `create_demo_accounts.dart`
2. ✅ Use the accounts listed above to login
3. ✅ Test each role and its features
4. ✅ Remove all accounts before production launch
