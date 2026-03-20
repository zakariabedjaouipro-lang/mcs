# 📋 نظام إدارة الأدوار المتدرج (Role Management System)

## 🎯 نظرة عامة

نظام متطور لإدارة الأدوار والصلاحيات بطريقة متدرجة، حيث يمكن لكل مستوى من المسؤولين إضافة مستخدمين بأدوار محددة.

---

## 🏗️ بنية النظام

### الأدوار والمستويات

```
┌─────────────────────────────────────────────────────┐
│                  Super Admin                        │
│         (نظام متحكم - يدوياً من Supabase)          │
│  • التحكم الكامل بالنظام                            │
│  • إضافة Clinic Admins                            │
│  • إدارة جميع العيادات                             │
└────────────────────────┬────────────────────────────┘
                         │
                    (يضيف)
                         │
                         ▼
┌─────────────────────────────────────────────────────┐
│              Clinic Admin                           │
│         (يدير عيادة واحدة)                          │
│  • إضافة الموظفين (Doctor, Nurse, إلخ)          │
│  • إدارة الموظفين                                  │
│  • عرض الإحصائيات                                  │
└────────────────────────┬────────────────────────────┘
                         │
                    (يستدعي)
                         │
                         ▼
┌──────────────────────────────────────────────────────┐
│           Clinic Staff (الموظفون)                   │
│  - Doctor (طبيب)                                   │
│  - Nurse (ممرضة)                                   │
│  - Receptionist (موظفة استقبال)                   │
│  - Pharmacist (صيدلاني)                            │
│  - Lab Technician (فني مختبر)                     │
│  - Radiographer (أخصائي أشعة)                     │
│  • إمكانية محدودة                                   │
│  • يعملون تحت إشراف Clinic Admin                  │
└──────────────────────────────────────────────────────┘

                         │
                    (عام)
                         │
                         ▼
┌──────────────────────────────────────────────────────┐
│           Public Roles (أدوار عامة)                 │
│  - Patient (مريض) - تسجيل ذاتي فوري             │
│  - Relative (قريب) - تسجيل ذاتي فوري              │
│  • لا يتطلب موافقة                                  │
│  • موافقة فورية                                     │
└──────────────────────────────────────────────────────┘
```

---

## 🔑 المفاهيم الأساسية

### 1. **الأدوار المتاحة** (`RoleManagementUtils`)

#### أدوار عامة (Public Roles)
```dart
// متاحة للتسجيل الذاتي العام
- Patient: مريض ✅ موافقة فورية
- Relative: قريب ✅ موافقة فورية
```

#### أدوار موظفي العيادة (Clinic Staff)
```dart
// يتطلب دعوة من Clinic Admin
// معرّف عيادة مطلوب
- Doctor: طبيب ⏳ بانتظار الموافقة
- Nurse: ممرضة ⏳ بانتظار الموافقة
- Receptionist: موظفة استقبال ⏳ بانتظار الموافقة
- Pharmacist: صيدلاني ⏳ بانتظار الموافقة
- Lab Technician: فني مختبر ⏳ بانتظار الموافقة
- Radiographer: أخصائي أشعة ⏳ بانتظار الموافقة
```

#### أدوار المسؤولين (Admin Roles)
```dart
// يتطلب موافقة من Super Admin
// معرّف عيادة مطلوب
- Clinic Admin: مدير عيادة ⏳ بانتظار الموافقة
```

---

## 📱 التدفق الكامل للمستخدم

### 1️⃣ التسجيل العام (Public Registration)

**شاشة:** `premium_register_screen.dart`

```
┌─────────────────────────────────────┐
│  المستخدم ينقر على "إنشاء حساب"     │
└────────────┬────────────────────────┘
             │
             ▼
┌─────────────────────────────────────┐
│  الخطوة 1: اختيار الدور              │
│  (Patient, Relative)                 │
│  يعرض فقط: publicRoles             │
└────────────┬────────────────────────┘
             │
             ▼
┌─────────────────────────────────────┐
│  الخطوة 2: البيانات الأساسية        │
│  - الاسم                             │
│  - البريد                            │
│  - الهاتف                            │
└────────────┬────────────────────────┘
             │
             ▼
┌─────────────────────────────────────┐
│  الخطوة 3: كلمة المرور               │
└────────────┬────────────────────────┘
             │
             ▼
┌─────────────────────────────────────┐
│  signUpWithEmail()                   │
│  - clinicId = null (بدون عيادة)    │
│  - approvalStatus = 'approved'      │
│  (موافقة فورية للمرضى)              │
└────────────┬────────────────────────┘
             │
             ▼
┌─────────────────────────────────────┐
│  ✅ حساب نشط فوراً                   │
│  يمكن الدخول مباشرة                  │
└─────────────────────────────────────┘
```

