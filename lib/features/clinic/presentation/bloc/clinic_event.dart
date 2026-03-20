/// Clinic BLoC Events
library;

import 'package:equatable/equatable.dart';

/// Base event for Clinic BLoC
abstract class ClinicEvent extends Equatable {
  const ClinicEvent();

  @override
  List<Object?> get props => [];
}

/// Load clinic statistics
class LoadClinicStatsEvent extends ClinicEvent {
  const LoadClinicStatsEvent({required this.clinicId});
  final String clinicId;

  @override
  List<Object?> get props => [clinicId];
}

/// Load clinic doctors
class LoadClinicDoctorsEvent extends ClinicEvent {
  const LoadClinicDoctorsEvent({required this.clinicId});
  final String clinicId;

  @override
  List<Object?> get props => [clinicId];
}

/// Load clinic patients
class LoadClinicPatientsEvent extends ClinicEvent {
  const LoadClinicPatientsEvent({required this.clinicId});
  final String clinicId;

  @override
  List<Object?> get props => [clinicId];
}

/// Load clinic appointments
class LoadClinicAppointmentsEvent extends ClinicEvent {
  const LoadClinicAppointmentsEvent({required this.clinicId});
  final String clinicId;

  @override
  List<Object?> get props => [clinicId];
}

/// Refresh clinic data
class RefreshClinicDataEvent extends ClinicEvent {
  const RefreshClinicDataEvent({required this.clinicId});
  final String clinicId;

  @override
  List<Object?> get props => [clinicId];
}
