/// Main entry point for the application.
///
/// Handles initialization in the correct order:
/// 1. Ensure Flutter binding initialized
/// 2. Initialize Supabase configuration
/// 3. Initialize dependency injection
/// 4. Launch the app with splash screen
library;

import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:mcs/app.dart';
import 'package:mcs/core/config/app_config.dart';
import 'package:mcs/core/config/injection_container.dart';
import 'package:mcs/core/config/supabase_config.dart';
import 'package:mcs/core/screens/error_screen.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Run app with proper error handling and initialization
  unawaited(
    runZonedGuarded(
      () async {
        try {
          // Phase 1: Initialize app configuration
          developer.log('Phase 1: Initializing app config...', name: 'AppInit');
          _initializeAppConfig();

          // Phase 2: Initialize Supabase
          developer.log('Phase 2: Initializing Supabase...', name: 'AppInit');
          await SupabaseConfig.initialize();

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
          );

          // Show error screen as fallback
          runApp(
            MaterialApp(
              home: _ErrorScreenWrapper(
                error: error.toString(),
                stackTrace: stackTrace.toString(),
              ),
            ),
          );
        }
      },
      // Global error handler for uncaught exceptions
      (error, stackTrace) {
        developer.log(
          'Uncaught exception: $error',
          name: 'AppError',
          error: error,
          stackTrace: stackTrace,
        );
      },
    ),
  );
}

/// Initialize app configuration with Supabase credentials
void _initializeAppConfig() {
  AppConfig.initialize(
    supabaseUrl: 'https://rxwtdbvhxqxvckkllgep.supabase.co',
    supabaseAnonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ4d3RkYnZoeHF4dmNra2xsZ2VwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI2MTA1NTMsImV4cCI6MjA4ODE4NjU1M30.RZfSJBgb9DUq6Fqq_HhgG1dCgtAN-_hBmzHRuaUDP38',
    environment: AppEnvironment.production,
  );
}

/// Wrapper widget for error screen during initialization
///
/// Used when app initialization fails before McsApp can be created
class _ErrorScreenWrapper extends StatelessWidget {
  const _ErrorScreenWrapper({
    required this.error,
    required this.stackTrace,
  });

  final String error;
  final String stackTrace;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MCS - Error',
      theme: ThemeData(useMaterial3: true),
      home: ErrorScreen(
        error: '$error\n\n$stackTrace',
        title: 'خطأ حرج في التطبيق',
        subtitle: 'فشل تحميل التطبيق. الرجاء إعادة المحاولة.',
        onRetry: () {
          developer.log('User requested retry', name: 'AppInit');
          // In production, might restart the app or check connection
        },
      ),
    );
  }
}
