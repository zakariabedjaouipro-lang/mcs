// ignore_for_file: avoid_print
import 'package:supabase_flutter/supabase_flutter.dart';

/// Diagnostic script to verify authentication and role resolution
/// Run with: dart run test_recovery.dart
void main() async {
  print('═' * 70);
  print('MCS PROJECT RECOVERY DIAGNOSTIC');
  print('═' * 70);
  print('');

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://lwhuwjimlyzjiiyodmfw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx3aHV3amlzbWx5emppaXlvZG1mdyIsInJvbGUiOiJhbm9uIiwiaWF0IjoxNzA5NTA4NDEwLCJleHAiOjE3NDA3Mjg0MTB9.zH2kj_XRnCVnCPxIhhvT4w0u6EhWzUSV4U3lBu9BhbI',
  );

  final supabase = Supabase.instance.client;

  try {
    // Test 1: Check if users table exists and has records
    print('TEST 1: Checking users table...');
    print('-' * 70);

    final usersResponse = await supabase.from('users').select().limit(10);

    print('✅ Table "users" exists');
    print('${usersResponse.length} rows found in users table');
    print('');

    // Test 2: Check demo accounts
    print('TEST 2: Looking for demo accounts...');
    print('-' * 70);

    final demoUsers = await supabase
        .from('users')
        .select()
        .ilike('email', '%demo%')
        .order('created_at', ascending: false);

    if (demoUsers.isEmpty) {
      print('❌ NO DEMO ACCOUNTS FOUND!');
      print('');
      print('ACTION NEEDED: Create demo accounts in users table');
    } else {
      print('✅ Found ${demoUsers.length} demo accounts:');
      for (final user in demoUsers) {
        print(
          '   - ${user['email']} (role: ${user['role'] ?? 'NULL'})',
        );
      }
    }
    print('');

    // Test 3: Check auth.users
    print('TEST 3: Checking auth.users (authentication)...');
    print('-' * 70);

    final authUsersList = await supabase.auth.admin.listUsers();

    print('✅ Auth service connected');
    print('${authUsersList.length} total users in auth.users');

    final authDemoUsers = authUsersList
        .where(
          (user) =>
              (user.email?.contains('demo') ?? false) ||
              (user.email?.contains('admin') ?? false),
        )
        .toList();

    if (authDemoUsers.isEmpty) {
      print('❌ No demo accounts in auth.users');
    } else {
      print('✅ Found ${authDemoUsers.length} demo in auth.users:');
      for (final user in authDemoUsers) {
        print(
          '   - ${user.email} (verified: ${user.emailConfirmedAt != null})',
        );
      }
    }
    print('');

    // Test 4: Check for data mismatch
    print('TEST 4: Checking for data consistency...');
    print('-' * 70);

    final authEmails = authUsersList.map((u) => u.email).toSet();
    final dbEmails =
        (usersResponse as List).map((u) => u['email'] as String?).toSet();

    final missingInDb = authEmails.difference(dbEmails);
    final extraInDb = dbEmails.difference(authEmails);

    if (missingInDb.isEmpty && extraInDb.isEmpty) {
      print('✅ Data is consistent between auth.users and users table');
    } else {
      if (missingInDb.isNotEmpty) {
        print('⚠️  Users in auth but NOT in users table:');
        for (final email in missingInDb) {
          print('   - $email');
        }
      }
      if (extraInDb.isNotEmpty) {
        print('⚠️  Records in users table but NOT in auth:');
        for (final email in extraInDb) {
          print('   - $email');
        }
      }
    }
    print('');

    // Test 5: Check role distribution
    print('TEST 5: Role distribution in users table...');
    print('-' * 70);

    try {
      final rolesResponse = await supabase.rpc<List<dynamic>>(
        'count_by_role',
        params: {},
      );

      if (rolesResponse.isNotEmpty) {
        print('Role distribution:');
        for (final row in rolesResponse) {
          final rowMap = row as Map<String, dynamic>;
          final role = rowMap['role'];
          final count = rowMap['count'];
          print('   $role: $count users');
        }
      } else {
        throw Exception('Invalid response');
      }
    } catch (_) {
      // Manual count
      final allUsers = await supabase.from('users').select();

      final roleCounts = <String, int>{};
      for (final user in (allUsers as List)) {
        final userMap = user as Map<String, dynamic>;
        final role = (userMap['role'] ?? 'NULL') as String;
        roleCounts[role] = (roleCounts[role] ?? 0) + 1;
      }

      print('Role distribution:');
      for (final role in roleCounts.entries) {
        print('   ${role.key}: ${role.value} users');
      }
    }
    print('');

    // Test 6: Check for tables
    print('TEST 6: Checking for other user-related tables...');
    print('-' * 70);

    final tablesCheck = [
      'profiles',
      'public_users',
      'user_profiles',
      'employees',
      'doctors',
      'patients',
    ];

    for (final table in tablesCheck) {
      try {
        final result = await supabase.from(table).select().limit(1);
        print('✅ Table "$table" exists (${(result as List).length} rows)');
      } catch (_) {
        print('❌ Table "$table" does NOT exist');
      }
    }
    print('');

    // SUMMARY
    print('═' * 70);
    print('SUMMARY & RECOMMENDATIONS');
    print('═' * 70);

    if (demoUsers.isEmpty) {
      print('🔴 CRITICAL: No demo accounts exist in users table!');
      print('   ACTION: Run create_demo_accounts.dart to generate them');
      print('');
    }

    if (missingInDb.isNotEmpty) {
      print('🟡 WARNING: Users in auth but not in users table!');
      print('   ACTION: Run this SQL to create missing records:');
      print('');
      for (final email in missingInDb) {
        print('   INSERT INTO users (id, email, role, created_at, updated_at)');
        print("   SELECT id, email, 'patient'::user_role, NOW(), NOW()");
        print("   FROM auth.users WHERE email = '$email'");
        print('   ON CONFLICT DO NOTHING;');
        print('');
      }
    }

    if (demoUsers.every((u) => u['role'] != null)) {
      print('✅ All demo accounts have roles assigned');
    }

    print('✅ RECOVERY DIAGNOSTIC COMPLETE');
  } catch (e) {
    print('❌ DIAGNOSTIC ERROR: $e');
    print('');
    print('Possible causes:');
    print('1. Supabase URL or key is incorrect');
    print('2. Network connectivity issue');
    print('3. Supabase project is down');
  }
}
