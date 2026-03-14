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
/// الحسابات المتاحة:
/// - 👨‍⚕️ Doctor: doctor@demo.com
/// - 🏥 Patient: patient@demo.com
/// - ⚙️ Admin: admin@demo.com
/// - 👑 SuperAdmin: superadmin@demo.com
/// - 👨‍💼 Staff: staff@demo.com
///
/// Password for all: Demo@123456
/// ═══════════════════════════════════════════════════════════════

Future<void> main() async {
  print('═══════════════════════════════════════════════════════════════');
  print('🔐 إنشاء حسابات التجريب | Creating Demo Accounts');
  print('═══════════════════════════════════════════════════════════════\n');

  // تهيئة Supabase | Initialize Supabase
  try {
    await Supabase.initialize(
      url: 'https://ivguxjyghfndliptmink.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml2Z3V4anlnaGZuZGxpcHRtaW5rIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI2MTAzOTAsImV4cCI6MjA4ODE4NjM5MH0.5mXSPfGwan9b37oo2xeOL_kG3ajrjcoAWWpZdurJnSQ',
    );
    print('✅ Supabase initialized successfully\n');
  } catch (e) {
    print('❌ Failed to initialize Supabase: $e');
    exit(1);
  }

  final supabase = Supabase.instance.client;

  /// قائمة حسابات التجريب | Demo Accounts List
  final demoAccounts = [
    {
      'email': 'doctor@demo.com',
      'password': 'Demo@123456',
      'role': 'doctor',
      'description': '👨‍⚕️ حساب الطبيب | Doctor Account',
    },
    {
      'email': 'patient@demo.com',
      'password': 'Demo@123456',
      'role': 'patient',
      'description': '🏥 حساب المريض | Patient Account',
    },
    {
      'email': 'admin@demo.com',
      'password': 'Demo@123456',
      'role': 'clinic_admin',
      'description': '⚙️ مسؤول العيادة | Clinic Admin',
    },
    {
      'email': 'superadmin@demo.com',
      'password': 'Demo@123456',
      'role': 'super_admin',
      'description': '👑 المسؤول الأساسي | Super Admin',
    },
    {
      'email': 'staff@demo.com',
      'password': 'Demo@123456',
      'role': 'staff',
      'description': '👨‍💼 حساب الموظف | Staff Account',
    },
  ];

  print('🚀 جاري إنشاء حسابات التجريب...\n');
  print('Creating demo accounts...\n');

  var successCount = 0;
  var failureCount = 0;

  for (final account in demoAccounts) {
    try {
      print('─────────────────────────────────────────');
      print('${account['description']}');
      print('Email: ${account['email']}');

      final response = await supabase.auth.signUp(
        email: account['email'],
        password: account['password']!,
      );

      if (response.user != null) {
        print('✅ تم الإنشاء بنجاح | Created Successfully');
        print('Password: ${account['password']!}\n');
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
    print('✨ اكتمل إنشاء جميع حسابات التجريب بنجاح!');
    print('✨ All demo accounts created successfully!\n');
    print('📖 يمكنك الآن استخدام الحسابات أعلاه للدخول');
    print('📖 You can now use the accounts above to login\n');
    print('📄 لمزيد من الفاصيل، انظر: DEMO_ACCOUNTS.md');
    print('📄 For more details, see: DEMO_ACCOUNTS.md\n');
  }

  exit(failureCount > 0 ? 1 : 0);
}
