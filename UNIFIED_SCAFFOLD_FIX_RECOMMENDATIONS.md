# 🛠️ توصيات الإصلاح - نظام الواجهة الموحدة

**الهدف**: توحيد جميع صفحات التطبيق لاستخدام `UnifiedAppScaffold`

---

## 📋 قائمة الإصلاحات المطلوبة

### المرحلة 1: تحديث الـ 7 Dashboards المتبقية (أولوية عالية)

#### 1. Nurse Dashboard
**الملف**: `lib/features/nurse/presentation/screens/nurse_dashboard.dart`

**الحالة الحالية**: يستخدم Scaffold + BLoC + TabController

**الإصلاح المقترح**:
```dart
// استبدل Scaffold بـ UnifiedAppScaffold
return UnifiedAppScaffold(
  title: isArabic ? 'لوحة تحكم الممرض' : 'Nurse Dashboard',
  userRole: 'Nurse',
  body: _buildNurseDashboardContent(context),
  userData: AppScaffoldUserData(
    name: 'أم. محمد علي',
    email: 'nurse@clinic.com',
    role: 'Nurse',
    avatarUrl: null,
  ),
  drawerItems: _buildNurseDrawerItems(isArabic),
  accentColor: Colors.teal, // اللون المناسب للممرض
  // ... باقي الخصائص
);
```

---

#### 2. Receptionist Dashboard
**الملف**: `lib/features/receptionist/presentation/screens/receptionist_dashboard.dart`

**الحالة الحالية**: Scaffold بسيط

**الإصلاح**:
```dart
return UnifiedAppScaffold(
  title: isArabic ? 'لوحة تحكم الاستقبال' : 'Receptionist Dashboard',
  userRole: 'Receptionist',
  body: _buildReceptionistContent(context),
  accentColor: Colors.orange,
);
```

---

#### 3. Pharmacist Dashboard
**الملف**: `lib/features/pharmacist/presentation/screens/pharmacist_dashboard.dart`

**الإصلاح**:
```dart
return UnifiedAppScaffold(
  title: isArabic ? 'لوحة تحكم الصيدلية' : 'Pharmacist Dashboard',
  userRole: 'Pharmacist',
  body: _buildPharmacistContent(context),
  accentColor: Colors.green,
);
```

---

#### 4. Lab Technician Dashboard
**الملف**: `lib/features/lab/presentation/screens/lab_technician_dashboard.dart`

**الإصلاح**:
```dart
return UnifiedAppScaffold(
  title: isArabic ? 'لوحة تحكم المختبر' : 'Lab Technician Dashboard',
  userRole: 'Lab Technician',
  body: _buildLabTechnicianContent(context),
  accentColor: Colors.cyan,
);
```

---

#### 5. Radiographer Dashboard
**الملف**: `lib/features/radiology/presentation/screens/radiographer_dashboard.dart`

**الإصلاح**:
```dart
return UnifiedAppScaffold(
  title: isArabic ? 'لوحة تحكم الأشعات' : 'Radiographer Dashboard',
  userRole: 'Radiographer',
  body: _buildRadiographerContent(context),
  accentColor: Colors.amber,
);
```

---

#### 6. Clinic Admin Dashboard
**الملف**: `lib/features/clinic/presentation/screens/clinic_dashboard.dart`

**الإصلاح**:
```dart
return UnifiedAppScaffold(
  title: isArabic ? 'لوحة تحكم مدير العيادة' : 'Clinic Admin Dashboard',
  userRole: 'Clinic Admin',
  body: _buildClinicAdminContent(context),
  accentColor: Colors.indigo,
);
```

---

#### 7. Relative Home Screen
**الملف**: `lib/features/relative/presentation/screens/relative_home_screen.dart`

**الإصلاح**:
```dart
return UnifiedAppScaffold(
  title: isArabic ? 'الصفحة الرئيسية' : 'Home',
  userRole: 'Relative',
  body: _buildRelativeHomeContent(context),
  accentColor: Colors.brown,
);
```

---

### المرحلة 2: تحديث الشاشات الموحدة (أولوية عالية)

#### 1. Settings Screen
**الملف**: `lib/features/settings/presentation/screens/settings_screen.dart`

**الحالة الحالية**: 
```dart
return Scaffold(
  appBar: AppBar(...),
  body: SingleChildScrollView(...),
);
```

**الإصلاح المقترح**:
```dart
class SettingsScreen extends StatefulWidget {
  final String? currentRole;  // إضافة الدور
  const SettingsScreen({this.isPremium = false, this.currentRole, super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

// في البناء:
return UnifiedAppScaffold(
  title: isArabic ? 'الإعدادات' : 'Settings',
  userRole: currentRole ?? 'User',
  body: _buildSettingsContent(context),
  drawerItems: _buildSettingsDrawerItems(isArabic),
  accentColor: CustomIcons.getRoleColor(currentRole ?? 'User'),
);
```

---

#### 2. Appointments Screen
**الملف**: `lib/features/appointment/presentation/screens/appointments_screen.dart`

**الحالة الحالية**: 
```dart
return Scaffold(
  appBar: AppBar(...),
  body: TabBarView(...),
);
```

