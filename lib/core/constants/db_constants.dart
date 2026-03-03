/// Supabase database table and column name constants.
///
/// Centralises all DB identifiers to avoid typos and enable
/// easy refactoring if table / column names change.
library;

abstract class DbTables {
  static const String users = 'users';
  static const String clinics = 'clinics';
  static const String specialties = 'specialties';
  static const String doctors = 'doctors';
  static const String patients = 'patients';
  static const String appointments = 'appointments';
  static const String videoSessions = 'video_sessions';
  static const String prescriptions = 'prescriptions';
  static const String vitalSigns = 'vital_signs';
  static const String labResults = 'lab_results';
  static const String invoices = 'invoices';
  static const String inventory = 'inventory';
  static const String subscriptions = 'subscriptions';
  static const String subscriptionCodes = 'subscription_codes';
  static const String exchangeRates = 'exchange_rates';
  static const String notifications = 'notifications';
  static const String countries = 'countries';
  static const String regions = 'regions';
  static const String autismAssessments = 'autism_assessments';
  static const String systemLogs = 'system_logs';
  static const String reports = 'reports';
  static const String bugReports = 'bug_reports';
}

// ── Common Column Names ────────────────────────────────────
abstract class DbColumns {
  static const String id = 'id';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
  static const String isActive = 'is_active';
  static const String userId = 'user_id';
  static const String clinicId = 'clinic_id';
  static const String patientId = 'patient_id';
  static const String doctorId = 'doctor_id';
  static const String status = 'status';
  static const String notes = 'notes';
  static const String currency = 'currency';
  static const String fileUrl = 'file_url';
}

// ── Supabase Edge Functions ────────────────────────────────
abstract class DbFunctions {
  static const String sendOtp = 'send-otp';
  static const String verifyOtp = 'verify-otp';
  static const String createVideoRoom = 'create-video-room';
  static const String processSubscription = 'process-subscription';
  static const String sendNotification = 'send-notification';
}
