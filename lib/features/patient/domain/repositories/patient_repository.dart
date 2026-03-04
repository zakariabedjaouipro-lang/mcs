/// Patient Repository Interface
library;

import 'package:dartz/dartz.dart';
import 'package:mcs/core/errors/failures.dart';
import 'package:mcs/core/models/appointment_model.dart';
import 'package:mcs/core/models/lab_result_model.dart';
import 'package:mcs/core/models/prescription_model.dart';
import 'package:mcs/core/models/video_session_model.dart';
import 'package:mcs/core/models/user_model.dart';

/// Patient repository interface
abstract class PatientRepository {
  // ═════════════════════════════════════════════════════════════════════════════
  // Appointments
  // ═════════════════════════════════════════════════════════════════════════════

  /// Get all appointments for the current patient
  Future<Either<Failure, List<AppointmentModel>>> getAppointments();

  /// Get appointment by ID
  Future<Either<Failure, AppointmentModel>> getAppointmentById(String id);

  /// Book a new appointment
  Future<Either<Failure, AppointmentModel>> bookAppointment({
    required String clinicId,
    required String doctorId,
    required DateTime appointmentDate,
    required String timeSlot,
    required String appointmentType,
    String? notes,
  });

  /// Cancel an appointment
  Future<Either<Failure, void>> cancelAppointment(String appointmentId);

  /// Reschedule an appointment
  Future<Either<Failure, AppointmentModel>> rescheduleAppointment({
    required String appointmentId,
    required DateTime newDate,
    required String newTimeSlot,
  });

  // ═════════════════════════════════════════════════════════════════════════════
  // Remote Sessions
  // ═════════════════════════════════════════════════════════════════════════════

  /// Get all remote sessions for the current patient
  Future<Either<Failure, List<VideoSessionModel>>> getRemoteSessions();

  /// Get upcoming remote sessions
  Future<Either<Failure, List<VideoSessionModel>>> getUpcomingRemoteSessions();

  /// Get past remote sessions
  Future<Either<Failure, List<VideoSessionModel>>> getPastRemoteSessions();

  /// Join a video session
  Future<Either<Failure, String>> joinVideoSession(String sessionId);

  /// Leave a video session
  Future<Either<Failure, void>> leaveVideoSession(String channelId);

  // ═════════════════════════════════════════════════════════════════════════════
  // Prescriptions
  // ═════════════════════════════════════════════════════════════════════════════

  /// Get all prescriptions for the current patient
  Future<Either<Failure, List<PrescriptionModel>>> getPrescriptions();

  /// Get prescription by ID
  Future<Either<Failure, PrescriptionModel>> getPrescriptionById(String id);

  /// Get active prescriptions
  Future<Either<Failure, List<PrescriptionModel>>> getActivePrescriptions();

  // ═════════════════════════════════════════════════════════════════════════════
  // Lab Results
  // ═════════════════════════════════════════════════════════════════════════════

  /// Get all lab results for the current patient
  Future<Either<Failure, List<LabResultModel>>> getLabResults();

  /// Get lab result by ID
  Future<Either<Failure, LabResultModel>> getLabResultById(String id);

  /// Download lab result report
  Future<Either<Failure, String>> downloadLabResult(String labResultId);

  // ═════════════════════════════════════════════════════════════════════════════
  // Profile
  // ═════════════════════════════════════════════════════════════════════════════

  /// Get current patient profile
  Future<Either<Failure, UserModel>> getProfile();

  /// Update patient profile
  Future<Either<Failure, UserModel>> updateProfile({
    String? name,
    String? phone,
    String? address,
    DateTime? dateOfBirth,
    String? bloodType,
    String? allergies,
    String? emergencyContact,
    String? emergencyPhone,
  });

  /// Change password
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  // ═════════════════════════════════════════════════════════════════════════════
  // Social Accounts
  // ═════════════════════════════════════════════════════════════════════════════

  /// Link social account
  Future<Either<Failure, UserModel>> linkSocialAccount({
    required String provider,
    required String providerId,
    required String accessToken,
  });

  /// Unlink social account
  Future<Either<Failure, UserModel>> unlinkSocialAccount(String provider);

  /// Get linked social accounts
  Future<Either<Failure, List<Map<String, dynamic>>>> getLinkedSocialAccounts();
}