**الإصلاح المقترح**:
```dart
class AppointmentsScreen extends StatefulWidget {
  final String? role;  // إضافة الدور
  final String? userId;  // اختياري
  const AppointmentsScreen({
    this.isPremium = false,
    this.role,
    this.userId,
    super.key,
  });

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

// في البناء:
return UnifiedAppScaffold(
  title: isArabic ? 'المواعيد' : 'Appointments',
  userRole: role ?? 'User',
  body: TabBarView(
    controller: _tabController,
    children: [...],  // الحفاظ على الـ tabs
  ),
  drawerItems: _buildAppointmentsDrawerItems(isArabic),
  accentColor: CustomIcons.getRoleColor(role ?? 'User'),
);
```

---

## 🎯 خطوات التنفيذ

### الخطوة 1: التحضير
```bash
# تأكد من وجود الاستيرادات
import 'package:mcs/core/widgets/app_scaffold.dart';
import 'package:mcs/core/assets/icons/custom_icons.dart';
```

### الخطوة 2: تحديث الـ Dashboards
- افتح كل Dashboard
- استبدل Scaffold بـ UnifiedAppScaffold
- احفظ المحتوى الحالي كـ body
- أضف بيانات المستخدم والرول
- حدد اللون المناسب

### الخطوة 3: تحديث الشاشات الموحدة
- أضف معامل `currentRole` أو `role`
- استبدل Scaffold بـ UnifiedAppScaffold
- حافظ على الوظائف الحالية (Tabs, etc)

### الخطوة 4: الاختبار
```bash
flutter clean
flutter pub get
flutter analyze
flutter run
```

---

## 📝 مثال عملي كامل

### قبل الإصلاح:
```dart
class NurseDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminBloc(sl<SupabaseService>())
        ..add(const admin_events.LoadPatients()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(isArabic ? 'لوحة تحكم الممرض' : 'Nurse Dashboard'),
          backgroundColor: Colors.blue,
        ),
        body: BlocBuilder<AdminBloc, AdminState>(
          builder: (context, state) {
            return _buildContent(context, state);
          },
        ),
      ),
    );
  }
}
```

### بعد الإصلاح:
```dart
class NurseDashboard extends StatefulWidget {
  const NurseDashboard({super.key});

  @override
  State<NurseDashboard> createState() => _NurseDashboardState();
}

class _NurseDashboardState extends State<NurseDashboard> {
  bool _isDarkMode = false;
  String _currentLanguage = 'ar';
  int _notificationCount = 4;

  @override
  Widget build(BuildContext context) {
    final isArabic = _currentLanguage == 'ar';

    return BlocProvider(
      create: (_) => AdminBloc(sl<SupabaseService>())
        ..add(const admin_events.LoadPatients())
        ..add(const admin_events.LoadAppointments()),
      child: UnifiedAppScaffold(
        title: isArabic ? 'لوحة تحكم الممرض' : 'Nurse Dashboard',
        body: BlocBuilder<AdminBloc, AdminState>(
          builder: (context, state) {
            return _buildContent(context, state, isArabic);
          },
        ),
        userRole: 'Nurse',
        userData: AppScaffoldUserData(
          name: 'أم. محمد علي',
          email: 'nurse.ali@clinic.com',
          role: 'Nurse',
          avatarUrl: null,
        ),
        notificationCount: _notificationCount,
        isDarkMode: _isDarkMode,
        currentLanguage: _currentLanguage,
        drawerItems: _buildNurseDrawerItems(isArabic),
        onLanguageChange: (lang) => setState(() => _currentLanguage = lang),
        onThemeToggle: () => setState(() => _isDarkMode = !_isDarkMode),
        onNotificationTap: () => _showNotifications(context, isArabic),
        onLogout: () => _handleLogout(context),
        accentColor: Colors.teal,
      ),
    );
  }

  widgets _buildNurseDrawerItems(bool isArabic) {
    return [
      DrawerItem(
        label: isArabic ? 'لوحة التحكم' : 'Dashboard',
        icon: Icons.dashboard,
        onTap: () {},
      ),
      DrawerItem(
        label: isArabic ? 'المرضى' : 'Patients',
        icon: Icons.people,
        onTap: () {},
      ),
      DrawerItem(
        label: isArabic ? 'المواعيد' : 'Appointments',
        icon: Icons.event,
        onTap: () {},
      ),
      // ... عناصر أخرى
    ];
  }

  // ... باقي الدوال
}
```

---

## ⏱️ المدة المتوقعة

- **تحديث Dashboards**: 30-45 دقيقة (7 ملفات)
- **تحديث Settings**: 10-15 دقيقة
- **تحديث Appointments**: 10-15 دقيقة
- **الاختبار**: 15-20 دقيقة
- **المجموع**: **1.5-2 ساعة**

---

## ✅ معايير النجاح

- [ ] جميع الـ Dashboards تستخدم UnifiedAppScaffold
- [ ] Settings و Appointments تستخدم UnifiedAppScaffold
- [ ] flutter analyze: 0 أخطاء حرجة
- [ ] جميع الأزرار الموحدة تعمل
- [ ] تغيير اللغة يعمل في جميع الصفحات
- [ ] تبديل المظهر يعمل في جميع الصفحات
- [ ] الألوان صحيحة لكل دور

---

## 🚀 الخطوات التالية

1. **تنفيذ الإصلاحات**: تحديث الملفات 9 المتبقية
2. **الاختبار الشامل**: اختبار كل صفحة مع كل دور
3. **التحقق النهائي**: flutter analyze و flutter run
4. **التوثيق**: تحديث الدليل الأساسي

---

**ملاحظة**: هذه التوصيات يمكن تنفيذها بشكل متوازي أو متسلسل حسب التفضيل.
