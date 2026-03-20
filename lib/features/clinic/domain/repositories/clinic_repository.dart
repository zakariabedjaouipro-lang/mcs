/// Clinic Admin Repository - Interface
library;

import 'package:dartz/dartz.dart';
import 'package:mcs/core/errors/failures.dart';
import 'package:mcs/core/models/clinic_model.dart';
import 'package:mcs/core/models/doctor_model.dart';
import 'package:mcs/core/models/patient_model.dart';
import 'package:mcs/core/models/appointment_model.dart';

/// Clinic repository contract
abstract class ClinicRepository {
  Future<Either<Failure, ClinicModel>> getClinicProfile(String clinicId);
  Future<Either<Failure, Map<String, dynamic>>> getClinicStats(
    String clinicId,
  );
  Future<Either<Failure, List<DoctorModel>>> getClinicDoctors(String clinicId);
  Future<Either<Failure, List<PatientModel>>> getClinicPatients(
      String clinicId);
  Future<Either<Failure, List<AppointmentModel>>> getClinicAppointments(
    String clinicId,
  );
  Future<Either<Failure, void>> updateClinicStatus(
    String clinicId,
    bool isActive,
  );
}
