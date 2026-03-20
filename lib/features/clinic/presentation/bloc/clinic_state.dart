/// Clinic BLoC States
library;

import 'package:equatable/equatable.dart';
import 'package:mcs/core/models/appointment_model.dart';
import 'package:mcs/core/models/doctor_model.dart';
import 'package:mcs/core/models/patient_model.dart';

/// Base state for Clinic BLoC
abstract class ClinicState extends Equatable {
  const ClinicState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ClinicInitial extends ClinicState {
  const ClinicInitial();
}

/// Loading state
class ClinicLoading extends ClinicState {
  const ClinicLoading();
}

/// Stats loaded state
class ClinicStatsLoaded extends ClinicState {
  const ClinicStatsLoaded({
    required this.totalDoctors,
    required this.totalPatients,
    required this.todayAppointments,
    required this.activeDoctors,
  });

  final int totalDoctors;
  final int totalPatients;
  final int todayAppointments;
  final int activeDoctors;

  @override
  List<Object?> get props =>
      [totalDoctors, totalPatients, todayAppointments, activeDoctors];
}

/// Doctors loaded state
class ClinicDoctorsLoaded extends ClinicState {
  const ClinicDoctorsLoaded(this.doctors);
  final List<DoctorModel> doctors;

  @override
  List<Object?> get props => [doctors];
}

/// Patients loaded state
class ClinicPatientsLoaded extends ClinicState {
  const ClinicPatientsLoaded(this.patients);
  final List<PatientModel> patients;

  @override
  List<Object?> get props => [patients];
}

/// Appointments loaded state
class ClinicAppointmentsLoaded extends ClinicState {
  const ClinicAppointmentsLoaded(this.appointments);
  final List<AppointmentModel> appointments;

  @override
  List<Object?> get props => [appointments];
}

/// Error state
class ClinicError extends ClinicState {
  const ClinicError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Success state
class ClinicSuccess extends ClinicState {
  const ClinicSuccess(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
