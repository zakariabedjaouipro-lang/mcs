/// Doctor Repository Implementation
library;

import 'package:dartz/dartz.dart';
import 'package:mcs/core/errors/exceptions.dart';
import 'package:mcs/core/errors/failures.dart'; // ✅ بعد exceptions
import 'package:mcs/core/models/appointment_model.dart';
import 'package:mcs/core/models/doctor_model.dart';
import 'package:mcs/core/models/patient_model.dart';
import 'package:mcs/core/models/prescription_model.dart';
import 'package:mcs/core/services/supabase_service.dart';
import 'package:mcs/features/doctor/domain/repositories/doctor_repository.dart';

/// Doctor repository implementation
class DoctorRepositoryImpl implements DoctorRepository {
  // ✅ Constructor قبل أي methods
  DoctorRepositoryImpl(this._supabaseService);
  final SupabaseService _supabaseService;

  // ✅ ثم باقي الـ methods بعد الـ constructor
  @override
  Future<Either<Failure, DoctorModel>> getDoctorProfile() async {
    try {
      final userId = _supabaseService.currentUserId;
      if (userId == null) {
        throw const ServerException(message: 'User not authenticated');
      }

      final response = await _supabaseService.fetchAll(
        'doctors',
        filters: {'user_id': userId},
      );

      if (response.isEmpty) {
        throw const ServerException(message: 'Doctor profile not found');
      }

      return Right(DoctorModel.fromJson(response.first));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to load doctor profile: $e'));
    }
  }

