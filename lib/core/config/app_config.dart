/// Application-wide configuration.
///
/// Manages environment settings, API keys, and app metadata.
library;

enum AppEnvironment { development, staging, production }

class AppConfig {
  const AppConfig._();

  // ── App Info ──────────────────────────────────────────────
  static const String appName = 'MCS';
  static const String appNameFull = 'Medical Clinic Management System';
  static const String appVersion = '1.0.0';
  static const int appBuildNumber = 1;
  static const String defaultLocale = 'ar';

  // ── Environment ──────────────────────────────────────────
  static AppEnvironment _environment = AppEnvironment.development;

  static AppEnvironment get environment => _environment;

  static void setEnvironment(AppEnvironment env) {
    _environment = env;
  }

  static bool get isDevelopment => _environment == AppEnvironment.development;
  static bool get isStaging => _environment == AppEnvironment.staging;
  static bool get isProduction => _environment == AppEnvironment.production;

  // ── Supabase ─────────────────────────────────────────────
  /// Loaded at runtime from environment variables.
  static String supabaseUrl = '';
  static String supabaseAnonKey = '';

  // ── Signaling Server (WebRTC) ───────────────────────────────
  static String signalingUrl = '';

  // ── Firebase ─────────────────────────────────────────────
  // Firebase is configured via google-services.json / GoogleService-Info.plist

  // ── Timeouts & Limits ────────────────────────────────────
  static const Duration httpTimeout = Duration(seconds: 30);
  static const int otpLength = 6;
  static const Duration otpExpiry = Duration(minutes: 5);
  static const int maxLoginAttempts = 5;
  static const int trialDays = 30;
  static const int subscriptionWarningDays = 7;

  // ── Pagination ───────────────────────────────────────────
  static const int defaultPageSize = 20;

  // ── Initialization ───────────────────────────────────────
  /// Call once at app startup to hydrate config from env vars.
  static void initialize({
    required String supabaseUrl,
    required String supabaseAnonKey,
    String? signalingUrl,
    AppEnvironment environment = AppEnvironment.development,
  }) {
    AppConfig.supabaseUrl = supabaseUrl;
    AppConfig.supabaseAnonKey = supabaseAnonKey;
    if (signalingUrl != null) AppConfig.signalingUrl = signalingUrl;
    _environment = environment;
  }
}