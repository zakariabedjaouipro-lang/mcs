/// Doctor Repository Interface
library;

import 'package:dartz/dartz.dart';
import 'package:mcs/core/errors/failures.dart';
import 'package:mcs/core/models/appointment_model.dart';
import 'package:mcs/core/models/doctor_model.dart';
import 'package:mcs/core/models/patient_model.dart';
import 'package:mcs/core/models/prescription_model.dart';

/// Doctor repository interface
abstract class DoctorRepository {
  // Profile Management
  Future<Either<Failure, DoctorModel>> getDoctorProfile();
  Future<Either<Failure, DoctorModel>> updateDoctorProfile(DoctorModel profile);
  Future<Either<Failure, void>> updateAvailability(bool isAvailable);

  // Patient Management
  Future<Either<Failure, List<PatientModel>>> getPatients();
  Future<Either<Failure, PatientModel>> getPatientDetails(String patientId);
  Future<Either<Failure, List<PatientModel>>> searchPatients(String query);

  // Appointment Management
  Future<Either<Failure, List<AppointmentModel>>> getAppointments({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  });
  Future<Either<Failure, AppointmentModel>> getAppointmentDetails(
    String appointmentId,
  );
  Future<Either<Failure, void>> acceptAppointment(String appointmentId);
  Future<Either<Failure, void>> rejectAppointment(
    String appointmentId,
    String reason,
  );
  Future<Either<Failure, void>> cancelAppointment(
    String appointmentId,
    String reason,
  );
  Future<Either<Failure, void>> completeAppointment(
    String appointmentId,
    Map<String, dynamic> notes,
  );
  Future<Either<Failure, void>> rescheduleAppointment(
    String appointmentId,
    DateTime newDateTime,
  );

  // Prescription Management
  Future<Either<Failure, void>> createPrescription(
    PrescriptionModel prescription,
  );
  Future<Either<Failure, List<PrescriptionModel>>> getPrescriptions(
    String patientId,
  );
  Future<Either<Failure, PrescriptionModel>> getPrescriptionDetails(
    String prescriptionId,
  );
  Future<Either<Failure, void>> updatePrescription(
    String prescriptionId,
    PrescriptionModel prescription,
  );
  Future<Either<Failure, void>> deletePrescription(String prescriptionId);

  // Remote Session Management
  Future<Either<Failure, void>> startRemoteSession(String appointmentId);
  Future<Either<Failure, void>> endRemoteSession(String sessionId);
  Future<Either<Failure, String>> generateRemoteSessionToken(
    String appointmentId,
  );

  // Lab Results Management
  Future<Either<Failure, void>> uploadLabResult(Map<String, dynamic> labResult);
  Future<Either<Failure, List<Map<String, dynamic>>>> getLabResults(
    String patientId,
  );

  // Statistics
  Future<Either<Failure, Map<String, dynamic>>> getDashboardStats();

  // Notifications
  Future<Either<Failure, void>> sendNotificationToPatient(
    String patientId,
    String title,
    String body,
  );

  // Remote Session Requests
  Future<Either<Failure, List<AppointmentModel>>> getRemoteSessionRequests();
  Future<Either<Failure, void>> approveRemoteSessionRequest(
    String appointmentId,
  );
  Future<Either<Failure, void>> rejectRemoteSessionRequest(
    String appointmentId,
    String reason,
  );
}

