/// Script للتحقق من وجود المستخدم والدور في قاعدة البيانات
///
/// الأغراض:
/// 1. التحقق من وجود UID معين في جدول profiles
/// 2. التحقق من وجود دور مسند للمستخدم
/// 3. عرض بيانات المستخدم الكاملة
/// 4. إذا لم يكن هناك دور، إضافة دور افتراضي
library;

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  // تهيئة Supabase
  await Supabase.initialize(
    url: 'https://lwhuwjimlyzjiiyodmfw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx3aHV3amltbHl6amlpeW9kbWZ3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU4OTUxMjEsImV4cCI6MjA1MTQ3MTEyMX0.LfNKXnl_xEMrBQrIuUfPnMxK39M3T1j5MaXBCjn3twc',
  );

  final supabase = Supabase.instance.client;

  // UID المراد التحقق منه
  const userId = '38900069-65f8-4736-93b4-c95bec6e0c37';

  print('\n📋 فحص بيانات المستخدم في قاعدة البيانات');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('🔍 البحث عن UID: $userId\n');

  try {
    // البحث عن المستخدم في جدول profiles
    final profileData = await supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .limit(1)
        .maybeSingle();

    if (profileData == null) {
      print('❌ لم يتم العثور على المستخدم في جدول profiles');
      print(
        '💡 قد يكون السبب: المستخدم لم يقم بإنشاء صفحة profile بعد المصادقة.\n',
      );

      // البحث في جدول auth.users
      print('🔍 البحث في جدول المصادقة (auth.users)...\n');

      final authUser = await supabase.auth.admin.getUserById(userId);
      if (authUser.user != null) {
        print('✅ وجدت المستخدم في جدول المصادقة:');
        print('   - البريد: ${authUser.user!.email}');
        print('   - تاريخ الإنشاء: ${authUser.user!.createdAt}');
        print('   - البيانات الإضافية: ${authUser.user!.userMetadata}');
        print(
          '\n⚠️  المشكلة: لا يوجد سجل في جدول profiles مع دور مسند.\n',
        );
        print(
          '💡 الحل: قم بإدراج السجل يدوياً أو عبر كود إنشاء المستخدم.\n',
        );
      }
    } else {
      print('✅ وجدت البيانات في جدول profiles:');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      profileData.forEach((key, value) {
        if (key == 'role') {
          print('🎭 الدور: $value ${_getRoleEmoji(value)}');
        } else if (key == 'created_at') {
          print('📅 تاريخ الإنشاء: $value');
        } else if (key == 'updated_at') {
          print('🔄 آخر تحديث: $value');
        } else if (key != 'id') {
          print('   $key: $value');
        }
      });

      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

      // التحقق من الدور
      final role = profileData['role'];
      if (role == null || role.toString().isEmpty) {
        print('⚠️  تنبيه: حقل الدور فارغ!');
        print('💡 الحل: قم بتحديث الدور بأحد الخيارات التالية:\n');
        print('   • patient (مريض)');
        print('   • doctor (طبيب)');
        print('   • admin (مسؤول)');
        print('   • employee (موظف)\n');

        // عرض أمر SQL للتحديث
        print('🔧 أمر SQL للتحديث:');
        print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
        print("""
UPDATE profiles 
SET role = 'patient' 
WHERE id = '$userId';
""");
        print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      } else {
        print('✅ تم العثور على دور مسند: $role ${_getRoleEmoji(role)}');
        print(
          '✨ المستخدم مستعد للانتقال إلى التطبيق!\n\n',
        );
      }
    }
  } catch (e) {
    print('❌ خطأ في الاتصال بقاعدة البيانات:');
    print('   $e\n');
    print('💡 تأكد من:');
    print('   1. اتصالك بالإنترنت');
    print('   2. بيانات Supabase صحيحة');
    print('   3. قاعدة البيانات تعمل بشكل صحيح\n');
  }
}

/// دالة مساعدة لعرض emoji حسب الدور
String _getRoleEmoji(dynamic role) {
  if (role == null) return '';
  final roleStr = role.toString().toLowerCase();
  switch (roleStr) {
    case 'patient':
      return '👨‍⚕️';
    case 'doctor':
      return '👨‍💼';
    case 'admin':
      return '👑';
    case 'employee':
      return '👔';
    default:
      return '❓';
  }
}
