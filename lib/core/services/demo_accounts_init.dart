/// Helper functions for setting up demo accounts during development.
library;

import 'dart:developer';

import 'package:mcs/core/services/demo_account_service.dart';

/// Initializes demo accounts for development and testing.
///
/// This should be called once during app startup if [enableDemoAccounts] is true.
/// Returns a report of all account creation attempts.
Future<DemoAccountsReport> initializeDemoAccounts(
  DemoAccountService demoAccountService, {
  bool verbose = false,
}) async {
  log(
    '📱 Initializing demo accounts for development...',
    name: 'DemoAccountsInit',
    level: 800,
  );

  try {
    final results = await demoAccountService.createAllDemoAccounts();

    final report = DemoAccountsReport.fromResults(results);

    if (verbose) {
      log(
        'Demo Accounts Report:\n$report',
        name: 'DemoAccountsInit',
        level: 800,
      );
    }

    return report;
  } catch (e, st) {
    log(
      '❌ Failed to initialize demo accounts: $e',
      name: 'DemoAccountsInit',
      level: 1000,
      stackTrace: st,
    );
    rethrow;
  }
}

/// Prints demo account credentials to console (for development only).
void printDemoCredentials(DemoAccountService demoAccountService) {
  final credentials = demoAccountService.getAllDemoCredentials();

  print('╔════════════════════════════════════════════════════════════╗');
  print('║            DEMO ACCOUNT CREDENTIALS (DEV ONLY)            ║');
  print('╠════════════════════════════════════════════════════════════╣');

  for (final entry in credentials.entries) {
    final role = entry.key.padRight(15);
    final email = entry.value['email']!;
    final password = entry.value['password']!;

    print('║ Role: $role                                ║');
    print('║   Email:    $email');
    print('║   Password: $password');
    print('║');
  }

  print('╚════════════════════════════════════════════════════════════╝');
}

/// Detailed report of demo account creation attempts.
class DemoAccountsReport {
  const DemoAccountsReport({
    required this.totalAttempts,
    required this.successCount,
    required this.failureCount,
    required this.newAccountsCreated,
    required this.existingAccounts,
    required this.errors,
  });

  /// Creates a report from demo account results.
  factory DemoAccountsReport.fromResults(
    Map<String, DemoAccountResult> results,
  ) {
    final errors = <String, String>{};
    var successCount = 0;
    var failureCount = 0;
    var newAccountsCreated = 0;
    var existingAccounts = 0;

    for (final result in results.values) {
      if (result.success) {
        successCount++;
        if (result.isNewlyCreated) {
          newAccountsCreated++;
        } else {
          existingAccounts++;
        }
      } else {
        failureCount++;
        errors[result.role] = result.message;
      }
    }

    return DemoAccountsReport(
      totalAttempts: results.length,
      successCount: successCount,
      failureCount: failureCount,
      newAccountsCreated: newAccountsCreated,
      existingAccounts: existingAccounts,
      errors: errors,
    );
  }

  /// Total number of account creation attempts.
  final int totalAttempts;

  /// Number of successful creations.
  final int successCount;

  /// Number of failures.
  final int failureCount;

  /// Number of newly created accounts.
  final int newAccountsCreated;

  /// Number of accounts that already existed.
  final int existingAccounts;

  /// Map of role to error message (if failed).
  final Map<String, String> errors;

  /// Whether all demo accounts were created successfully.
  bool get isSuccessful => failureCount == 0;

  @override
  String toString() {
    return '''
╔════════════════════════════════════════════════╗
║         DEMO ACCOUNTS INITIALIZATION REPORT    ║
╠════════════════════════════════════════════════╣
║ Total Attempts:           $totalAttempts
║ ✅ Successful:            $successCount
║ ❌ Failed:                $failureCount
║ 🆕 Newly Created:         $newAccountsCreated
║ ♻️  Already Existed:       $existingAccounts
║ Status:                   ${isSuccessful ? '✅ READY' : '⚠️  WITH ERRORS'}
${errors.isNotEmpty ? _errorDetails() : ''}
╚════════════════════════════════════════════════╝
''';
  }

  String _errorDetails() {
    final buffer = StringBuffer('║ Errors:\n');
    for (final entry in errors.entries) {
      buffer.writeln('║   • ${entry.key}: ${entry.value}');
    }
    return buffer.toString();
  }
}
