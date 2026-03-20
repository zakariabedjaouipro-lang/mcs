/// Script للتحقق من وجود المستخدم والدور في قاعدة البيانات
///
/// الأغراض:
/// 1. التحقق من وجود UID معين في جدول users
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
    // ✅ البحث في الجدول الصحيح: 'users' بدلاً من 'profiles'
    final userData =
        await supabase.from('users').select().eq('id', userId).maybeSingle();

    if (userData == null) {
      print('❌ لم يتم العثور على المستخدم في جدول users');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

      // البحث في جدول auth.users
      print('🔍 البحث في جدول المصادقة (auth.users)...\n');

      final authUser = await supabase.auth.admin.getUserById(userId);
      if (authUser.user != null) {
        print('✅ وجدت المستخدم في جدول المصادقة:');
        print('   - البريد: ${authUser.user!.email}');
        print('   - تاريخ الإنشاء: ${authUser.user!.createdAt}');
        print('   - البيانات الإضافية: ${authUser.user!.userMetadata}');

        // التحقق من جدول user_approvals
        print('\n🔍 البحث في جدول user_approvals...');
        final approvalData = await supabase
            .from('user_approvals')
            .select()
            .eq('user_id', userId)
            .maybeSingle();

        if (approvalData != null) {
          print('✅ وجدت طلب موافقة:');
          approvalData.forEach((key, value) {
            print('   $key: $value');
          });
        } else {
          print('❌ لا يوجد طلب موافقة لهذا المستخدم');
        }

        print('\n⚠️  المشكلة: لا يوجد سجل في جدول users مع دور مسند.\n');
        print('💡 الحل: قم بإدراج السجل يدوياً أو عبر كود إنشاء المستخدم.\n');
      } else {
        print('❌ لم يتم العثور على المستخدم في أي جدول');
      }
    } else {
      print('✅ وجدت البيانات في جدول users:');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      userData.forEach((key, value) {
        if (key == 'role') {
          print('🎭 الدور: $value ${_getRoleEmoji(value)}');
        } else if (key == 'created_at') {
          print('📅 تاريخ الإنشاء: $value');
        } else if (key == 'updated_at') {
          print('🔄 آخر تحديث: $value');
        } else if (key == 'first_name') {
          print('👤 الاسم الأول: $value');
        } else if (key == 'last_name') {
          print('👤 الاسم الأخير: $value');
        } else if (key == 'email') {
          print('📧 البريد: $value');
        } else if (key == 'phone') {
          print('📱 الهاتف: $value');
        } else if (key != 'id') {
          print('   $key: $value');
        }
      });

      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

      // التحقق من الدور
      final role = userData['role'];
      if (role == null || role.toString().isEmpty) {
        print('⚠️  تنبيه: حقل الدور فارغ!');
        print('💡 الحل: قم بتحديث الدور بأحد الخيارات التالية:\n');
        print('   • super_admin (مدير النظام)');
        print('   • clinic_admin (مدير العيادة)');
        print('   • doctor (طبيب)');
        print('   • nurse (ممرض)');
        print('   • receptionist (موظف استقبال)');
        print('   • pharmacist (صيدلي)');
        print('   • lab_technician (فني مختبر)');
        print('   • radiographer (أخصائي أشعة)');
        print('   • patient (مريض)');
        print('   • relative (قريب)\n');

        // عرض أمر SQL للتحديث
        print('🔧 أمر SQL للتحديث:');
        print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
        print("""
UPDATE users 
SET role = 'patient'::user_role 
WHERE id = '$userId';
""");
        print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      } else {
        print('✅ تم العثور على دور مسند: $role ${_getRoleEmoji(role)}');
        print('✨ المستخدم مستعد للانتقال إلى التطبيق!\n\n');
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
    case 'super_admin':
      return '👑';
    case 'clinic_admin':
      return '🏥';
    case 'doctor':
      return '👨‍⚕️';
    case 'nurse':
      return '💉';
    case 'receptionist':
      return '📞';
    case 'pharmacist':
      return '💊';
    case 'lab_technician':
      return '🔬';
    case 'radiographer':
      return '📡';
    case 'patient':
      return '👤';
    case 'relative':
      return '👨‍👩‍👧';
    default:
      return '❓';
  }
}
