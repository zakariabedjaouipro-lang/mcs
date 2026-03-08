/// Patient Repository Implementation
library;

import 'package:dartz/dartz.dart';
import 'package:mcs/core/errors/failures.dart';
import 'package:mcs/core/models/appointment_model.dart';
import 'package:mcs/core/models/lab_result_model.dart';
import 'package:mcs/core/models/prescription_model.dart';
import 'package:mcs/core/models/user_model.dart';
import 'package:mcs/core/models/video_session_model.dart';
import 'package:mcs/core/services/supabase_service.dart';
import 'package:mcs/features/patient/domain/repositories/patient_repository.dart';

/// Patient repository implementation
class PatientRepositoryImpl implements PatientRepository {
  PatientRepositoryImpl(this._supabaseService);
  final SupabaseService _supabaseService;

  // ═════════════════════════════════════════════════════════════════════════════
  // Appointments
  // ═════════════════════════════════════════════════════════════════════════════

  @override
  Future<Either<Failure, List<AppointmentModel>>> getAppointments() async {
    try {
      final data = await _supabaseService.fetchAll(
        'appointments',
        filters: {
          'patient_id': _supabaseService.currentUserId,
        },
      );

      final appointments = data.map(AppointmentModel.fromJson).toList();

      return Right(appointments);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppointmentModel>> getAppointmentById(
    String id,
  ) async {
    try {
      final data = await _supabaseService.fetchById('appointments', id);
      final appointment = AppointmentModel.fromJson(data);
      return Right(appointment);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppointmentModel>> bookAppointment({
    required String clinicId,
    required String doctorId,
    required DateTime appointmentDate,
    required String timeSlot,
    required String appointmentType,
    String? notes,
  }) async {
    try {
      final appointmentData = {
        'clinic_id': clinicId,
        'doctor_id': doctorId,
        'patient_id': _supabaseService.currentUserId,
        'appointment_date': appointmentDate.toIso8601String(),
        'time_slot': timeSlot,
        'appointment_type': appointmentType,
        'status': 'scheduled',
        'notes': notes,
        'created_at': DateTime.now().toIso8601String(),
      };

      final data =
          await _supabaseService.insert('appointments', appointmentData);
      final appointment = AppointmentModel.fromJson(data);
      return Right(appointment);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelAppointment(String appointmentId) async {
    try {
      await _supabaseService.update(
        'appointments',
        appointmentId,
        {
          'status': 'cancelled',
          'cancelled_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppointmentModel>> rescheduleAppointment({
    required String appointmentId,
    required DateTime newDate,
    required String newTimeSlot,
  }) async {
    try {
      final data = await _supabaseService.update(
        'appointments',
        appointmentId,
        {
          'appointment_date': newDate.toIso8601String(),
          'time_slot': newTimeSlot,
          'status': 'rescheduled',
          'updated_at': DateTime.now().toIso8601String(),
        },
      );
      final appointment = AppointmentModel.fromJson(data);
      return Right(appointment);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ═════════════════════════════════════════════════════════════════════════════
  // Remote Sessions
  // ═════════════════════════════════════════════════════════════════════════════

  @override
  Future<Either<Failure, List<VideoSessionModel>>> getRemoteSessions() async {
    try {
      final data = await _supabaseService.fetchAll(
        'video_sessions',
        filters: {
          'patient_id': _supabaseService.currentUserId,
        },
      );

      final sessions = data.map(VideoSessionModel.fromJson).toList();

      return Right(sessions);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VideoSessionModel>>>
      getUpcomingRemoteSessions() async {
    try {
      final sessions = await getRemoteSessions();
      return sessions.fold(
        Left.new,
        (allSessions) {
          final upcoming = allSessions
              .where(
                (session) =>
                    session.sessionDate != null &&
                    session.sessionDate!.isAfter(DateTime.now()),
              )
              .toList();
          return Right(upcoming);
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VideoSessionModel>>>
      getPastRemoteSessions() async {
    try {
      final sessions = await getRemoteSessions();
      return sessions.fold(
        Left.new,
        (allSessions) {
          final past = allSessions
              .where(
                (session) =>
                    session.sessionDate != null &&
                    session.sessionDate!.isBefore(DateTime.now()),
              )
              .toList();
          return Right(past);
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> joinVideoSession(String sessionId) async {
    try {
      // TODO: Implement Agora video call integration
      // For now, return a mock channel ID
      return Right('channel_$sessionId');
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> leaveVideoSession(String channelId) async {
    try {
      // TODO: Implement Agora video call integration
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ═════════════════════════════════════════════════════════════════════════════
  // Prescriptions
  // ═════════════════════════════════════════════════════════════════════════════

  @override
  Future<Either<Failure, List<PrescriptionModel>>> getPrescriptions() async {
    try {
      final data = await _supabaseService.fetchAll(
        'prescriptions',
        filters: {
          'patient_id': _supabaseService.currentUserId,
        },
      );

      final prescriptions = data.map(PrescriptionModel.fromJson).toList();

      return Right(prescriptions);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PrescriptionModel>> getPrescriptionById(
    String id,
  ) async {
    try {
      final data = await _supabaseService.fetchById('prescriptions', id);
      final prescription = PrescriptionModel.fromJson(data);
      return Right(prescription);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PrescriptionModel>>>
      getActivePrescriptions() async {
    try {
      final prescriptions = await getPrescriptions();
      return prescriptions.fold(
        Left.new,
        (allPrescriptions) {
          final active = allPrescriptions
              .where((prescription) => prescription.isRecent)
              .toList();
          return Right(active);
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ═════════════════════════════════════════════════════════════════════════════
  // Lab Results
  // ═════════════════════════════════════════════════════════════════════════════

  @override
  Future<Either<Failure, List<LabResultModel>>> getLabResults() async {
    try {
      final data = await _supabaseService.fetchAll(
        'lab_results',
        filters: {
          'patient_id': _supabaseService.currentUserId,
        },
      );

      final results = data.map(LabResultModel.fromJson).toList();

      return Right(results);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LabResultModel>> getLabResultById(String id) async {
    try {
      final data = await _supabaseService.fetchById('lab_results', id);
      final result = LabResultModel.fromJson(data);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> downloadLabResult(String labResultId) async {
    try {
      // TODO: Implement file download from Supabase Storage
      return Right('download_url_$labResultId');
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ═════════════════════════════════════════════════════════════════════════════
  // Profile
  // ═════════════════════════════════════════════════════════════════════════════

  @override
  Future<Either<Failure, UserModel>> getProfile() async {
    try {
      final userId = _supabaseService.currentUserId;
      if (userId == null) {
        return const Left(AuthFailure(message: ''));
      }

      final data = await _supabaseService.fetchById('users', userId);
      final user = UserModel.fromJson(data);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateProfile({
    String? name,
    String? phone,
    String? address,
    DateTime? dateOfBirth,
    String? bloodType,
    String? allergies,
    String? emergencyContact,
    String? emergencyPhone,
  }) async {
    try {
      final userId = _supabaseService.currentUserId;
      if (userId == null) {
        return const Left(AuthFailure(message: ''));
      }

      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (phone != null) updateData['phone'] = phone;
      if (address != null) updateData['address'] = address;
      if (dateOfBirth != null) {
        updateData['date_of_birth'] = dateOfBirth.toIso8601String();
      }
      if (bloodType != null) updateData['blood_type'] = bloodType;
      if (allergies != null) updateData['allergies'] = allergies;
      if (emergencyContact != null) {
        updateData['emergency_contact'] = emergencyContact;
      }
      if (emergencyPhone != null) {
        updateData['emergency_phone'] = emergencyPhone;
      }
      updateData['updated_at'] = DateTime.now().toIso8601String();

      final data = await _supabaseService.update('users', userId, updateData);
      final user = UserModel.fromJson(data);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      // TODO: Implement password change via Supabase Auth
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ═════════════════════════════════════════════════════════════════════════════
  // Social Accounts
  // ═════════════════════════════════════════════════════════════════════════════

  @override
  Future<Either<Failure, UserModel>> linkSocialAccount({
    required String provider,
    required String providerId,
    required String accessToken,
  }) async {
    try {
      // TODO: Implement social account linking via Supabase Auth
      return (await getProfile()).fold(
        Left.new,
        Right.new,
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> unlinkSocialAccount(
    String provider,
  ) async {
    try {
      // TODO: Implement social account unlinking via Supabase Auth
      return (await getProfile()).fold(
        Left.new,
        Right.new,
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>>
      getLinkedSocialAccounts() async {
    try {
      // TODO: Implement getting linked social accounts
      return const Right([]);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}


