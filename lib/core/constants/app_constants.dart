/// Application-wide constants.
library;

abstract class AppConstants {
  // ── App ──────────────────────────────────────────────────
  static const String appName = 'MCS';
  static const String appFullName = 'Medical Clinic Management System';
  static const String appScheme = 'io.mcs.app';
  static const String deepLinkHost = 'auth-callback';
  static const String deepLinkUrl = '$appScheme://$deepLinkHost/';

  // ── Supported Locales ────────────────────────────────────
  static const String arabicCode = 'ar';
  static const String englishCode = 'en';
  static const String defaultLocale = arabicCode;

  // ── Auth ─────────────────────────────────────────────────
  static const int otpLength = 6;
  static const int otpExpiryMinutes = 5;
  static const int maxLoginAttempts = 5;
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 64;

  // ── Subscription ─────────────────────────────────────────
  static const int trialDays = 30;
  static const int warningBeforeExpiryDays = 7;
  static const int criticalWarningDays = 3;
  static const int finalWarningDays = 1;

  // ── Pagination ───────────────────────────────────────────
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // ── File Upload ──────────────────────────────────────────
  static const int maxImageSizeMB = 5;
  static const int maxFileSizeMB = 20;
  static const List<String> allowedImageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'webp',
  ];
  static const List<String> allowedDocExtensions = [
    'pdf',
    'doc',
    'docx',
    'xls',
    'xlsx',
  ];

  // ── Video Call ───────────────────────────────────────────
  static const int maxCallDurationMinutes = 60;
  static const int callRingTimeoutSeconds = 30;

  // ── Specialties Count ────────────────────────────────────
  static const int totalSpecialties = 33;

  // ── Storage Buckets (Supabase) ───────────────────────────
  static const String avatarsBucket = 'avatars';
  static const String reportsBucket = 'reports';
  static const String labResultsBucket = 'lab-results';
  static const String clinicLogosBucket = 'clinic-logos';
  static const String bugScreenshotsBucket = 'bug-screenshots';
}