  @override
  Future<Either<Failure, DoctorModel>> updateDoctorProfile(
    DoctorModel profile,
  ) async {
    try {
      final response = await _supabaseService.update(
        'doctors',
        profile.id,
        profile.toJson(),
      );
      return Right(DoctorModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update doctor profile: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateAvailability({required bool isAvailable}) async {
    try {
      final userId = _supabaseService.currentUserId;
      if (userId == null) {
        throw const ServerException(message: 'User not authenticated');
      }

      final response = await _supabaseService.fetchAll(
        'doctors',
        filters: {'user_id': userId},
      );

      if (response.isEmpty) {
        throw const ServerException(message: 'Doctor profile not found');
      }

      final doctorId = response.first['id'] as String;
      await _supabaseService.update(
        'doctors',
        doctorId,
        {'is_available': isAvailable},
      );

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update doctor profile: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<PatientModel>>> getPatients() async {
    try {
      final userId = _supabaseService.currentUserId;
      if (userId == null) {
        throw const ServerException(message: 'User not authenticated');
      }

      final response = await _supabaseService.fetchAll(
        'doctors',
        filters: {'user_id': userId},
      );

      if (response.isEmpty) {
        throw const ServerException(message: 'Doctor profile not found');
      }

      final doctorId = response.first['id'] as String;

      // Get patients who have appointments with this doctor
      final appointmentsResponse = await _supabaseService.fetchAll(
        'appointments',
        filters: {'doctor_id': doctorId},
      );

      final patientIds = appointmentsResponse
          .map((a) => a['patient_id'] as String)
          .toSet()
          .toList();

      final patients = <PatientModel>[];
      for (final patientId in patientIds) {
        final patientResponse =
            await _supabaseService.fetchById('patients', patientId);
        patients.add(PatientModel.fromJson(patientResponse));
      }

      return Right(patients);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update doctor profile: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, PatientModel>> getPatientDetails(
    String patientId,
  ) async {
    try {
      final response = await _supabaseService.fetchById('patients', patientId);
      return Right(PatientModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update doctor profile: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<PatientModel>>> searchPatients(
    String query,
  ) async {
    try {
      final response = await _supabaseService.fetchAll(
        'patients',
        filters: {'name': query},
      );

      final patients = response.map(PatientModel.fromJson).toList();
      return Right(patients);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update doctor profile: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<AppointmentModel>>> getAppointments({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) async {
    try {
      final userId = _supabaseService.currentUserId;
      if (userId == null) {
        throw const ServerException(message: 'User not authenticated');
      }

      final response = await _supabaseService.fetchAll(
        'doctors',
        filters: {'user_id': userId},
      );

      if (response.isEmpty) {
        throw const ServerException(message: 'Doctor profile not found');
      }

      final doctorId = response.first['id'] as String;

      final filters = <String, dynamic>{'doctor_id': doctorId};
      if (status != null) {
        filters['status'] = status;
      }

      final appointmentsResponse = await _supabaseService.fetchAll(
        'appointments',
        filters: filters,
      );

      final appointments = appointmentsResponse
          .map(AppointmentModel.fromJson)
          .where((appointment) {
        if (startDate != null &&
            appointment.appointmentDate.isBefore(startDate)) {
          return false;
        }
        if (endDate != null && appointment.appointmentDate.isAfter(endDate)) {
          return false;
        }
        return true;
      }).toList();

      return Right(appointments);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update doctor profile: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, AppointmentModel>> getAppointmentDetails(
    String appointmentId,
  ) async {
    try {
      final response =
          await _supabaseService.fetchById('appointments', appointmentId);
      return Right(AppointmentModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update doctor profile: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> acceptAppointment(String appointmentId) async {
    try {
      await _supabaseService.update(
        'appointments',
        appointmentId,
        {'status': 'confirmed'},
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update doctor profile: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> rejectAppointment(
    String appointmentId,
    String reason,
  ) async {
    try {
      await _supabaseService.update(
        'appointments',
        appointmentId,
        {
          'status': 'cancelled',
          'cancellation_reason': reason,
        },
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update doctor profile: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> cancelAppointment(
    String appointmentId,
    String reason,
  ) async {
    try {
      await _supabaseService.update(
        'appointments',
        appointmentId,
        {
          'status': 'cancelled',
          'cancellation_reason': reason,
        },
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update doctor profile: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> completeAppointment(
    String appointmentId,
    Map<String, dynamic> notes,
  ) async {
    try {
      await _supabaseService.update(
        'appointments',
        appointmentId,
        {
          'status': 'completed',
          'notes': notes,
        },
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update doctor profile: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> rescheduleAppointment(
    String appointmentId,
    DateTime newDateTime,
  ) async {
    try {
      await _supabaseService.update(
        'appointments',
        appointmentId,
        {
          'appointment_date': newDateTime.toIso8601String(),
        },
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update doctor profile: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> createPrescription(
    PrescriptionModel prescription,
  ) async {
    try {
      await _supabaseService.insert('prescriptions', prescription.toJson());
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update doctor profile: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<PrescriptionModel>>> getPrescriptions(
    String patientId,
  ) async {
    try {
      final response = await _supabaseService.fetchAll(
        'prescriptions',
        filters: {'patient_id': patientId},
      );

      final prescriptions = response.map(PrescriptionModel.fromJson).toList();
      return Right(prescriptions);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update doctor profile: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, PrescriptionModel>> getPrescriptionDetails(
    String prescriptionId,
  ) async {
    try {
      final response =
          await _supabaseService.fetchById('prescriptions', prescriptionId);
      return Right(PrescriptionModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update doctor profile: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updatePrescription(
    String prescriptionId,
    PrescriptionModel prescription,
  ) async {
    try {
      await _supabaseService.update(
        'prescriptions',
        prescriptionId,
        prescription.toJson(),
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update doctor profile: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deletePrescription(
    String prescriptionId,
  ) async {
    try {
      await _supabaseService.delete('prescriptions', prescriptionId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update doctor profile: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> startRemoteSession(String appointmentId) async {
    try {
      await _supabaseService.update(
        'video_sessions',
        appointmentId,
        {'status': 'active'},
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update doctor profile: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> endRemoteSession(String sessionId) async {
    try {
      await _supabaseService.update(
        'video_sessions',
        sessionId,
        {'status': 'ended'},
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update doctor profile: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, String>> generateRemoteSessionToken(
    String appointmentId,
  ) async {
    try {
      // TODO: Implement token generation with Agora
      return const Right('mock_token');
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update doctor profile: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> uploadLabResult(
    Map<String, dynamic> labResult,
  ) async {
    try {
      await _supabaseService.insert('lab_results', labResult);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update doctor profile: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getLabResults(
    String patientId,
  ) async {
    try {
      final response = await _supabaseService.fetchAll(
        'lab_results',
        filters: {'patient_id': patientId},
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update doctor profile: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getDashboardStats() async {
    try {
      final userId = _supabaseService.currentUserId;
      if (userId == null) {
        throw const ServerException(message: 'User not authenticated');
      }

      final response = await _supabaseService.fetchAll(
        'doctors',
        filters: {'user_id': userId},
      );

      if (response.isEmpty) {
        throw const ServerException(message: 'Doctor profile not found');
      }

      final doctorId = response.first['id'] as String;

      final appointmentsResponse = await _supabaseService.fetchAll(
        'appointments',
        filters: {'doctor_id': doctorId},
      );

      final stats = {
        'total_patients': await _getTotalPatients(doctorId),
        'total_appointments': appointmentsResponse.length,
        'today_appointments': appointmentsResponse.where((a) {
          final dateStr = a['scheduled_at'] as String?;
          if (dateStr == null) return false;
          final date = DateTime.parse(dateStr);
          final now = DateTime.now();
          return date.year == now.year &&
              date.month == now.month &&
              date.day == now.day;
        }).length,
        'upcoming_appointments': appointmentsResponse.where((a) {
          final dateStr = a['scheduled_at'] as String?;
          if (dateStr == null) return false;
          final date = DateTime.parse(dateStr);
          final status = a['status'] as String?;
          // Consider appointments in the future that are not in a terminal state
          return date.isAfter(DateTime.now()) &&
              status != 'cancelled' &&
              status != 'completed' &&
              status != 'no_show';
        }).length,
        'completed_appointments': appointmentsResponse
            .where((a) => a['status'] == 'completed')
            .length,
        'pending_appointments':
            appointmentsResponse.where((a) => a['status'] == 'pending').length,
      };

      return Right(stats);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update doctor profile: $e'),
      );
    }
  }

  Future<int> _getTotalPatients(String doctorId) async {
    final appointmentsResponse = await _supabaseService.fetchAll(
      'appointments',
      filters: {'doctor_id': doctorId},
    );

    final patientIds =
        appointmentsResponse.map((a) => a['patient_id']).toSet().toList();
    return patientIds.length;
  }

  @override
  Future<Either<Failure, void>> sendNotificationToPatient(
    String patientId,
    String title,
    String body,
  ) async {
    try {
      // TODO: Implement notification sending
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update doctor profile: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<AppointmentModel>>>
      getRemoteSessionRequests() async {
    try {
      final userId = _supabaseService.currentUserId;
      if (userId == null) {
        throw const ServerException(message: 'User not authenticated');
      }

      final response = await _supabaseService.fetchAll(
        'doctors',
        filters: {'user_id': userId},
      );

      if (response.isEmpty) {
        throw const ServerException(message: 'Doctor profile not found');
      }

      final doctorId = response.first['id'] as String;

      final appointmentsResponse = await _supabaseService.fetchAll(
        'appointments',
        filters: {
          'doctor_id': doctorId,
          'type': 'remote',
          'status': 'pending',
        },
      );

      final appointments =
          appointmentsResponse.map(AppointmentModel.fromJson).toList();

      return Right(appointments);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update doctor profile: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> approveRemoteSessionRequest(
    String appointmentId,
  ) async {
    try {
      await _supabaseService.update(
        'appointments',
        appointmentId,
        {'status': 'confirmed'},
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update doctor profile: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> rejectRemoteSessionRequest(
    String appointmentId,
    String reason,
  ) async {
    try {
      await _supabaseService.update(
        'appointments',
        appointmentId,
        {
          'status': 'cancelled',
          'cancellation_reason': reason,
        },
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update doctor profile: $e'),
      );
    }
  }
}
