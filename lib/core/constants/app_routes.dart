abstract class AppRoutes {
  // Public
  static const String landing = '/';
  static const String features = '/features';
  static const String pricing = '/pricing';
  static const String contact = '/contact';
  static const String download = '/download';

  // Auth
  static const String login = '/login';
  static const String register = '/register';
  static const String otpVerification = '/otp-verification';
  static const String forgotPassword = '/forgot-password';
  static const String changePassword = '/change-password';

  // Dashboards
  static const String dashboard = '/dashboard';

  static const String patientHome = '/patient';
  static const String doctorHome = '/doctor';
  static const String employeeHome = '/employee';
  static const String adminHome = '/admin';
  static const String superAdminHome = '/super-admin';

  // Patient
  static const String patients = '/patient/patients';
  static const String appointments = '/patient/appointments';
  static const String records = '/patient/records';
  static const String settings = '/patient/settings';

  static const String notFound = '/404';
}
