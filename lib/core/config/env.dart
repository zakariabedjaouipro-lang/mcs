/// Environment variable access.
///
/// Uses Dart's `--dart-define` or `String.fromEnvironment` to read
/// compile-time environment variables. For local development, values
/// can also be passed via `--dart-define-from-file=.env`.
///
/// Example:
/// ```dart
/// flutter run --dart-define-from-file=.env
///
/// // Or manually:
/// flutter run \
///   --dart-define=SUPABASE_URL=https://project.supabase.co \
///   --dart-define=SUPABASE_ANON_KEY=your-key
/// ```
library;

class Env {
  const Env._();

  // ── Supabase ─────────────────────────────────────────────
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://rxwtdbvhxqxvckkllgep.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ4d3RkYnZoeHF4dmNra2xsZ2VwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI2MTA1NTMsImV4cCI6MjA4ODE4NjU1M30.RZfSJBgb9DUq6Fqq_HhgG1dCgtAN-_hBmzHRuaUDP38',
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

  // ── Validation ───────────────────────────────────────────
  /// Quick validation — returns `true` when all required vars are set.
  ///
  /// Checks:
  /// - SUPABASE_URL is not empty and contains valid URL format
  /// - SUPABASE_ANON_KEY is not empty
  static bool get isValid {
    if (supabaseUrl.isEmpty) return false;
    if (!supabaseUrl.contains('supabase.co')) return false;
    if (supabaseAnonKey.isEmpty) return false;
    return true;
  }

  /// Detailed validation errors.
  /// Returns empty list if valid, or list of error messages.
  static List<String> get validationErrors {
    final errors = <String>[];

    if (supabaseUrl.isEmpty) {
      errors.add('SUPABASE_URL is not set');
    } else if (!supabaseUrl.contains('supabase.co')) {
      errors.add('SUPABASE_URL does not appear to be a Supabase URL');
    }

    if (supabaseAnonKey.isEmpty) {
      errors.add('SUPABASE_ANON_KEY is not set');
    }

    return errors;
  }

  /// Returns a user-friendly error message for missing configuration.
  static String get configurationHelpText {
    if (isValid) return 'Configuration is valid';

    return '''
Supabase Configuration Missing or Invalid

Errors:
${validationErrors.map((e) => '  • $e').join('\n')}

To fix, run:
  flutter run --dart-define-from-file=.env

Or manually provide environment variables:
  flutter run \\
    --dart-define=SUPABASE_URL=https://your-project.supabase.co \\
    --dart-define=SUPABASE_ANON_KEY=your-anon-key-here

Find your values at: https://app.supabase.com/project/[PROJECT]/settings/api
''';
  }
}
