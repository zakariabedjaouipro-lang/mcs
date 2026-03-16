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
  static const String pendingApproval = '/pending-approval';

  // Dashboards
  static const String dashboard = '/dashboard';

  static const String patientHome = '/patient';
  static const String doctorHome = '/doctor';
  static const String employeeHome = '/employee';
  static const String adminHome = '/admin';
  static const String superAdminHome = '/super-admin';
  static const String premiumSuperAdminHome = '/premium-super-admin';

  // Patient
  static const String patients = '/patient/patients';
  static const String appointments = '/patient/appointments';
  static const String records = '/patient/records';
  static const String settings = '/patient/settings';
  static const String socialAccounts = '/patient/social-accounts';

  static String appointmentDetails(String appointmentId) =>
      '/patient/appointments/$appointmentId';

  static String rescheduleAppointment(String appointmentId) =>
      '/patient/reschedule/$appointmentId';

  // Employee
  static const String inventory = '/employee/inventory';
  static const String invoices = '/employee/invoices';

  static String invoiceDetails(String invoiceId) =>
      '/employee/invoices/$invoiceId';

  // Error
  static const String notFound = '/404';
}
