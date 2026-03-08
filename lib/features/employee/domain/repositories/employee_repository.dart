/// Employee Repository Interface
library;

import 'package:dartz/dartz.dart';
import 'package:mcs/core/errors/failures.dart';
import 'package:mcs/core/models/appointment_model.dart';
import 'package:mcs/core/models/employee_model.dart';
import 'package:mcs/core/models/inventory_model.dart';
import 'package:mcs/core/models/invoice_model.dart';
import 'package:mcs/core/models/patient_model.dart';

/// Employee repository interface
abstract class EmployeeRepository {
  // Profile Management
  Future<Either<Failure, EmployeeModel>> getEmployeeProfile();
  Future<Either<Failure, EmployeeModel>> updateEmployeeProfile(
      EmployeeModel profile,);

  // Patient Management (Reception)
  Future<Either<Failure, List<PatientModel>>> getPatients();
  Future<Either<Failure, PatientModel>> getPatientDetails(String patientId);
  Future<Either<Failure, void>> registerPatient(
      Map<String, dynamic> patientData,);
  Future<Either<Failure, void>> updatePatient(
      String patientId, Map<String, dynamic> patientData,);
  Future<Either<Failure, List<PatientModel>>> searchPatients(String query);

  // Appointment Management (Reception)
  Future<Either<Failure, List<AppointmentModel>>> getAppointments({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  });
  Future<Either<Failure, AppointmentModel>> getAppointmentDetails(
      String appointmentId,);
  Future<Either<Failure, void>> bookAppointment(
      Map<String, dynamic> appointmentData,);
  Future<Either<Failure, void>> cancelAppointment(
      String appointmentId, String reason,);
  Future<Either<Failure, void>> rescheduleAppointment(
      String appointmentId, DateTime newDateTime,);
  Future<Either<Failure, void>> checkInPatient(String appointmentId);
  Future<Either<Failure, void>> checkOutPatient(String appointmentId);

  // Vital Signs Management (Nursing)
  Future<Either<Failure, void>> recordVitalSigns(
      String patientId, Map<String, dynamic> vitalSigns,);
  Future<Either<Failure, Map<String, dynamic>>> getPatientVitalSigns(
      String patientId,);

  // Lab Results Management (Lab Technician)
  Future<Either<Failure, void>> uploadLabResult(Map<String, dynamic> labResult);
  Future<Either<Failure, List<Map<String, dynamic>>>> getLabResults(
      String patientId,);
  Future<Either<Failure, void>> updateLabResult(
      String resultId, Map<String, dynamic> resultData,);

  // Inventory Management (Admin)
  Future<Either<Failure, List<InventoryModel>>> getInventory();
  Future<Either<Failure, InventoryModel>> getInventoryItem(String itemId);
  Future<Either<Failure, void>> addInventoryItem(Map<String, dynamic> itemData);
  Future<Either<Failure, void>> updateInventoryItem(
      String itemId, Map<String, dynamic> itemData,);
  Future<Either<Failure, void>> deleteInventoryItem(String itemId);
  Future<Either<Failure, void>> recordInventoryTransaction(
      Map<String, dynamic> transactionData,);

  // Invoice Management (Admin)
  Future<Either<Failure, List<InvoiceModel>>> getInvoices({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  });
  Future<Either<Failure, InvoiceModel>> getInvoiceDetails(String invoiceId);
  Future<Either<Failure, void>> createInvoice(Map<String, dynamic> invoiceData);
  Future<Either<Failure, void>> updateInvoice(
      String invoiceId, Map<String, dynamic> invoiceData,);
  Future<Either<Failure, void>> processPayment(
      String invoiceId, Map<String, dynamic> paymentData,);

  // Statistics
  Future<Either<Failure, Map<String, dynamic>>> getDashboardStats();

  // Notifications
  Future<Either<Failure, void>> sendNotificationToPatient(
      String patientId, String title, String body,);
}

