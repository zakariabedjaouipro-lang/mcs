import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  log('🔐 Assigning Role to Current User');

  await Supabase.initialize(
    url: 'https://lwhuwjimlyzjiiyodmfw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx3aHV3amltbHl6amlpeW9kbWZ3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM0ODk3NzEsImV4cCI6MjA4OTA2NTc3MX0.gyUp6D_7OkUIo3x0YownE_maiyBhD7gMZs0U-ryC6V0',
  );

  final client = Supabase.instance.client;

  // Fetch all users without roles
  final response =
      await client.from('users').select('id, email, role') as List<dynamic>;

  log('📊 Users in database:');
  for (final user in response) {
    if (user is Map<String, dynamic>) {
      log('  • ${user['email']} → Role: ${user['role']}');
    }
  }

  // Update first user to have patient role
  if (response.isNotEmpty) {
    final firstUser = response.first;
    if (firstUser is Map<String, dynamic>) {
      final userId = firstUser['id'] as Object;
      final email = firstUser['email'] as String;

      log('🔄 Updating user: $email');

      await client.from('users').update({'role': 'patient'}).eq('id', userId);

      log('✅ User updated to role: patient');
    }
  }
}
