# 🎨 نظام الأيقونات والأزرار المخصصة - دليل الاستخدام

## 📋 نظرة عامة

تم إنشاء نظام متكامل للأيقونات والأزرار المخصصة لتطبيق MCS الطبي، يتضمن:

- ✅ 8 أيقونات SVG مخصصة لكل دور
- ✅ نظام CustomIcons للوصول السهل للأيقونات
- ✅ عدة أنواع من الأزرار (RoleButton, RoleCard, إلخ)
- ✅ عدة أنواع من الصور الرمزية (Avatar, Badge, Status, إلخ)
- ✅ دعم كامل للغة العربية (RTL)
- ✅ ألوان محددة مسبقاً لكل دور

---

## 📁 هيكل الملفات

```
lib/
├── core/
│   ├── assets/
│   │   └── icons/
│   │       ├── custom_icons.dart        # كلاس الأيقونات الرئيسي
│   │       └── index.dart               # تصدير الأيقونات
│   └── widgets/
│       ├── role_buttons.dart            # الأزرار المخصصة
│       ├── role_avatar.dart             # الصور الرمزية
│       └── index.dart                   # تصدير الويدجتات
assets/
└── icons/
    └── svg/                             # ملفات SVG
        ├── reception.svg
        ├── radiology.svg
        ├── lab_technician.svg
        ├── pharmacist.svg
        ├── nurse.svg
        ├── receptionist.svg
        ├── radiographer.svg
        ├── clinic_admin.svg
        └── relative.svg
```

---

## 🎯 الاستخدام

### 1. استخدام الأيقونات المخصصة

#### الطريقة الأولى: استخدام الدوال الثابتة

```dart
import 'package:mcs/core/assets/icons/custom_icons.dart';

// أيقونة receptionist بحجم 24 بلون برتقالي
CustomIcons.receptionist(size: 24, color: Colors.orange)

// أيقونة nurse بحجم 32 بلون الأزرق الفاتح
CustomIcons.nurse(size: 32, color: Colors.teal)

// أيقونة radiographer بالحجم واللون الافتراضيين
CustomIcons.radiographer()
```

#### الطريقة الثانية: الحصول على الأيقونة حسب اسم الدور

```dart
// الحصول على الأيقونة حسب اسم الدور
CustomIcons.getIconByRole(
  'receptionist',
  size: 24,
  color: Colors.orange,
)

// مثال في حلقة
for (final role in ['nurse', 'doctor', 'pharmacist']) {
  CustomIcons.getIconByRole(role, size: 20)
}
```

#### الطريقة الثالثة: الحصول على لون الدور

```dart
// الحصول على اللون الافتراضي للدور
final color = CustomIcons.getRoleColor('receptionist');  // Colors.orange

// مثال في بناء الـ UI
Container(
  color: CustomIcons.getRoleColor('nurse'),  // لون تريكوي
  child: Text('Nurse'),
)
```

---

### 2. استخدام الأزرار المخصصة

#### RoleButton - زر أساسي

```dart
import 'package:mcs/core/widgets/role_buttons.dart';

RoleButton(
  role: 'receptionist',
  label: 'موظف استقبال',
  onTap: () {
    // تنفيذ الإجراء هنا
  },
  isSelected: true,  // تحديد الزر أم لا
)
```

#### أزرار محددة لكل دور

```dart
// زر receptionist
ReceptionistButton(
  onTap: () => print('Receptionist tapped'),
  isSelected: _selectedRole == 'receptionist',
)

// زر nurse
NurseButton(
  onTap: () => print('Nurse tapped'),
  isSelected: _selectedRole == 'nurse',
)

// زر radiographer
RadiographerButton(onTap: () {})

// زر pharmacist
PharmacistButton(onTap: () {})

// زر lab technician
LabTechnicianButton(onTap: () {})

// زر relative
RelativeButton(onTap: () {})

// زر clinic admin
ClinicAdminButton(onTap: () {})
```

#### RoleCard - بطاقة دور

```dart
import 'package:mcs/core/widgets/role_buttons.dart';

RoleCard(
  role: 'receptionist',
  title: 'موظف الاستقبال',
  subtitle: 'إدارة الحجوزات والمواعيد',
  onTap: () {
    // الانتقال إلى لوحة التحكم
  },
  isSelected: true,
)
```

#### شبكة الأدوار

```dart
// عرض عدة أدوار في شبكة
RoleButtonGrid(
  roles: [
    {
      'role': 'receptionist',
      'title': 'موظف الاستقبال',
      'subtitle': 'حجوزات ومواعيد',
      'onTap': () => print('Receptionist'),
      'isSelected': false,
    },
    {
      'role': 'nurse',
      'title': 'ممرضة',
      'subtitle': 'متابعة المرضى',
      'onTap': () => print('Nurse'),
      'isSelected': true,
    },
    // ... أدوار أخرى
  ],
  crossAxisCount: 2,
  childAspectRatio: 2.5,
)
```