### 2️⃣ استدعاء الموظفين (Staff Invitation)

**شاشة:** `invite_staff_member_screen.dart`

```
┌─────────────────────────────────────────┐
│  Clinic Admin ينقر "إضافة موظف"       │
└────────────┬────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────┐
│  شاشة الاستدعاء                         │
│  - اسم الموظف                          │
│  - البريد الإلكتروني                    │
│  - الدور (Doctor, Nurse, إلخ)        │
│  يعرض فقط: clinicStaffRoles          │
└────────────┬────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────┐
│  إرسال الدعوة                           │
│  1. حفظ في staff_invitations         │
│  2. إرسال بريد إلكتروني مع رابط      │
│  - status = 'pending'                 │
│  - clinic_id محفوظ                    │
└────────────┬────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────┐
│  الموظف يتلقى البريد                     │
│  ينقر على رابط الدعوة                   │
└────────────┬────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────┐
│  signUpWithEmail()                      │
│  - clinicId = من الدعوة              │
│  - approvalStatus = 'pending'         │
│  (بانتظار موافقة Clinic Admin)      │
└────────────┬────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────┐
│  ✅ حساب مُنشأ (بانتظار الموافقة)   │
│  لا يمكن الدخول حتى الموافقة            │
└─────────────────────────────────────────┘
```

---

## 🔐 قاعدة البيانات

### جدول `auth.users` (Supabase)

```sql
id UUID PRIMARY KEY
email VARCHAR UNIQUE
role user_role DEFAULT 'patient'
metadata JSONB
  ├── fullName: string
  ├── phone: string
  ├── clinicId: UUID (nullable)
  ├── approvalStatus: 'approved' | 'pending'
  └── registrationType: 'email' | 'google' | 'facebook'
```

### جدول `user_approvals`

```sql
id UUID PRIMARY KEY
user_id UUID REFERENCES auth.users
email VARCHAR
full_name VARCHAR
role user_role
clinic_id UUID (nullable)
registration_type VARCHAR
status 'pending' | 'approved' | 'rejected'
created_at TIMESTAMP
```

### جدول `staff_invitations` (جديد)

```sql
id UUID PRIMARY KEY
clinic_id UUID REFERENCES clinics
invited_by UUID REFERENCES auth.users (admin)
email VARCHAR
full_name VARCHAR
role user_role
status 'pending' | 'accepted' | 'expired'
created_at TIMESTAMP
accepted_at TIMESTAMP (nullable)
```

---

## 🛠️ الملفات الرئيسية

### 1. **`role_management_utils.dart`**

Utility class يحتوي على جميع منطق إدارة الأدوار:

```dart
// الحصول على الأدوار المتاحة
List<RoleOption> getAvailableRoles({
  required String currentUserRole,
  bool isPublicRegistration = true,
})

// التحقق من أن الدور يتطلب معرّف عيادة
bool roleRequiresClinicId(String role)

// تحديد حالة الموافقة بناءً على الدور
String getApprovalStatusForRole(String role)

// التحقق من صلاحية التعيين
bool canAssignRole({
  required String currentUserRole,
  required String targetRole,
})
```

### 2. **`auth_service.dart`**

تحديث `signUpWithEmail` لدعم `clinicId`:

```dart
Future<AuthResponse> signUpWithEmail({
  required String email,
  required String password,
  Map<String, dynamic>? metadata,
  String? clinicId,  // ✅ جديد
}) async {
  // إضافة clinicId إلى metadata
  final finalMetadata = {
    ...?metadata,
    if (clinicId != null) 'clinicId': clinicId,
  };
  // ...
}
```

### 3. **`premium_register_screen.dart`**

تحديث شاشة التسجيل:

```dart
// ✅ استخدام RoleManagementUtils
List<RoleOption> get _availableRoles {
  return RoleManagementUtils.getAvailableRoles(
    currentUserRole: '',
    isPublicRegistration: _isPublicRegistration,
  );
}

// ✅ تحديد حالة الموافقة تلقائياً
final approvalStatus =
    RoleManagementUtils.getApprovalStatusForRole(_selectedRole);
```

### 4. **`invite_staff_member_screen.dart`**

