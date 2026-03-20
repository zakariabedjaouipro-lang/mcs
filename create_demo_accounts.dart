import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

/// ═══════════════════════════════════════════════════════════════
/// إنشاء حسابات التجريب | Create Demo Accounts
/// ═══════════════════════════════════════════════════════════════
///
/// فقط قم بتشغيل هذا الملف مرة واحدة لإنشاء حسابات التجريب
/// This file should be run only once to create demo accounts
///
/// Run: dart run create_demo_accounts.dart
///
/// الحسابات المتاحة (10 أدوار كاملة):
/// - 👑 Super Admin: super@example.com
/// - ⚙️ Clinic Admin: clinic@example.com
/// - 👨‍⚕️ Doctor: doctor@example.com
/// - 💉 Nurse: nurse@example.com
/// - 📞 Receptionist: reception@example.com
/// - 💊 Pharmacist: pharmacy@example.com
/// - 🔬 Lab Technician: lab@example.com
/// - 📡 Radiographer: radio@example.com
/// - 🏥 Patient: patient@example.com
/// - 👨‍👩‍👧 Relative: relative@example.com
///
/// Password for all: Password123!
/// ═══════════════════════════════════════════════════════════════

Future<void> main() async {
  print('═══════════════════════════════════════════════════════════════');
  print(
      '🔐 إنشاء حسابات التجريب (10 أدوار) | Creating Demo Accounts (10 Roles)');
  print('═══════════════════════════════════════════════════════════════\n');

  // تهيئة Supabase | Initialize Supabase
  try {
    await Supabase.initialize(
      url: 'https://lwhuwjimlyzjiiyodmfw.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx3aHV3amltbHl6amlpeW9kbWZ3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM0ODk3NzEsImV4cCI6MjA4OTA2NTc3MX0.gyUp6D_7OkUIo3x0YownE_maiyBhD7gMZs0U-ryC6V0',
    );
    print('✅ Supabase initialized successfully\n');
  } catch (e) {
    print('❌ Failed to initialize Supabase: $e');
    exit(1);
  }

  final supabase = Supabase.instance.client;

  /// قائمة حسابات التجريب (10 أدوار) | Demo Accounts List (10 Roles)
  final demoAccounts = [
    // Admin Roles (4)
    {
      'email': 'super@example.com',
      'password': 'Password123!',
      'role': 'super_admin',
      'description': '👑 مدير النظام | Super Admin',
    },
    {
      'email': 'clinic@example.com',
      'password': 'Password123!',
      'role': 'clinic_admin',
      'description': '⚙️ مدير العيادة | Clinic Admin',
    },
    {
      'email': 'doctor@example.com',
      'password': 'Password123!',
      'role': 'doctor',
      'description': '👨‍⚕️ طبيب | Doctor',
    },
    {
      'email': 'nurse@example.com',
      'password': 'Password123!',
      'role': 'nurse',
      'description': '💉 ممرض | Nurse',
    },

    // Staff Roles (4)
    {
      'email': 'reception@example.com',
      'password': 'Password123!',
      'role': 'receptionist',
      'description': '📞 موظف استقبال | Receptionist',
    },
    {
      'email': 'pharmacy@example.com',
      'password': 'Password123!',
      'role': 'pharmacist',
      'description': '💊 صيدلي | Pharmacist',
    },
    {
      'email': 'lab@example.com',
      'password': 'Password123!',
      'role': 'lab_technician',
      'description': '🔬 فني مختبر | Lab Technician',
    },
    {
      'email': 'radio@example.com',
      'password': 'Password123!',
      'role': 'radiographer',
      'description': '📡 أخصائي أشعة | Radiographer',
    },

    // Patient Roles (2)
    {
      'email': 'patient@example.com',
      'password': 'Password123!',
      'role': 'patient',
      'description': '🏥 مريض | Patient',
    },
    {
      'email': 'relative@example.com',
      'password': 'Password123!',
      'role': 'relative',
      'description': '👨‍👩‍👧 قريب | Relative',
    },
  ];

  print('🚀 جاري إنشاء حسابات التجريب (10 حسابات)...\n');
  print('Creating demo accounts (10 accounts)...\n');

  var successCount = 0;
  var failureCount = 0;

  for (final account in demoAccounts) {
    try {
      print('─────────────────────────────────────────');
      print('${account['description']}');
      print('📧 Email: ${account['email']}');
      print('🔑 Role: ${account['role']}');

      final response = await supabase.auth.signUp(
        email: account['email']!,
        password: account['password']!,
        data: {
          'role': account['role'],
          'full_name': _getFullNameFromRole(account['role']!),
        },
      );

      if (response.user != null) {
        print('✅ تم الإنشاء بنجاح | Created Successfully');
        print('🔐 Password: ${account['password']!}');

        // تحديث البيانات في جدول users
        try {
          await supabase.from('users').upsert({
            'id': response.user!.id,
            'email': account['email']!,
            'role': account['role'],
            'first_name': _getFirstNameFromRole(account['role']!),
            'last_name': _getLastNameFromRole(account['role']!),
          });
          print('📝 تم تحديث بيانات المستخدم | User profile updated');
        } catch (e) {
          print('⚠️ تحذير: لم يتم تحديث بيانات المستخدم: $e');
        }

        // تحديث طلبات الموافقة
        try {
          await supabase.from('user_approvals').upsert({
            'user_id': response.user!.id,
            'email': account['email']!,
            'full_name': _getFullNameFromRole(account['role']!),
            'role': account['role'],
            'registration_type': 'email',
            'status': 'approved', // موافقة تلقائية للحسابات التجريبية
          });
          print('✅ تمت الموافقة على الحساب | Account approved');
        } catch (e) {
          print('⚠️ تحذير: لم يتم تحديث طلب الموافقة: $e');
        }

        print('');
        successCount++;
      } else {
        print('⚠️ استجابة غير متوقعة | Unexpected response\n');
        failureCount++;
      }
    } catch (e) {
      print('❌ خطأ | Error: $e\n');
      failureCount++;
    }
  }

  print('═══════════════════════════════════════════════════════════════');
  print('📊 ملخص | Summary');
  print('═══════════════════════════════════════════════════════════════');
  print('✅ نجح: $successCount | Successful: $successCount');
  print('❌ فشل: $failureCount | Failed: $failureCount');
  print('═══════════════════════════════════════════════════════════════\n');

  if (failureCount == 0 && successCount > 0) {
    print('✨ اكتمل إنشاء جميع حسابات التجريب (10 أدوار) بنجاح!');
    print('✨ All 10 demo accounts created successfully!\n');
    print('📖 قائمة الحسابات | Accounts List:');
    print('═══════════════════════════════════════════════════════════════');

    for (final account in demoAccounts) {
      print('${account['description']}');
      print('   📧 ${account['email']}');
      print('   🔐 ${account['password']}');
    }

    print('═══════════════════════════════════════════════════════════════\n');
    print('📄 لمزيد من التفاصيل، انظر: DEMO_ACCOUNTS.md');
    print('📄 For more details, see: DEMO_ACCOUNTS.md\n');
  }

  exit(failureCount > 0 ? 1 : 0);
}

