/// Script لإضافة دور للمستخدمين الذين لا يملكون دور
library;

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  try {
    print('\n🔧 إضافة دور للمستخدمين الذين لا يملكون دور');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

    // تهيئة Supabase
    const supabaseUrl = 'https://lwhuwjimlyzjiiyodmfw.supabase.co';
    const supabaseKey =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx3aHV3amltbHl6amlpeW9kbWZ3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU4OTUxMjEsImV4cCI6MjA1MTQ3MTEyMX0.LfNKXnl_xEMrBQrIuUfPnMxK39M3T1j5MaXBCjn3twc';

    final client = SupabaseClient(supabaseUrl, supabaseKey);

    const userId = '38900069-65f8-4736-93b4-c95bec6e0c37';
    const newRole = 'patient'; // يمكن تغييره إلى doctor, admin, employee

    print('📋 البيانات:');
    print('   UID: $userId');
    print('   الدور الجديد: $newRole\n');

    // 1️⃣ البحث عن المستخدم أولاً
    print('🔍 البحث عن المستخدم...');
    final existingProfile = await client
        .from('profiles')
        .select('id, email, role')
        .eq('id', userId)
        .maybeSingle();

    if (existingProfile == null) {
      print('❌ لم يتم العثور على المستخدم!');
      print('⚠️  تحتاج إلى إنشاء profile للمستخدم أولاً.\n');
    } else {
      print('✅ وجدت المستخدم:');
      print('   البريد: ${existingProfile['email']}');
      print('   الدور الحالي: ${existingProfile['role'] ?? "لا يوجد"}\n');

      // 2️⃣ تحديث الدور
      print('⏳ جاري تحديث الدور...');
      final result = await client
          .from('profiles')
          .update({'role': newRole}).eq('id', userId);

      print('✅ تم تحديث الدور بنجاح!');
      print('   الدور الجديد: $newRole\n');

      // 3️⃣ التحقق من التحديث
      print('🔍 التحقق من التحديث...');
      final updatedProfile = await client
          .from('profiles')
          .select('id, email, role')
          .eq('id', userId)
          .maybeSingle();

      if (updatedProfile != null) {
        print('✅ التحقق الناجح!');
        print('   الدور الحالي: ${updatedProfile['role']}\n');
        print('✨ المستخدم جاهز الآن للدخول إلى التطبيق!\n');
      }
    }

    await client.dispose();
  } catch (e) {
    print('❌ خطأ: $e\n');
  }
}
