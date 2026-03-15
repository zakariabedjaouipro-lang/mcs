import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  try {
    print('\n📋 فحص بيانات المستخدم في قاعدة البيانات');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    // تهيئة Supabase
    const supabaseUrl = 'https://lwhuwjimlyzjiiyodmfw.supabase.co';
    const supabaseKey =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx3aHV3amltbHl6amlpeW9kbWZ3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU4OTUxMjEsImV4cCI6MjA1MTQ3MTEyMX0.LfNKXnl_xEMrBQrIuUfPnMxK39M3T1j5MaXBCjn3twc';

    final client = SupabaseClient(supabaseUrl, supabaseKey);

    const userId = '38900069-65f8-4736-93b4-c95bec6e0c37';
    print('🔍 البحث عن UID: $userId\n');

    // البحث عن المستخدم
    final response =
        await client.from('profiles').select().eq('id', userId).maybeSingle();

    if (response == null) {
      print('❌ لم يتم العثور على المستخدم في جدول profiles');
      print('💡 تحتاج إلى إنشاء profile للمستخدم أولاً\n');
    } else {
      print('✅ وجدت بيانات المستخدم:');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      response.forEach((key, value) {
        print('$key: $value');
      });

      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

      final role = response['role'];
      if (role == null || role.toString().isEmpty) {
        print('⚠️  تنبيه: حقل الدور فارغ!');
        print('💡 الحل: قم بتحديث الدور في Supabase Dashboard أو عبر SQL:\n');
        print('''
UPDATE profiles 
SET role = 'patient' 
WHERE id = '$userId';
''');
      } else {
        print('✅ الدور موجود: $role');
        print('✨ المستخدم جاهز!\n');
      }
    }

    await client.dispose();
  } catch (e) {
    print('❌ خطأ: $e\n');
  }
}
