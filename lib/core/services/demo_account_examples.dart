/// Example usage of DemoAccountService in a BLoC/Screen context.
///
/// This file demonstrates how to integrate demo account creation
/// and management in your application features.
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/config/injection_container.dart';
import 'package:mcs/core/services/demo_account_service.dart';
import 'package:mcs/core/services/demo_accounts_init.dart';

// ══════════════════════════════════════════════════════════════════════════
// EXAMPLE 1: Using DemoAccountService Directly in a Widget
// ══════════════════════════════════════════════════════════════════════════

class DemoAccountsSetupScreen extends StatefulWidget {
  const DemoAccountsSetupScreen({super.key});

  @override
  State<DemoAccountsSetupScreen> createState() =>
      _DemoAccountsSetupScreenState();
}

class _DemoAccountsSetupScreenState extends State<DemoAccountsSetupScreen> {
  late DemoAccountService _demoAccountService;
  bool _isLoading = false;
  Map<String, DemoAccountResult>? _results;

  @override
  void initState() {
    super.initState();
    _demoAccountService = sl<DemoAccountService>();
  }

  Future<void> _createAllDemoAccounts() async {
    setState(() => _isLoading = true);

    try {
      final results = await _demoAccountService.createAllDemoAccounts();
      setState(() => _results = results);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Demo accounts created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Demo Accounts'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            const Text(
              'Demo Account Credentials:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ..._buildCredentialsList(),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _createAllDemoAccounts,
              icon: const Icon(Icons.person_add),
              label: const Text('Create/Verify All Demo Accounts'),
            ),
            const SizedBox(height: 16),
            if (_results != null) ...[
              const Text(
                'Creation Results:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ..._buildResultsList(),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCredentialsList() {
    return DemoAccountService.demoAccounts.entries.map((entry) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Email: ${entry.value}'),
                const SizedBox(height: 4),
                const Text('Password: Demo@123456'),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildResultsList() {
    return _results!.entries.map((entry) {
      final result = entry.value;
      final isSuccess = result.success;

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Card(
          color: isSuccess ? Colors.green[50] : Colors.red[50],
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(
                  isSuccess ? Icons.check_circle : Icons.error,
                  color: isSuccess ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.role,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        result.message,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}

// ══════════════════════════════════════════════════════════════════════════
// EXAMPLE 2: App Initialization Helper
// ══════════════════════════════════════════════════════════════════════════

/// Call this in main() during development to set up demo accounts
Future<void> setupDemoAccountsOnStartup() async {
  const isDebugMode =
      true; // Use: import 'package:flutter/foundation.dart' kDebugMode;

  if (isDebugMode) {
    try {
      final demoService = sl<DemoAccountService>();

      // Initialize all demo accounts
      final report = await initializeDemoAccounts(
        demoService,
        verbose: true,
      );

      // Print the report
      print(report);

      // Print credentials for easy access
      printDemoCredentials(demoService);
    } catch (e) {
      print('⚠️ Failed to setup demo accounts: $e');
    }
  }
}

// ══════════════════════════════════════════════════════════════════════════
// EXAMPLE 3: Quick Test/Login with Demo Account
// ══════════════════════════════════════════════════════════════════════════

/// Quick login with demo account for testing
Future<bool> quickLoginWithDemoAccount(String role) async {
  final demoService = sl<DemoAccountService>();
  final credentials = demoService.getAllDemoCredentials();

  if (credentials.containsKey(role)) {
    final cred = credentials[role]!;
    final email = cred['email']!;
    // final password = cred['password']!;

    // You would call your actual login here
    // final result = await _authRepository.login(
    //   email: email,
    //   password: password,
    // );

    print('🔐 Demo Login: $email');
    return true;
  }

  return false;
}

// ══════════════════════════════════════════════════════════════════════════
// EXAMPLE 4: Verify Demo Account Exists Before Login Screen
// ══════════════════════════════════════════════════════════════════════════

class DemoLoginHelper {
  static Future<bool> isDemoDoctorAvailable() async {
    final demoService = sl<DemoAccountService>();
    return demoService.demoAccountExists('doctor');
  }

  static Future<bool> isDemoPatientAvailable() async {
    final demoService = sl<DemoAccountService>();
    return demoService.demoAccountExists('patient');
  }

  static Future<bool> isAllDemoAccountsAvailable() async {
    final demoService = sl<DemoAccountService>();

    for (final role in [
      'super_admin',
      'admin',
      'doctor',
      'patient',
      'employee',
    ]) {
      if (!await demoService.demoAccountExists(role)) {
        return false;
      }
    }

    return true;
  }

  static String getDemoEmail(String role) {
    return DemoAccountService.demoAccounts[role] ?? '';
  }

  static String getDemoPassword() => 'Demo@123456';
}

// ══════════════════════════════════════════════════════════════════════════
// EXAMPLE 5: In main.dart - Full Initialization
// ══════════════════════════════════════════════════════════════════════════

/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    anonKey: dotenv.get('SUPABASE_ANON_KEY'),
  );

  // Setup dependency injection
  await injection.configureDependencies();

  // [Optional] Initialize demo accounts for development
  if (kDebugMode) {
    final demoService = injection.sl<DemoAccountService>();
    
    try {
      final report = await initializeDemoAccounts(
        demoService,
        verbose: true,
      );
      
      if (report.isSuccessful) {
        print('✅ ${report.newAccountsCreated} new demo accounts created');
        print('♻️  ${report.existingAccounts} demo accounts already exist');
      }
      
      // Show credentials in console for testing
      printDemoCredentials(demoService);
    } catch (e) {
      print('⚠️ Demo account setup failed: $e');
    }
  }

  runApp(const MyApp());
}
*/