---

### 3. استخدام الصور الرمزية (Avatars)

#### RoleAvatar - صورة رمزية أساسية

```dart
import 'package:mcs/core/widgets/role_avatar.dart';

RoleAvatar(
  role: 'receptionist',
  radius: 20,
  onTap: () => print('Tapped'),
)
```

#### مع تسمية

```dart
RoleAvatarWithLabel(
  role: 'nurse',
  label: 'ممرضة',
  radius: 24,
)
```

#### مع شارة (Badge)

```dart
RoleBadge(
  role: 'receptionist',
  badgeCount: 5,  // شارة تعداد
  radius: 20,
)
```

#### مع مؤشر الحالة

```dart
RoleAvatarWithStatus(
  role: 'nurse',
  isOnline: true,  // أو false
  radius: 20,
)
```

#### مجموعة من الصور

```dart
RoleAvatarGroup(
  roles: ['receptionist', 'nurse', 'pharmacist'],
  radius: 16,
  overlapSize: 8,  // تداخل بين الصور
)
```

#### صورة مصغرة

```dart
MiniRoleAvatar(
  role: 'receptionist',
  size: 32,
)
```

---

### 4. أمثلة عملية متكاملة

#### مثال 1: قائمة الأدوار

```dart
import 'package:mcs/core/widgets/role_buttons.dart';
import 'package:mcs/core/assets/icons/custom_icons.dart';

class RolesList extends StatelessWidget {
  final List<String> roles = [
    'receptionist',
    'nurse',
    'pharmacist',
    'radiographer',
    'lab_technician',
    'relative',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: roles.length,
      itemBuilder: (context, index) {
        final role = roles[index];
        return ListTile(
          leading: MiniRoleAvatar(role: role),
          title: Text(role),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            // الانتقال إلى لوحة التحكم
          },
        );
      },
    );
  }
}
```

#### مثال 2: صفحة اختيار الدور

```dart
import 'package:mcs/core/widgets/role_buttons.dart';

class RoleSelectionScreen extends StatefulWidget {
  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Role'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            RoleCard(
              role: 'receptionist',
              title: 'Receptionist',
              subtitle: 'Manage bookings',
              onTap: () {
                setState(() => _selectedRole = 'receptionist');
              },
              isSelected: _selectedRole == 'receptionist',
            ),
            // ... أدوار أخرى
          ],
        ),
      ),
    );
  }
}
```

#### مثال 3: شريط معلومات المستخدم

```dart
import 'package:mcs/core/widgets/role_avatar.dart';
import 'package:mcs/core/assets/icons/custom_icons.dart';

class UserInfoBar extends StatelessWidget {
  final String userName;
  final String userRole;
  final bool isOnline;

  const UserInfoBar({
    required this.userName,
    required this.userRole,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          RoleAvatarWithStatus(
            role: userRole,
            isOnline: isOnline,
            radius: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  userRole,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isOnline ? Icons.circle : Icons.circle_outlined,
            color: isOnline ? Colors.green : Colors.grey,
            size: 12,
          ),
        ],
      ),
    );
  }
}
```

---

## 🎨 الألوان الافتراضية

| الدور | اللون | القيمة |
|------|-------|--------|
| super_admin | Purple | Colors.deepPurple |
| clinic_admin | Indigo | Colors.indigo |
| doctor | Blue | Colors.blue |
| nurse | Teal | Colors.teal |
| receptionist | Orange | Colors.orange |
| pharmacist | Green | Colors.green |
| lab_technician | Cyan | Colors.cyan |
| radiographer | Amber | Colors.amber |
| patient | Green | Colors.green |
| relative | Brown | Colors.brown |

---

## 📝 ملاحظات مهمة

1. **SVG Icons**: جميع الأيقونات موجودة في `assets/icons/svg/`
2. **Localization**: الأزرار تدعم العربية تلقائياً
3. **RTL Support**: جميع الويدجتات متوافقة مع العربية من اليمين لليسار
4. **Customization**: يمكنك تخصيص الألوان والأحجام
5. **Performance**: تم تحسين الأداء باستخدام SVG بدلاً من PNG

---

## 🔧 التحديثات المستقبلية

- إضافة المزيد من الأيقونات للعمليات الشائعة
- إضافة رسوم متحركة للأزرار
- إضافة ألوان مظلمة (Dark Mode)
- إضافة أيقونات للحالات المختلفة (Loading, Error, Success)

---

## ✅ Checklist للاستخدام

- [x] استيراد الأيقونات من `custom_icons.dart`
- [x] استيراد الأزرار من `role_buttons.dart`
- [x] استيراد الصور من `role_avatar.dart`
- [x] استخدام `CustomIcons.getIconByRole()` للحصول على الأيقونة حسب الدور
- [x] استخدام `CustomIcons.getRoleColor()` للحصول على الاللون
- [x] تخصيص الحجم واللون حسب الحاجة