شاشة استدعاء الموظفين:

```dart
// ✅ يعرض فقط clinicStaffRoles
late final List<RoleOption> _availableRoles =
    RoleManagementUtils.clinicStaffRoles;

// ✅ إرسال الدعوة
Future<void> _handleInviteStaffMember() async {
  // 1. حفظ في staff_invitations
  await client.from('staff_invitations').insert({
    'clinic_id': widget.clinicId,
    'role': _selectedRole,
    'status': 'pending',
  });
  
  // 2. إرسال بريد إلكتروني
  await client.functions.invoke('send-staff-invitation', body: {...});
}
```

---

## 🔄 التدفق الكامل للموافقة

### السيناريو 1: مريض (Patient)

```
التسجيل
  │
  ├─ Role: 'patient'
  ├─ clinicId: null
  ├─ approvalStatus: 'approved'
  │
  ▼
✅ يمكنه الدخول فوراً
```

### السيناريو 2: موظف عن طريق دعوة

```
Clinic Admin يرسل دعوة
  │
  ├─ الموظف يتلقى بريد مع رابط فريد
  │
  ▼
الموظف ينقر على الرابط
  │
  ├─ signUpWithEmail(
  │   clinicId: من_الدعوة,
  │   role: من_الدعوة,
  │   approvalStatus: 'pending'
  │ )
  │
  ▼
حساب مُنشأ (بانتظار الموافقة)
  │
  ├─ Clinic Admin يوافق
  │
  ▼
✅ يمكنه الدخول
```

### السيناريو 3: Clinic Admin (من Super Admin)

```
Super Admin ينشئ Clinic Admin يدوياً
  │
  ├─ Role: 'clinic_admin'
  ├─ clinicId: معرّف_العيادة
  ├─ approvalStatus: 'pending'
  │
  ▼
Super Admin يوافق
  │
  ▼
✅ Clinic Admin نشط يمكنه إضافة موظفين
```

---

## 📊 مثال عملي

### 1. مريض ينسجل ذاتياً

```dart
// شاشة التسجيل العام
signUpWithEmail(
  email: 'patient@example.com',
  password: '12345678',
  clinicId: null,  // بدون عيادة
  metadata: {
    'fullName': 'أحمد محمد',
    'phone': '20-1234567890',
    'role': 'patient',
    'approvalStatus': 'approved',  // موافقة فورية
  }
)
```

### 2. Clinic Admin يضيف طبيباً

```dart
// شاشة الاستدعاء للموظفين
// الخطوة 1: إرسال دعوة
staff_invitations.insert({
  'clinic_id': 'clinic-123',
  'invited_by': 'admin-user-456',
  'email': 'doctor@example.com',
  'role': 'doctor',
  'status': 'pending',
})

// الخطوة 2: الطبيب يتلقى بريد + يسجل
signUpWithEmail(
  email: 'doctor@example.com',
  password: '12345678',
  clinicId: 'clinic-123',  // من الدعوة
  metadata: {
    'fullName': 'د. فاطمة علي',
    'phone': '20-9876543210',
    'role': 'doctor',
    'approvalStatus': 'pending',  // بانتظار الموافقة
  }
)

// الخطوة 3: Clinic Admin يوافق
// (يتم في لوحة التحكم)
user_approvals.update({
  'status': 'approved'
})
```

---

## ✅ الفوائد

✅ **أمان عالي**: كل دور له صلاحيات محددة  
✅ **سهولة الإدارة**: واجهة سهلة لإضافة الموظفين  
✅ **مرونة**: دعم أدوار متعددة  
✅ **قابلية التوسع**: يمكن إضافة أدوار جديدة بسهولة  
✅ **تتبع مركزي**: كل الدعوات محفوظة في القاعدة  
✅ **إشعارات**: بريد إلكتروني تلقائي للموظفين الجدد

---

## 🚀 الخطوات التالية

1. ✅ إنشاء جداول في Supabase (`staff_invitations`)
2. ✅ إنشاء Edge Function لإرسال البريد الإلكتروني
3. ⏳ اختبار التدفق الكامل
4. ⏳ إضافة صفحة قبول الدعوة
5. ⏳ تحديث لوحة تحكم Clinic Admin

---

## 📞 للمساعدة

راجع:
- `lib/core/utils/role_management_utils.dart`
- `lib/features/auth/screens/premium_register_screen.dart`
- `lib/features/clinic/presentation/screens/invite_staff_member_screen.dart`
- `lib/core/services/auth_service.dart`
