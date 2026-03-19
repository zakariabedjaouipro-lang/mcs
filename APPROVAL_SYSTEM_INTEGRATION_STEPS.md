# خطوات التكامل العملية - نظام الموافقة
## Practical Integration Steps - Approval System

---

## 📌 الخطوة 1: إضافة المسار في GoRouter

**الملف:** `lib/core/config/app_routes.dart` (أو `go_router_config.dart`)

```dart
import 'package:go_router/go_router.dart';
import 'package:mcs/features/auth/presentation/screens/pending_approvals_screen.dart';

final appRouter = GoRouter(
  routes: [
    // ... المسارات الأخرى ...
    
    // ✅ أضف هذا المسار
    GoRoute(
      path: '/admin/approvals',
      name: 'pending-approvals',
      pageBuilder: (context, state) => MaterialPage(
        child: const PendingApprovalsScreen(),
      ),
    ),
    
    // مسار آخر للوحة التحكم
    GoRoute(
      path: '/admin/dashboard',
      name: 'admin-dashboard',
      pageBuilder: (context, state) => MaterialPage(
        child: const AdminDashboard(),
      ),
    ),
  ],
);
```

---

## 📌 الخطوة 2: إضافة زر في لوحة التحكم

**الملف:** `lib/features/admin/presentation/screens/admin_dashboard.dart`

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'لوحة التحكم' : 'Admin Dashboard'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // ✅ أضف هذا البطاقة/الزر
          Card(
            child: ListTile(
              leading: Icon(Icons.approval, color: Colors.blue),
              title: Text(
                isArabic ? 'طلبات الموافقة المعلقة' : 'Pending Approvals',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                isArabic 
                  ? 'الموافقة أو رفض طلبات التسجيل الجديدة'
                  : 'Approve or reject new registration requests',
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // انتقل إلى صفحة الموافقات
                context.push('/admin/approvals');
              },
            ),
          ),
          SizedBox(height: 16),
          
          // باقي عناصر لوحة التحكم
          Card(
            child: ListTile(
              leading: Icon(Icons.people),
              title: Text(isArabic ? 'المستخدمون' : 'Users'),
              onTap: () => context.push('/admin/users'),
            ),
          ),
          // ...
        ],
      ),
    );
  }
}
```

---

## 📌 الخطوة 3: إضافة شارات العدد (Badge)

**الملف:** `lib/features/admin/presentation/screens/admin_dashboard.dart`

```dart
// في بناء واجهة لوحة التحكم، استخدم BLoC لعداد الطلبات

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AdvancedAuthBloc, AdvancedAuthState>(
        builder: (context, state) {
          int pendingCount = 0;
          
          if (state is PendingRegistrationRequestsLoaded) {
            pendingCount = state.requests.length;
          }
          
          return ListView(
            children: [
              // ✅ أضف شارة العدد
              Card(
                child: Stack(
                  children: [
                    ListTile(
                      leading: Icon(Icons.approval),
                      title: Text('طلبات الموافقة'),
                      onTap: () => context.push('/admin/approvals'),
                    ),
                    // الشارة
                    if (pendingCount > 0)
                      Positioned(
                        right: 16,
                        top: 4,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$pendingCount',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

---

## 📌 الخطوة 4: التعامل مع Bloc Events

**الملف:** `lib/features/auth/presentation/bloc/advanced_auth_bloc.dart`

```dart
// تم فعلاً تنفيذ هذه الأحداث:

// 1. تحميل الطلبات المعلقة
LoadPendingRegistrationRequestsRequested()

// 2. الموافقة على الطلب
RegistrationRequestApprovalSubmitted(
  requestId: 'request-123',
  approverUserId: 'admin-456',
)

// 3. رفض الطلب
RegistrationRequestRejectionSubmitted(
  requestId: 'request-123',
  approverUserId: 'admin-456',
  rejectionReason: 'البيانات غير صحيحة',
)
```

---

## 📌 الخطوة 5: رسالة الحالة في صفحة التسجيل

**الملف:** `lib/features/auth/presentation/screens/role_based_registration_screen.dart`

```dart
class RoleBasedRegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return BlocConsumer<AdvancedAuthBloc, AdvancedAuthState>(
      listener: (context, state) {
        if (state is RoleBasedRegistrationSuccess) {
          // ✅ تحقق من حالة الموافقة
          if (state.pendingApproval) {
            // اعرض رسالة الانتظار
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isArabic
                      ? 'تم تسجيل البيانات بنجاح!\nفي انتظار موافقة المسؤول'
                      : 'Registration successful!\nPending admin approval',
                ),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 5),
              ),
            );
            
            // بقاء في الشاشة الحالية أو عرض صفحة انتظار
            Future.delayed(Duration(seconds: 3), () {
              // انتقل إلى صفحة الانتظار أو الرئيسية
              if (context.mounted) {
                context.go('/waiting-approval');
              }
            });
          } else {
            // لا موافقة مطلوبة - يمكن الدخول فوراً
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isArabic
                      ? 'تم تفعيل حسابك بنجاح'
                      : 'Your account is now active',
                ),
                backgroundColor: Colors.green,
              ),
            );
            
            // انتقل إلى لوحة التحكم
            Future.delayed(Duration(seconds: 2), () {
              if (context.mounted) {
                context.go('/dashboard');
              }
            });
          }
        } else if (state is RoleBasedRegistrationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is AdvancedAuthLoading) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(isArabic ? 'التسجيل' : 'Registration'),
          ),
          body: // ... بناء نموذج التسجيل
        );
      },
    );
  }
}
```

---

## 📌 الخطوة 6: صفحة الانتظار (اختياري)

**الملف:** `lib/features/auth/presentation/screens/waiting_approval_screen.dart`

```dart
class WaitingApprovalScreen extends StatefulWidget {
  final String userEmail;
  final String roleName;

  const WaitingApprovalScreen({
    required this.userEmail,
    required this.roleName,
  });

  @override
  State<WaitingApprovalScreen> createState() => _WaitingApprovalScreenState();
}

class _WaitingApprovalScreenState extends State<WaitingApprovalScreen> {
  @override
  void initState() {
    super.initState();
    // تحقق من حالة الطلب كل دقيقة
    Timer.periodic(Duration(minutes: 1), (timer) {
      _authBloc.add(
        CheckUserRegistrationRequestStatus(
          userId: _getCurrentUserId(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isArabic ? 'في انتظار الموافقة' : 'Waiting for Approval',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // رسم توضيحي متحرك
            Transform.rotate(
              angle: _animationController.value * 2 * 3.14,
              child: Icon(
                Icons.hourglass_bottom,
                size: 64,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 32),
            Text(
              isArabic
                  ? 'جاري معالجة طلبك'
                  : 'Processing your request',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              isArabic
                  ? 'سيتم إرسال بريد إليك عند الموافقة'
                  : 'You will receive an email when approved',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic ? 'بيانات الطلب:' : 'Request Details:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('📧 ${widget.userEmail}'),
                  Text(
                    isArabic
                        ? '🏷️  الدور: ${widget.roleName}'
                        : '🏷️  Role: ${widget.roleName}',
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                context.go('/dashboard');
              },
              child: Text(isArabic ? 'العودة' : 'Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 📧 الخطوة 7: إعدادات البريد الإلكتروني

**الملف:** `lib/core/services/approval_notification_service.dart`

تأكد من إعدادات البريد:

```dart
// قم بتحديث بيانات الاتصال بخدمة البريد
class ApprovalNotificationService {
  // استخدم Supabase Edge Function
  final String edgeFunctionUrl = 'https://your-project.supabase.co/functions/v1/send-approval-email';
  
  // أو استخدم SMTP مباشرة
  final String smtpServer = 'smtp.gmail.com';
  final int smtpPort = 587;
  final String senderEmail = 'noreply@clinic.com';
  // ...أضف كلمة المرور أو API key
}
```

---

## 🧪 الخطوة 8: اختبار النظام

### اختبار 1️⃣: تسجيل طبيب والموافقة عليه

```
1. افتح التطبيق
2. اختر "التسجيل" → "طبيب"
3. أدخل البيانات:
   - البريد: test@clinic.com
   - الكلمة المرور: Test@123456
   - الاسم: محمد أحمد
   - الهاتف: +201234567890
4. اضغط "تسجيل"
5. ستظهر رسالة: "في انتظار الموافقة"
6. تسجيل دخول بحساب المسؤول
7. اذهب إلى "لوحة التحكم" → "طلبات الموافقة"
8. اضغط "موافقة"
9. تحقق من البريد الخاص بالطبيب - يجب أن يستقبل بريد تأكيد
```

### اختبار 2️⃣: تسجيل مريض (فوري)

```
1. افتح التطبيق
2. اختر "التسجيل" → "مريض"
3. أدخل البيانات
4. اضغط "تسجيل"
5. سيتم تفعيل الحساب فوراً
6. يستطيع تسجيل الدخول مباشرة
```

### اختبار 3️⃣: رفض طلب

```
1. سجل حساب طبيب جديد
2. من حساب المسؤول، اذهب للموافقات
3. اضغط "رفض"
4. أدخل السبب: "البيانات غير صحيحة"
5. اضغط "رفض"
6. تحقق من البريد الخاص بالطبيب - يجب أن يستقبل بريد رفض
```

---

## 🔒 نقاط الأمان المهمة

```dart
// ✅ تحقق من الدور قبل السماح بالوصول إلى صفحة الموافقات

bool canAccessApprovals(UserProfileModel user) {
  return user.role == 'super_admin' || 
         user.role == 'admin' || 
         user.permissions.contains('approve_registrations');
}

// ✅ استخدم نفس معرف المستخدم للموافقة

_authBloc.add(
  RegistrationRequestApprovalSubmitted(
    requestId: request.id,
    approverUserId: currentUser.id, // ليس 'current_user_id'
  ),
);

// ✅ تحقق من صحة البيانات قبل الحفظ

if (rejectionReason.trim().isEmpty) {
  showError('سبب الرفض مطلوب');
  return;
}
```

---

## 📱 فحص النتائج

بعد إكمال جميع الخطوات، ستكون النتائج:

- ✅ صفحة موافقات تعمل
- ✅ طلبات تحميل من قاعدة البيانات
- ✅ موافقة ورفض يعملان
- ✅ بريد إلكتروني يصل للمستخدمين
- ✅ حالة تحديث فوري
- ✅ لوحة تحكم محدثة مع العدادات

---

## 🚨 حل المشاكل

| المشكلة | الحل |
|--------|------|
| **الطلبات لا تحمل** | تحقق من `LoadPendingRegistrationRequestsRequested` في BLoC |
| **البريد لا يصل** | تحقق من إعدادات Supabase Edge Function |
| **الموافقة لا تعمل** | تحقق من معرف المستخدم `approverUserId` |
| **الصفحة لا تظهر** | تأكد من إضافة المسار في GoRouter |
| **لا توجد شارات** | تحقق من عداد الطلبات في BLoC |

---

## ✨ خطوات إضافية موصى بها

1. 📊 **إضافة إحصائيات**
   - عدد الطلبات المعلقة
   - عدد الموافقات اليومية
   - عدد الرفضات

2. 🔔 **إشعارات فورية**
   - استخدم Firebase Cloud Messaging
   - نبه المسؤول عند طلب جديد

3. 📋 **تصفية وترتيب**
   - رتب حسب التاريخ
   - صفف حسب الدور
   - ابحث من خلال البريد

4. 📸 **التحقق من الملفات**
   - طلب المستندات
   - عرض شهادات التخرج
   - التحقق من الصور

---

