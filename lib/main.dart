/// Main entry point for the application.
///
/// Handles initialization in the correct order with timeout protection:
/// 1. Ensure Flutter binding initialized
/// 2. Initialize app configuration
/// 3. Test network connectivity
/// 4. Initialize Supabase with timeout (10s max)
/// 5. Initialize dependency injection
/// 6. Launch the app or show error recovery screen
///
/// The app never hangs indefinitely on the splash screen.
library;

import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:mcs/app.dart';
import 'package:mcs/core/config/app_config.dart';
import 'package:mcs/core/config/injection_container.dart';
import 'package:mcs/core/config/supabase_config.dart';
import 'package:mcs/core/services/supabase_verification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  developer.log(
    'Application startup initiated',
    name: 'AppInit',
    level: 1000,
  );

  try {
    // Phase 1: Initialize app configuration
    developer.log('Phase 1: Initializing app config...', name: 'AppInit');
    _initializeAppConfig();

    // Phase 1.5: Run Supabase verification in background (NON-BLOCKING)
    developer.log(
      'Phase 1.5: Starting Supabase verification in background...',
      name: 'AppInit',
    );

    unawaited(
      Future<void>(() async {
        try {
          final verificationResult = await SupabaseVerificationService.verify(
            supabaseUrl: AppConfig.supabaseUrl,
            anonKey: AppConfig.supabaseAnonKey,
          );

          developer.log(
            verificationResult.toReport(),
            name: 'SupabaseVerification',
          );
        } catch (e) {
          developer.log(
            'Background verification error: $e',
            name: 'SupabaseVerification',
            level: 800,
          );
        }
      }).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          developer.log(
            'Supabase verification timed out (continuing anyway)',
            name: 'SupabaseVerification',
            level: 800,
          );
        },
      ),
    );

    // Phase 2: Initialize Supabase
    developer.log('Phase 2: Initializing Supabase...', name: 'AppInit');

    await SupabaseConfig.initialize();

    developer.log(
      'SUPABASE OK: SupabaseConfig.initialize() completed successfully',
      name: 'SupabaseDebug',
      level: 1000,
    );

    // Phase 3: Initialize dependency injection
    developer.log(
      'Phase 3: Setting up dependency injection...',
      name: 'AppInit',
    );

    await configureDependencies();

    // Phase 4: Launch main app
    developer.log('Phase 4: App ready, launching...', name: 'AppInit');

    runApp(const McsApp());
  } catch (error, stackTrace) {
    developer.log(
      'Initialization failed: $error',
      name: 'AppInit',
      error: error,
      stackTrace: stackTrace,
      level: 2000,
    );

    runApp(
      _ErrorRecoveryApp(
        error: error.toString(),
        stackTrace: stackTrace.toString(),
        onRetry: () {
          developer.log('User requested retry', name: 'AppInit');
          main();
        },
      ),
    );
  }
}

/// Initialize app configuration
void _initializeAppConfig() {
  // Credentials are loaded via AppConfig -> SupabaseConfig -> Env class
  // which uses --dart-define (compile-time) or defaultValues
  AppConfig.initialize(
    supabaseUrl: '',
    supabaseAnonKey: '',
    environment: AppEnvironment.development,
  );

  developer.log(
    '✓ STEP 1: AppConfig initialized',
    name: 'SupabaseVerification',
    level: 1000,
  );
}

/// Error recovery app shown when initialization fails
class _ErrorRecoveryApp extends StatefulWidget {
  const _ErrorRecoveryApp({
    required this.error,
    required this.stackTrace,
    required this.onRetry,
  });

  final String error;
  final String stackTrace;
  final VoidCallback onRetry;

  @override
  State<_ErrorRecoveryApp> createState() => _ErrorRecoveryAppState();
}

class _ErrorRecoveryAppState extends State<_ErrorRecoveryApp> {
  bool _isRetrying = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withValues(alpha: 0.1),
                  ),
                  child: const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'خطأ في التطبيق',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.error,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isRetrying ? null : _handleRetry,
                    child: _isRetrying
                        ? const CircularProgressIndicator()
                        : const Text('إعادة محاولة'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleRetry() async {
    setState(() => _isRetrying = true);

    await Future<void>.delayed(const Duration(seconds: 1));

    widget.onRetry();
  }
}
