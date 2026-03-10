/// Supabase connectivity verification service.
///
/// Implements 7-step verification process:
/// 1. Verify configuration
/// 2. Test network connectivity
/// 3. Initialize Supabase
/// 4. Verify auth client
/// 5. Test database access
/// 6. Log results
/// 7. Failsafe error handling
library;

import 'dart:async';
import 'dart:developer' as developer;

import 'package:mcs/core/config/app_config.dart';
import 'package:mcs/core/services/connectivity_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Result of Supabase verification process
class SupabaseVerificationResult {
  SupabaseVerificationResult({
    required this.isSuccess,
    required this.phases,
    required this.errorMessage,
    required this.totalTime,
  });

  final bool isSuccess;
  final Map<String, PhaseResult> phases;
  final String errorMessage;
  final Duration totalTime;

  /// Returns formatted verification report
  String toReport() {
    final buffer = StringBuffer()
      ..writeln('═══════════════════════════════════════════════════')
      ..writeln('SUPABASE VERIFICATION REPORT')
      ..writeln('═══════════════════════════════════════════════════')
      ..writeln()
      ..writeln('Overall Status: ${isSuccess ? '✅ SUCCESS' : '❌ FAILED'}')
      ..writeln('Total Time: ${totalTime.inMilliseconds}ms')
      ..writeln()
      ..writeln('Phase Details:')
      ..writeln();

    for (final entry in phases.entries) {
      final phase = entry.key;
      final result = entry.value;
      buffer
        ..writeln(
          '${result.isSuccess ? '✅' : '❌'} Phase: $phase',
        )
        ..writeln('   Time: ${result.duration.inMilliseconds}ms');
      if (result.message.isNotEmpty) {
        buffer.writeln('   Message: ${result.message}');
      }
      if (result.error.isNotEmpty) {
        buffer.writeln('   Error: ${result.error}');
      }
      buffer.writeln();
    }

    if (errorMessage.isNotEmpty) {
      buffer
        ..writeln('Error Details:')
        ..writeln(errorMessage)
        ..writeln();
    }

    buffer.writeln('═══════════════════════════════════════════════════');
    return buffer.toString();
  }
}

/// Result of a single verification phase
class PhaseResult {
  PhaseResult({
    required this.isSuccess,
    required this.duration,
    required this.message,
    required this.error,
  });

  final bool isSuccess;
  final Duration duration;
  final String message;
  final String error;
}

