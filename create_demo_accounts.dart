import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

/// فقط قم بتشغيل هذا الملف مرة واحدة لإنشاء حسابات التجريب
/// dart run create_demo_accounts.dart

Future<void> main() async {
  // تهيئة Supabase
  await Supabase.initialize(
    url: 'https://ivguxjyghfndliptmink.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml2Z3V4anlnaGZuZGxpcHRtaW5rIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI2MTAzOTAsImV4cCI6MjA4ODE4NjM5MH0.5mXSPfGwan9b37oo2xeOL_kG3ajrjcoAWWpZdurJnSQ',
  );

  final supabase = Supabase.instance.client;

  // قائمة حسابات التجريب
  final demoAccounts = [
    {'email': 'doctor@mcs.demo', 'password': 'Demo123456', 'role': 'doctor'},
    {'email': 'patient@mcs.demo', 'password': 'Demo123456', 'role': 'patient'},
    {'email': 'admin@mcs.demo', 'password': 'Demo123456', 'role': 'clinic_admin'},
    {'email': 'superadmin@mcs.demo', 'password': 'Demo123456', 'role': 'super_admin'},
    {'email': 'staff@mcs.demo', 'password': 'Demo123456', 'role': 'staff'},
  ];

  print('🚀 جاري إنشاء حسابات التجريب...\n');

  for (final account in demoAccounts) {
    try {
      final response = await supabase.auth.signUp(
        email: account['email'],
        password: account['password']!,
      );

      if (response.user != null) {
        print('✅ تم إنشاء ${account['email']!} بنجاح');
        print('   كلمة المرور: ${account['password']!}\n');
      }
    } catch (e) {
      print('❌ خطأ في إنشاء ${account['email']!}: $e\n');
    }
  }

  print('✨ اكتمل إنشاء حسابات التجريب!');
  exit(0);
}
