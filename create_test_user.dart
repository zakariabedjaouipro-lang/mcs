import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

/// Simple script to create a test user with a role
Future<void> main() async {
  print('\n═══════════════════════════════════════════════════════════════');
  print('🔐 Creating Test User with Role');
  print('═══════════════════════════════════════════════════════════════\n');

  await Supabase.initialize(
    url: 'https://lwhuwjimlyzjiiyodmfw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx3aHV3amltbHl6amlpeW9kbWZ3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM0ODk3NzEsImV4cCI6MjA4OTA2NTc3MX0.gyUp6D_7OkUIo3x0YownE_maiyBhD7gMZs0U-ryC6V0',
  );

  final supabase = Supabase.instance.client;
  const email = 'patient@demo.com';
  const password = 'Demo@123456';

  try {
    // Step 1: Delete existing user if exists
    print('1️⃣ Checking for existing user...');
    try {
      await supabase.from('users').delete().eq('email', email);
      print('   ✅ Removed old user\n');
    } catch (_) {
      print('   ℹ️ No old user found\n');
    }

    // Step 2: Sign up new user
    print('2️⃣ Creating new auth user...');
    final authResponse = await supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'role': 'patient',
        'approvalStatus': 'approved',
      },
    );

    if (authResponse.user == null) {
      print('❌ Failed to create auth user');
      exit(1);
    }

    final userId = authResponse.user!.id;
    print('   ✅ Auth user created: $userId\n');

    // Step 3: Ensure user record in database
    print('3️⃣ Creating user record in database...');
    await supabase.from('users').insert({
      'id': userId,
      'email': email,
      'role': 'patient',
      'approval_status': 'approved',
      'created_at': DateTime.now().toIso8601String(),
    });
    print('   ✅ User record created\n');

    print('═══════════════════════════════════════════════════════════════');
    print('✅ Test user created successfully!\n');
    print('📧 Email: $email');
    print('🔑 Password: $password');
    print('👤 Role: patient');
    print('✅ Status: approved\n');
    print('You can now log in with these credentials.\n');
  } catch (e) {
    print('\n❌ Error: $e\n');
    exit(1);
  }
}
