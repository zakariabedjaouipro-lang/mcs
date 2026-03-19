/// Main entry point for the application.
library;

import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:mcs/app.dart';
import 'package:mcs/core/config/app_config.dart';
import 'package:mcs/core/config/env.dart';
import 'package:mcs/core/config/injection_container.dart';
import 'package:mcs/core/config/supabase_config.dart';
import 'package:mcs/core/services/supabase_verification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  developer.log(
    '🚀 Application startup initiated',
    name: 'AppInit',
    level: 1000,
  );

  try {
    // Phase 1: Initialize app configuration
    developer.log('📋 Phase 1: Initializing app config...', name: 'AppInit');
    _initializeAppConfig();

    // Phase 2: Initialize Supabase
    developer.log('🔌 Phase 2: Initializing Supabase...', name: 'AppInit');
    await SupabaseConfig.initialize();
    developer.log('✅ SUPABASE OK: Connected successfully', name: 'AppInit');

    // Phase 3: Initialize dependency injection
    developer.log('📦 Phase 3: Setting up dependency injection...',
        name: 'AppInit');
    await configureDependencies();
    developer.log('✅ DI OK: Dependencies configured', name: 'AppInit');

    // Phase 4: Verify database tables exist (اختياري - للتأكد)
    await _verifyDatabaseTables();

    // Phase 5: Run Supabase verification in background (NON-BLOCKING)
    developer.log('🔍 Phase 5: Starting Supabase verification...',
        name: 'AppInit');
    _runBackgroundVerification();

    // Phase 6: Launch main app
    developer.log('🎉 Phase 6: App ready, launching...', name: 'AppInit');
    runApp(const McsApp());
  } catch (error, stackTrace) {
    developer.log(
      '❌ Initialization failed: $error',
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
          developer.log('🔄 User requested retry', name: 'AppInit');
          main();
        },
      ),
    );
  }
}

/// Initialize app configuration
void _initializeAppConfig() {
  // طباعة قيم البيئة للتأكد
  developer.log(
    '🔧 Env values: URL=${Env.supabaseUrl}, Key=${Env.supabaseAnonKey.substring(0, 10)}...',
    name: 'AppInit',
  );

  AppConfig.initialize(
    supabaseUrl: Env.supabaseUrl,
    supabaseAnonKey: Env.supabaseAnonKey,
  );

  developer.log('✅ AppConfig initialized', name: 'AppInit');
}

/// تشغيل التحقق من Supabase في الخلفية
void _runBackgroundVerification() {
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
          '⚠️ Background verification error: $e',
          name: 'SupabaseVerification',
          level: 800,
        );
      }
    }).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        developer.log(
          '⏱️ Supabase verification timed out (continuing anyway)',
          name: 'SupabaseVerification',
          level: 800,
        );
      },
    ),
  );
}

/// التحقق من وجود الجداول المهمة
Future<void> _verifyDatabaseTables() async {
  try {
    final supabase = SupabaseConfig.client;

    // محاولة جلب بيانات من جدول user_approvals (بدون أخطاء)
    try {
      await supabase.from('user_approvals').select('count').limit(1);
      developer.log('✅ Table "user_approvals" exists', name: 'AppInit');
    } catch (e) {
      developer.log('⚠️ Table "user_approvals" may not exist: $e',
          name: 'AppInit');
    }

    // تحقق من جداول أخرى مهمة
    final tables = ['users', 'clinics', 'doctors', 'patients'];
    for (final table in tables) {
      try {
        await supabase.from(table).select('count').limit(1);
        developer.log('✅ Table "$table" exists', name: 'AppInit');
      } catch (e) {
        developer.log('⚠️ Table "$table" may not exist: $e', name: 'AppInit');
      }
    }
  } catch (e) {
    developer.log('⚠️ Database verification error: $e', name: 'AppInit');
  }
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
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SelectableText(
                    widget.error,
                    textAlign: TextAlign.center,
                  ),
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
    await Future<void>.delayed(const Duration(milliseconds: 500));
    widget.onRetry();
  }
}
