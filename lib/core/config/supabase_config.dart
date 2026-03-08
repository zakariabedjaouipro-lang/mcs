/// Supabase client initialization and access.
library;

import 'dart:developer';

import 'package:mcs/core/config/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  const SupabaseConfig._();

  /// Initializes the Supabase client.
  ///
  /// Must be called once before any Supabase operations,
  /// typically in the app's `main()` function.
  static Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: Env.supabaseUrl,
        anonKey: Env.supabaseAnonKey,
        realtimeClientOptions: const RealtimeClientOptions(
          logLevel: RealtimeLogLevel.info,
        ),
      );
      log('Supabase initialized successfully', name: 'SupabaseConfig');
    } catch (e, st) {
      log(
        'Failed to initialize Supabase: $e',
        name: 'SupabaseConfig',
        error: e,
        stackTrace: st,
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
}

