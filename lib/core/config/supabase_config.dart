/// Supabase client initialization and access.
///
/// Supports two initialization strategies:
/// 1. Strategy A (Preferred): Compile-time via --dart-define environment variables
/// 2. Strategy B (Fallback): Runtime configuration from AppConfig
///
/// This dual-strategy approach ensures the app doesn't crash if dart-define
/// variables are not provided at compile time.
library;

import 'dart:async';
import 'dart:developer';

import 'package:mcs/core/config/app_config.dart';
import 'package:mcs/core/config/env.dart';
import 'package:mcs/core/services/connectivity_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  const SupabaseConfig._();

  /// Initializes the Supabase client with fallback strategy support.
  ///
  /// **Initialization Strategy:**
  /// 1. First, attempts to use compile-time environment variables (--dart-define)
  /// 2. If those are empty, falls back to AppConfig runtime values
  /// 3. If both are missing, throws detailed error with setup instructions
  ///
  /// **Timeout Protection:**
  /// - Supabase initialization has a 10-second timeout
  /// - If exceeded, throws TimeoutException with diagnostics
  /// - Network connectivity is tested before initialization
  ///
  /// **Advantages of this approach:**
  /// - Secure in production (uses dart-define)
  /// - Works in development without requiring dart-define
  /// - Prevents black screen crashes with timeout protection
  /// - Provides helpful error messages with diagnostics
  /// - Never hangs indefinitely
  ///
  /// Must be called once before any Supabase operations,
  /// typically in the app's `main()` function after AppConfig.initialize().
  ///
  /// Throws [SupabaseInitializationException] with detailed diagnostics
  /// if configuration cannot be resolved through either strategy.
  static Future<void> initialize({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    try {
      // Strategy A: Try compile-time environment variables first (--dart-define)
      const envUrl = Env.supabaseUrl;
      const envAnonKey = Env.supabaseAnonKey;

      final isEnvValid = envUrl.isNotEmpty &&
          envUrl.contains('supabase.co') &&
          envAnonKey.isNotEmpty;

      final String url;
      final String anonKey;
      final String configSource;

      if (isEnvValid) {
        // Strategy A succeeded: using compile-time variables
        url = envUrl;
        anonKey = envAnonKey;
        configSource = 'dart-define environment variables';

        log(
          'Using Strategy A: Environment variables (--dart-define)',
          name: 'SupabaseConfig.Init',
          level: 1000,
        );
      } else if (AppConfig.supabaseUrl.isNotEmpty &&
          AppConfig.supabaseAnonKey.isNotEmpty) {
        // Strategy B: Fallback to runtime AppConfig values
        url = AppConfig.supabaseUrl;
        anonKey = AppConfig.supabaseAnonKey;
        configSource = 'AppConfig runtime values';

        log(
          'Using Strategy B: Runtime AppConfig values (fallback)',
          name: 'SupabaseConfig.Init',
          level: 1000,
        );
      } else {
        // Both strategies failed - provide helpful error
        _throwConfigurationError(envUrl, envAnonKey);
      }

      // Validate Supabase URL format
      if (!url.contains('supabase.co')) {
        throw SupabaseInitializationException(
          'Invalid Supabase URL format: $url\n'
          'URL must contain "supabase.co"',
        );
      }

      // Log initialization start
      final keyPreview = anonKey.length > 20
          ? '${anonKey.substring(0, 10)}...${anonKey.substring(anonKey.length - 10)}'
          : '***REDACTED***';
      log(
        'Initializing Supabase from $configSource\n'
        'URL: ${url.replaceRange(0, url.length > 20 ? 20 : 0, '***')}***\n'
        'Anon Key preview: $keyPreview\n'
        'Timeout: ${timeout.inSeconds}s',
        name: 'SupabaseConfig.Init',
        level: 1000,
      );

      // Pre-initialization network check (optional, for diagnostics)
      _checkNetworkAvailability(url);

      // Initialize Supabase with timeout protection
      await _initializeWithTimeout(url, anonKey, timeout);

      log(
        'Supabase initialized successfully from $configSource',
        name: 'SupabaseConfig.Init',
        level: 1000,
      );
    } catch (e, st) {
      log(
        'Supabase initialization failed: $e',
        name: 'SupabaseConfig.Init',
        error: e,
        stackTrace: st,
        level: 2000, // severe
      );
      rethrow;
    }
  }

  /// Initialize Supabase with timeout protection.
  static Future<void> _initializeWithTimeout(
    String url,
    String anonKey,
    Duration timeout,
  ) async {
    try {
      await Supabase.initialize(
        url: url,
        anonKey: anonKey,
        realtimeClientOptions: const RealtimeClientOptions(
          logLevel: RealtimeLogLevel.info,
        ),
      ).timeout(
        timeout,
        onTimeout: () {
          throw TimeoutException(
            'Supabase initialization exceeded ${timeout.inSeconds}s timeout.\n'
            'This usually indicates:\n'
            '- Network connectivity issue\n'
            '- DNS resolution failure\n'
            '- Supabase server unreachable\n'
            '- Invalid Supabase URL or key\n\n'
            'Check your internet connection and try again.',
          );
        },
      );
    } on TimeoutException catch (e) {
      throw SupabaseInitializationException(
        'TIMEOUT: Supabase initialization took longer than ${timeout.inSeconds}s\n\n'
        '${e.message}',
      );
    }
  }

  /// Check network availability asynchronously (non-blocking).
  static void _checkNetworkAvailability(String url) {
    // Fire and forget - log network status but don't block initialization
    unawaited(
      Future<void>(() async {
        try {
          final hasInternet = await ConnectivityService.hasInternet();
          final diagnostic =
              await ConnectivityService.diagnoseSupabaseConnectivity(url);

          if (!hasInternet) {
            log(
              'Network check: Device appears to be offline\n$diagnostic',
              name: 'SupabaseConfig.NetworkCheck',
              level: 800, // warning
            );
          } else {
            log(
              'Network check: OK\n$diagnostic',
              name: 'SupabaseConfig.NetworkCheck',
              level: 1000,
            );
          }
        } catch (e) {
          log(
            'Network diagnostic failed: $e',
            name: 'SupabaseConfig.NetworkCheck',
            level: 800,
          );
        }
      }).catchError((_) {}),
    );
  }

  /// Throws a detailed SupabaseInitializationException with diagnostic information.
  static Never _throwConfigurationError(String envUrl, String envAnonKey) {
    final diagnostics = <String>[
      '═══════════════════════════════════════════════════════',
      'SUPABASE INITIALIZATION FAILED',
      '═══════════════════════════════════════════════════════',
      '',
      '❌ Configuration Error:',
      '   Neither Strategy A (--dart-define) nor Strategy B (AppConfig)',
      '   could provide valid Supabase credentials.',
      '',
      '📋 Diagnostic Information:',
      '   Strategy A (--dart-define):',
      '     • SUPABASE_URL: ${envUrl.isEmpty ? 'NOT SET' : 'invalid format'}',
      '     • SUPABASE_ANON_KEY: ${envAnonKey.isEmpty ? 'NOT SET' : 'configured'}',
      '',
      '   Strategy B (AppConfig):',
      '     • supabaseUrl: ${AppConfig.supabaseUrl.isEmpty ? 'NOT SET' : 'configured'}',
      '     • supabaseAnonKey: ${AppConfig.supabaseAnonKey.isEmpty ? 'NOT SET' : 'configured'}',
      '',
      '🔧 How to Fix:',
      '',
      '   ✅ Option 1 - Use --dart-define (RECOMMENDED FOR PRODUCTION):',
      r'      flutter run \',
      r'        --dart-define=SUPABASE_URL=https://your-project.supabase.co \',
      '        --dart-define=SUPABASE_ANON_KEY=your-anon-key',
      '',
      '   ✅ Option 2 - Use environment file:',
      '      flutter run --dart-define-from-file=.env',
      '',
      '   ✅ Option 3 - Set AppConfig in main.dart:',
      '      AppConfig.initialize(',
      "        supabaseUrl: 'https://your-project.supabase.co',",
      "        supabaseAnonKey: 'your-anon-key',",
      '      );',
      '',
      '📚 Find your credentials at:',
      '   https://app.supabase.com/project/[YOUR-PROJECT]/settings/api',
      '',
      '═══════════════════════════════════════════════════════',
    ];

    final message = diagnostics.join('\n');
    log(message, name: 'SupabaseConfig.Init', level: 2000);
    throw SupabaseInitializationException(message);
  }

  /// The global Supabase client instance.
  static SupabaseClient get client => Supabase.instance.client;

  /// Shortcut to the GoTrue auth client.
  static GoTrueClient get auth => client.auth;

  /// The currently signed-in user, or `null`.
  static User? get currentUser => auth.currentUser;

  /// The current session, or `null`.
  static Session? get currentSession => auth.currentSession;

  /// Whether a user is currently authenticated.
  static bool get isAuthenticated => currentUser != null;

  /// Stream of auth state changes (login, logout, token refresh, etc.).
  static Stream<AuthState> get onAuthStateChange => auth.onAuthStateChange;

  /// Validates that Supabase is properly initialized.
  ///
  /// Returns `true` if Supabase client is ready, `false` otherwise.
  static bool get isInitialized {
    try {
      client;
      return true;
    } catch (_) {
      return false;
    }
  }
}

/// Custom exception for Supabase initialization failures.
///
/// Provides detailed diagnostic information about which configuration
/// strategy failed and how to fix it.
class SupabaseInitializationException implements Exception {
  SupabaseInitializationException(this.message);

  /// Detailed error message with diagnostic information
  final String message;

  @override
  String toString() => message;
}