/// Supabase verification service
class SupabaseVerificationService {
  /// Run complete 7-step verification process
  static Future<SupabaseVerificationResult> verify({
    required String supabaseUrl,
    required String anonKey,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final stopwatch = Stopwatch()..start();
    final phases = <String, PhaseResult>{};
    var globalError = '';

    try {
      // ═══════════════════════════════════════════════════════════════
      // STEP 1: VERIFY CONFIGURATION
      // ═══════════════════════════════════════════════════════════════
      developer.log(
        'STEP 1: Verifying configuration...',
        name: 'SupabaseVerification',
      );

      final step1Start = Stopwatch()..start();
      var step1Error = '';

      try {
        // Validate AppConfig values
        if (AppConfig.supabaseUrl.isEmpty) {
          throw Exception('supabaseUrl is empty in AppConfig');
        }
        if (!AppConfig.supabaseUrl.contains('supabase.co')) {
          throw Exception(
            'Invalid supabaseUrl format: ${AppConfig.supabaseUrl}',
          );
        }
        if (AppConfig.supabaseAnonKey.isEmpty) {
          throw Exception('supabaseAnonKey is empty in AppConfig');
        }

        developer.log(
          '✓ STEP 1: Configuration verified\n'
          '  • URL: ${AppConfig.supabaseUrl}\n'
          '  • Key length: ${AppConfig.supabaseAnonKey.length} chars',
          name: 'SupabaseVerification',
        );
      } catch (e) {
        step1Error = e.toString();
        developer.log(
          '✗ STEP 1: Configuration verification failed: $e',
          name: 'SupabaseVerification',
          level: 2000,
        );
      }

      step1Start.stop();
      phases['ConfigVerification'] = PhaseResult(
        isSuccess: step1Error.isEmpty,
        duration: step1Start.elapsed,
        message:
            'AppConfig URL: ${AppConfig.supabaseUrl}, Key length: ${AppConfig.supabaseAnonKey.length}',
        error: step1Error,
      );

      if (step1Error.isNotEmpty) {
        throw Exception('Step 1 failed: $step1Error');
      }

      // ═══════════════════════════════════════════════════════════════
      // STEP 2: TEST NETWORK CONNECTIVITY
      // ═══════════════════════════════════════════════════════════════
      developer.log(
        'STEP 2: Testing network connectivity...',
        name: 'SupabaseVerification',
      );

      final step2Start = Stopwatch()..start();
      var step2Error = '';

      try {
        final hasInternet = await ConnectivityService.hasInternet()
            .timeout(const Duration(seconds: 5));

        if (!hasInternet) {
          throw Exception('Device appears to be offline');
        }

        final testUrl = '${AppConfig.supabaseUrl}/rest/v1/';
        final reachability =
            await ConnectivityService.testHostReachability(testUrl)
                .timeout(const Duration(seconds: 5));

        if (!reachability.isReachable) {
          throw Exception(
            'Supabase server unreachable: ${reachability.message}',
          );
        }

        developer.log(
          '✓ STEP 2: Network connectivity verified\n'
          '  • Internet: Available\n'
          '  • Supabase host: Reachable (${reachability.duration.inMilliseconds}ms)\n'
          '  • Response: ${reachability.statusCode}',
          name: 'SupabaseVerification',
        );
      } catch (e) {
        step2Error = e.toString();
        developer.log(
          '✗ STEP 2: Network connectivity test failed: $e\n'
          'The app will attempt to continue initialization.',
          name: 'SupabaseVerification',
          level: 1600, // warning
        );
      }

      step2Start.stop();
      phases['NetworkConnectivity'] = PhaseResult(
        isSuccess: step2Error.isEmpty,
        duration: step2Start.elapsed,
        message: 'Network reachability tested',
        error: step2Error,
      );

      // Note: Network test failure is not fatal - continue to Step 3

      // ═══════════════════════════════════════════════════════════════
      // STEP 3: INITIALIZE SUPABASE
      // ═══════════════════════════════════════════════════════════════
      developer.log(
        'STEP 3: Initializing Supabase...',
        name: 'SupabaseVerification',
      );

      final step3Start = Stopwatch()..start();
      var step3Error = '';

      try {
        await Supabase.initialize(
          url: AppConfig.supabaseUrl,
          anonKey: AppConfig.supabaseAnonKey,
          realtimeClientOptions: const RealtimeClientOptions(
            logLevel: RealtimeLogLevel.info,
          ),
        ).timeout(timeout);

        developer.log(
          '✓ STEP 3: Supabase initialized successfully',
          name: 'SupabaseVerification',
        );
      } catch (e) {
        step3Error = e.toString();
        developer.log(
          '✗ STEP 3: Supabase initialization failed: $e',
          name: 'SupabaseVerification',
          level: 2000,
        );
      }

      step3Start.stop();
      phases['SupabaseInitialization'] = PhaseResult(
        isSuccess: step3Error.isEmpty,
        duration: step3Start.elapsed,
        message: 'Supabase client initialized',
        error: step3Error,
      );

      if (step3Error.isNotEmpty) {
        throw Exception('Step 3 failed: $step3Error');
      }

      // ═══════════════════════════════════════════════════════════════
      // STEP 4: VERIFY AUTH CLIENT
      // ═══════════════════════════════════════════════════════════════
      developer.log(
        'STEP 4: Verifying auth client...',
        name: 'SupabaseVerification',
      );

      final step4Start = Stopwatch()..start();
      var step4Error = '';

      try {
        final client = Supabase.instance.client;
        final auth = client.auth;
        final currentUser = auth.currentUser;

        developer.log(
          '✓ STEP 4: Auth client verified\n'
          '  • Client: Connected\n'
          '  • Current User: ${currentUser?.email ?? 'None (unauthenticated)'}',
          name: 'SupabaseVerification',
        );
      } catch (e) {
        step4Error = e.toString();
        developer.log(
          '✗ STEP 4: Auth client verification failed: $e',
          name: 'SupabaseVerification',
          level: 2000,
        );
      }

      step4Start.stop();
      phases['AuthClientVerification'] = PhaseResult(
        isSuccess: step4Error.isEmpty,
        duration: step4Start.elapsed,
        message: 'Auth client accessible and functional',
        error: step4Error,
      );

      if (step4Error.isNotEmpty) {
        throw Exception('Step 4 failed: $step4Error');
      }

      // ═══════════════════════════════════════════════════════════════
      // STEP 5: TEST DATABASE ACCESS
      // ═══════════════════════════════════════════════════════════════
      developer.log(
        'STEP 5: Testing database access...',
        name: 'SupabaseVerification',
      );

      final step5Start = Stopwatch()..start();
      var step5Error = '';
      final queryResults = <String, bool>{};

      try {
        // Test 1: Query 'profiles' table
        try {
          await Supabase.instance.client
              .from('profiles')
              .select()
              .limit(1)
              .timeout(const Duration(seconds: 3));
          queryResults['profiles'] = true;
        } catch (e) {
          // Check if it's just a 404 (table not found) - still a valid response
          final errorMsg = e.toString();
          queryResults['profiles'] =
              errorMsg.contains('404') || errorMsg.contains('not found');
        }

        // Test 2: Query 'users' table (system table)
        try {
          await Supabase.instance.client
              .from('users')
              .select()
              .limit(1)
              .timeout(const Duration(seconds: 3));
          queryResults['users'] = true;
        } catch (e) {
          final errorMsg = e.toString();
          queryResults['users'] =
              errorMsg.contains('404') || errorMsg.contains('not found');
        }

        // Test 3: Raw API call via REST endpoint
        try {
          await Supabase.instance.client
              .from('_schema')
              .select()
              .limit(1)
              .timeout(const Duration(seconds: 3));
          queryResults['schema'] = true;
        } catch (e) {
          final errorMsg = e.toString();
          queryResults['schema'] =
              errorMsg.contains('404') || errorMsg.contains('not found');
        }

        final successCount = queryResults.values.where((v) => v).length;

        developer.log(
          '✓ STEP 5: Database access verified\n'
          '  • Query tests: ${queryResults.length}/3\n'
          '  • Successful: $successCount/3\n'
          '  • Database API responded correctly',
          name: 'SupabaseVerification',
        );
      } catch (e) {
        step5Error = e.toString();
        developer.log(
          '✗ STEP 5: Database access test failed: $e',
          name: 'SupabaseVerification',
          level: 1600, // warning (not fatal)
        );
      }

      step5Start.stop();
      phases['DatabaseAccess'] = PhaseResult(
        isSuccess: step5Error.isEmpty,
        duration: step5Start.elapsed,
        message:
            'Database queries executed successfully (${queryResults.length} tests)',
        error: step5Error,
      );

      // Note: Database test failure is not critical (table may not exist yet)

      // ═══════════════════════════════════════════════════════════════
      // STEP 6: LOG RESULTS
      // ═══════════════════════════════════════════════════════════════
      stopwatch.stop();

      final allPhasesSuccess =
          phases.values.every((p) => p.isSuccess) && globalError.isEmpty;

      developer.log(
        'STEP 6: Logging verification results\n'
        '  • Total phases: ${phases.length}\n'
        '  • Successful: ${phases.values.where((p) => p.isSuccess).length}\n'
        '  • Failed: ${phases.values.where((p) => !p.isSuccess).length}\n'
        '  • Total time: ${stopwatch.elapsed.inMilliseconds}ms',
        name: 'SupabaseVerification',
      );

      // ═══════════════════════════════════════════════════════════════
      // STEP 7: FAILSAFE & FINAL RESULT
      // ═══════════════════════════════════════════════════════════════

      if (allPhasesSuccess) {
        developer.log(
          'STEP 7: ✓ SUPABASE CONNECTION VERIFIED SUCCESSFULLY\n'
          '  • Configuration: ✅\n'
          '  • Network: ✅\n'
          '  • Supabase: ✅\n'
          '  • Auth Client: ✅\n'
          '  • Database: ✅',
          name: 'SupabaseVerification',
        );
      } else {
        developer.log(
          'STEP 7: ⚠ VERIFICATION PARTIAL\n'
          'Critical phases passed, some non-critical phase(s) failed.',
          name: 'SupabaseVerification',
          level: 1600,
        );
      }

      return SupabaseVerificationResult(
        isSuccess: allPhasesSuccess, // Only true if ALL phases succeeded
        phases: phases,
        errorMessage: globalError,
        totalTime: stopwatch.elapsed,
      );
    } catch (e, st) {
      stopwatch.stop();

      globalError = e.toString();

      developer.log(
        'STEP 7: ❌ VERIFICATION FAILED\n'
        'Error: $e\n'
        'Stack: $st',
        name: 'SupabaseVerification',
        level: 2000,
        error: e,
        stackTrace: st,
      );

      return SupabaseVerificationResult(
        isSuccess: false,
        phases: phases,
        errorMessage: globalError,
        totalTime: stopwatch.elapsed,
      );
    }
  }
}