/// الحصول على الاسم الكامل بناءً على الدور
String _getFullNameFromRole(String role) {
  switch (role) {
    case 'super_admin':
      return 'مدير النظام';
    case 'clinic_admin':
      return 'مدير العيادة';
    case 'doctor':
      return 'د. أحمد محمد';
    case 'nurse':
      return 'م. فاطمة علي';
    case 'receptionist':
      return 'موظف استقبال';
    case 'pharmacist':
      return 'صيدلي';
    case 'lab_technician':
      return 'فني مختبر';
    case 'radiographer':
      return 'أخصائي أشعة';
    case 'patient':
      return 'مريض';
    case 'relative':
      return 'قريب';
    default:
      return 'مستخدم';
  }
}

/// الحصول على الاسم الأول بناءً على الدور
String _getFirstNameFromRole(String role) {
  switch (role) {
    case 'super_admin':
      return 'مدير';
    case 'clinic_admin':
      return 'مدير';
    case 'doctor':
      return 'أحمد';
    case 'nurse':
      return 'فاطمة';
    case 'receptionist':
      return 'موظف';
    case 'pharmacist':
      return 'صيدلي';
    case 'lab_technician':
      return 'فني';
    case 'radiographer':
      return 'أخصائي';
    case 'patient':
      return 'مريض';
    case 'relative':
      return 'قريب';
    default:
      return 'مستخدم';
  }
}

/// الحصول على الاسم الأخير بناءً على الدور
String _getLastNameFromRole(String role) {
  switch (role) {
    case 'super_admin':
      return 'النظام';
    case 'clinic_admin':
      return 'العيادة';
    case 'doctor':
      return 'محمد';
    case 'nurse':
      return 'علي';
    case 'receptionist':
      return 'استقبال';
    case 'pharmacist':
      return '';
    case 'lab_technician':
      return 'مختبر';
    case 'radiographer':
      return 'أشعة';
    case 'patient':
      return '';
    case 'relative':
      return '';
    default:
      return '';
  }
}
