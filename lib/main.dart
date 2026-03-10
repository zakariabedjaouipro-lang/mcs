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
    // Fire and forget - verification runs in background
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

    // Phase 2: Initialize Supabase (with timeout protection)
    developer.log('Phase 2: Initializing Supabase...', name: 'AppInit');
    developer.log(
      'START INIT: About to call SupabaseConfig.initialize()',
      name: 'SupabaseDebug',
      level: 1000,
    );

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

    // Show error recovery screen instead of crashing
    runApp(
      _ErrorRecoveryApp(
        error: error.toString(),
        stackTrace: stackTrace.toString(),
        onRetry: () {
          // Restart the app by re-running main
          developer.log('User requested retry', name: 'AppInit');
          main();
        },
      ),
    );
  }
}

/// Initialize app configuration with Supabase credentials
void _initializeAppConfig() {
  AppConfig.initialize(
    supabaseUrl: 'https://rxwtdbvhxqxvckkllgep.supabase.co',
    supabaseAnonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml2Z3V4anlnaGZuZGxpcHRtaW5rIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI2MTAzOTAsImV4cCI6MjA4ODE4NjM5MH0.5mXSPfGwan9b37oo2xeOL_kG3ajrjcoAWWpZdurJnSQ',
    environment: AppEnvironment.production,
  );

  developer.log(
    '✓ STEP 1: AppConfig loaded with credentials',
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
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Error icon
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

                // Title
                const Text(
                  'خطأ في التطبيق',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Error message
                Text(
                  widget.error,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Stack trace (debug only)
                if (widget.stackTrace.isNotEmpty) ...[
                  const Divider(),
                  const SizedBox(height: 12),
                  const Text(
                    'تفاصيل الخطأ:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        widget.stackTrace,
                        style: const TextStyle(
                          fontSize: 10,
                          fontFamily: 'monospace',
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Retry button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isRetrying ? null : _handleRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      disabledBackgroundColor: Colors.grey[300],
                    ),
                    child: _isRetrying
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'إعادة محاولة',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 12),

                // Help text
                const Text(
                  'تأكد من:\n'
                  '• اتصالك بالإنترنت\n'
                  '• صحة بيانات اعتماد Supabase\n'
                  '• إمكانية الوصول إلى خوادم Supabase',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black45,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
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

    // Wait a moment before retrying
    await Future<void>.delayed(const Duration(seconds: 1));

    widget.onRetry();
  }
}
