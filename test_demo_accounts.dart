import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  print('═══════════════════════════════════════════════════════════════');
  print('🔍 Checking Demo Accounts in Supabase');
  print('═══════════════════════════════════════════════════════════════\n');

  // Initialize Supabase
  try {
    await Supabase.initialize(
      url: 'https://lwhuwjimlyzjiiyodmfw.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx3aHV3amltbHl6amlpeW9kbWZ3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM0ODk3NzEsImV4cCI6MjA4OTA2NTc3MX0.gyUp6D_7OkUIo3x0YownE_maiyBhD7gMZs0U-ryC6V0',
    );
    print('✅ Supabase initialized\n');
  } catch (e) {
    print('❌ Failed to initialize Supabase: $e');
    return;
  }

  final supabase = Supabase.instance.client;

  // Query users table
  try {
    print('📊 Users in database:\n');
    final response = await supabase.from('users').select().limit(10);
    
    if (response.isEmpty) {
      print('❌ No users found');
    } else {
      for (final user in response) {
        print(
          '  Email: ${user['email'] ?? 'N/A'} | '
          'Role: ${user['role'] ?? 'N/A'} | '
          'ID: ${user['id']}',
        );
      }
    }
  } catch (e) {
    print('❌ Error querying users: $e');
  }

  print('\n═══════════════════════════════════════════════════════════════');
  print('✅ Done\n');
}
