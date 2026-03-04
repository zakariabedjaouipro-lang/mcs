/// Environment variable access.
///
/// Uses Dart's `--dart-define` or `String.fromEnvironment` to read
/// compile-time environment variables. For local development, values
/// can also be passed via `--dart-define-from-file=.env`.
library;

class Env {
  const Env._();

  // ── Supabase ─────────────────────────────────────────────
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
  );

  // ── Signaling Server (WebRTC) ──────────────────────────────
  static const String signalingUrl = String.fromEnvironment(
    'SIGNALING_URL',
    defaultValue: 'http://localhost:3001',
  );

  // ── Environment ──────────────────────────────────────────
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  /// Quick validation — returns `true` when all required vars are set.
  static bool get isValid =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
