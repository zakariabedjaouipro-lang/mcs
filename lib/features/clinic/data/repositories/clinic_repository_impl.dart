/// Clinic Admin Repository Implementation
library;

import 'package:dartz/dartz.dart';
import 'package:mcs/core/errors/exceptions.dart';
import 'package:mcs/core/errors/failures.dart';
import 'package:mcs/core/models/appointment_model.dart';
import 'package:mcs/core/models/clinic_model.dart';
import 'package:mcs/core/models/doctor_model.dart';
import 'package:mcs/core/models/patient_model.dart';
import 'package:mcs/core/services/supabase_service.dart';
import 'package:mcs/features/clinic/domain/repositories/clinic_repository.dart';

/// Clinic repository implementation
class ClinicRepositoryImpl implements ClinicRepository {
  ClinicRepositoryImpl(this._supabaseService);
  final SupabaseService _supabaseService;

  @override
  Future<Either<Failure, ClinicModel>> getClinicProfile(String clinicId) async {
    try {
      final response = await _supabaseService.fetchAll(
        'clinics',
        filters: {'id': clinicId},
      );

      if (response.isEmpty) {
        throw const ServerException(message: 'Clinic not found');
      }

      return Right(ClinicModel.fromJson(response.first));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to load clinic profile: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getClinicStats(
    String clinicId,
  ) async {
    try {
      final doctors = await _supabaseService.fetchAll(
        'doctors',
        filters: {'clinic_id': clinicId},
      );

      final patients = await _supabaseService.fetchAll(
        'patients',
        filters: {'clinic_id': clinicId},
      );

      final appointments = await _supabaseService.fetchAll(
        'appointments',
        filters: {'clinic_id': clinicId, 'date': DateTime.now().toString()},
      );

      return Right({
        'totalDoctors': doctors.length,
        'totalPatients': patients.length,
        'todayAppointments': appointments.length,
        'activeDoctors': doctors.where((d) => d['is_active'] == true).length,
      });
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to load clinic stats: $e'));
    }
  }

  @override
  Future<Either<Failure, List<DoctorModel>>> getClinicDoctors(
    String clinicId,
  ) async {
    try {
      final response = await _supabaseService.fetchAll(
        'doctors',
        filters: {'clinic_id': clinicId},
        orderBy: 'created_at',
        ascending: false,
      );

      final doctors = response.map(DoctorModel.fromJson).toList();
      return Right(doctors);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to load doctors: $e'));
    }
  }

  @override
  Future<Either<Failure, List<PatientModel>>> getClinicPatients(
    String clinicId,
  ) async {
    try {
      final response = await _supabaseService.fetchAll(
        'patients',
        filters: {'clinic_id': clinicId},
        orderBy: 'created_at',
        ascending: false,
      );

      final patients = response.map(PatientModel.fromJson).toList();
      return Right(patients);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to load patients: $e'));
    }
  }

  @override
  Future<Either<Failure, List<AppointmentModel>>> getClinicAppointments(
    String clinicId,
  ) async {
    try {
      final response = await _supabaseService.fetchAll(
        'appointments',
        filters: {'clinic_id': clinicId},
        orderBy: 'created_at',
        ascending: false,
      );

      final appointments = response.map(AppointmentModel.fromJson).toList();
      return Right(appointments);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to load appointments: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateClinicStatus(
    String clinicId,
    bool isActive,
  ) async {
    try {
      await _supabaseService.update(
        'clinics',
        clinicId,
        {'is_active': isActive, 'updated_at': DateTime.now().toIso8601String()},
      );

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to update clinic status: $e'));
    }
  }
}
