/// Supabase client initialization and access.
library;

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:mcs/core/config/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  const SupabaseConfig._();

  /// Initializes the Supabase client.
  ///
  /// Must be called once before any Supabase operations,
  /// typically in the app's `main()` function.
  ///
  /// Throws [FlutterError] if environment variables are not configured.
  static Future<void> initialize() async {
    // Validate environment variables
    if (!Env.isValid) {
      const errorMsg = 'Supabase environment variables not configured!\n'
          'Ensure SUPABASE_URL and SUPABASE_ANON_KEY are set.\n'
          'Run: flutter run --dart-define-from-file=.env\n'
          'Or: flutter run '
          '--dart-define=SUPABASE_URL=https://rxwtdbvhxqxvckkllgep.supabase.co '
          '--dart-define=SUPABASE_ANON_KEY=your-anon-key';

      log(
        errorMsg,
        name: 'SupabaseConfig',
        level: 2000, // severe
      );

      if (kDebugMode) {
        throw FlutterError(errorMsg);
      }
      throw FlutterError(errorMsg);
    }

    try {
      log(
        'Initializing Supabase with URL: ${Env.supabaseUrl}',
        name: 'SupabaseConfig',
      );

      await Supabase.initialize(
        url: Env.supabaseUrl,
        anonKey: Env.supabaseAnonKey,
        realtimeClientOptions: const RealtimeClientOptions(
          logLevel: RealtimeLogLevel.info,
        ),
      );

      log(
        'Supabase initialized successfully',
        name: 'SupabaseConfig',
      );
    } catch (e, st) {
      log(
        'Failed to initialize Supabase: $e',
        name: 'SupabaseConfig',
        error: e,
        stackTrace: st,
        level: 2000, // severe
      );
      rethrow;
    }
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
