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

  // Doctor
  static const String doctorAppointments = '/doctor/appointments';
  static const String doctorPatients = '/doctor/patients';
  static const String doctorPrescriptions = '/doctor/prescriptions';
  static const String doctorLabResults = '/doctor/lab-results';
  static const String doctorProfile = '/doctor/profile';
  static const String doctorSettings = '/doctor/settings';

  // Employee
  static const String inventory = '/employee/inventory';
  static const String invoices = '/employee/invoices';
  static const String employeeAppointments = '/employee/appointments';
  static const String employeePatients = '/employee/patients';
  static const String employeePrescriptions = '/employee/prescriptions';
  static const String employeeLabResults = '/employee/lab-results';
  static const String employeeProfile = '/employee/profile';
  static const String employeeSettings = '/employee/settings';

  static String invoiceDetails(String invoiceId) =>
      '/employee/invoices/$invoiceId';

  // Admin
  static const String adminAppointments = '/admin/appointments';
  static const String adminDoctors = '/admin/doctors';
  static const String adminEmployees = '/admin/employees';
  static const String adminPatients = '/admin/patients';
  static const String adminSettings = '/admin/settings';

  // Patient - Additional
  static const String patientBookAppointment = '/patient/book-appointment';
  static const String patientMedicalHistory = '/patient/medical-history';
  static const String patientProfile = '/patient/profile';
  static const String patientChangePassword = '/patient/change-password';
  static const String patientLabResults = '/patient/lab-results';
  static const String patientPrescriptions = '/patient/prescriptions';
  static const String patientRemoteSessions = '/patient/remote-sessions';

  // Error
  static const String notFound = '/404';
}
