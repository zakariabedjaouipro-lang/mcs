/// Doctor States
library;

import 'package:equatable/equatable.dart';
import 'package:mcs/core/models/appointment_model.dart';
import 'package:mcs/core/models/doctor_model.dart';
import 'package:mcs/core/models/patient_model.dart';
import 'package:mcs/core/models/prescription_model.dart';

/// Base doctor state
abstract class DoctorState extends Equatable {
  const DoctorState();

  @override
  List<Object?> get props => [];
}

// Initial State
class DoctorInitial extends DoctorState {
  const DoctorInitial();
}

// Loading State
class DoctorLoading extends DoctorState {
  const DoctorLoading();
}

// Profile States
class DoctorProfileLoaded extends DoctorState {
  const DoctorProfileLoaded(this.profile);
  final DoctorModel profile;

  @override
  List<Object?> get props => [profile];
}

class DoctorProfileUpdated extends DoctorState {
  const DoctorProfileUpdated(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class AvailabilityToggled extends DoctorState {
  const AvailabilityToggled(this.isAvailable);
  final bool isAvailable;

  @override
  List<Object?> get props => [isAvailable];
}

// Patient States
class PatientsLoaded extends DoctorState {
  const PatientsLoaded(this.patients);
  final List<PatientModel> patients;

  @override
  List<Object?> get props => [patients];
}

class PatientDetailsLoaded extends DoctorState {
  const PatientDetailsLoaded(this.patient);
  final PatientModel patient;

  @override
  List<Object?> get props => [patient];
}

class PatientsSearched extends DoctorState {
  const PatientsSearched(this.patients);
  final List<PatientModel> patients;

  @override
  List<Object?> get props => [patients];
}

// Appointment States
class AppointmentsLoaded extends DoctorState {
  const AppointmentsLoaded(this.appointments);
  final List<AppointmentModel> appointments;

  @override
  List<Object?> get props => [appointments];
}

class AppointmentDetailsLoaded extends DoctorState {
  const AppointmentDetailsLoaded(this.appointment);
  final AppointmentModel appointment;

  @override
  List<Object?> get props => [appointment];
}

class AppointmentAccepted extends DoctorState {
  const AppointmentAccepted(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class AppointmentRejected extends DoctorState {
  const AppointmentRejected(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class AppointmentCancelled extends DoctorState {
  const AppointmentCancelled(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class AppointmentCompleted extends DoctorState {
  const AppointmentCompleted(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class AppointmentRescheduled extends DoctorState {
  const AppointmentRescheduled(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

// Prescription States
class PrescriptionCreated extends DoctorState {
  const PrescriptionCreated(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class PrescriptionsLoaded extends DoctorState {
  const PrescriptionsLoaded(this.prescriptions);
  final List<PrescriptionModel> prescriptions;

  @override
  List<Object?> get props => [prescriptions];
}

class PrescriptionUpdated extends DoctorState {
  const PrescriptionUpdated(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class PrescriptionDeleted extends DoctorState {
  const PrescriptionDeleted(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

// Remote Session States
class RemoteSessionStarted extends DoctorState {
  const RemoteSessionStarted(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class RemoteSessionEnded extends DoctorState {
  const RemoteSessionEnded(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class SessionTokenGenerated extends DoctorState {
  const SessionTokenGenerated(this.token);
  final String token;

  @override
  List<Object?> get props => [token];
}

// Lab Results States
class LabResultUploaded extends DoctorState {
  const LabResultUploaded(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class LabResultsLoaded extends DoctorState {
  const LabResultsLoaded(this.results);
  final List<Map<String, dynamic>> results;

  @override
  List<Object?> get props => [results];
}

// Statistics States
class DashboardStatsLoaded extends DoctorState {
  const DashboardStatsLoaded(this.stats);
  final Map<String, dynamic> stats;

  @override
  List<Object?> get props => [stats];
}

// Remote Session Request States
class RemoteSessionRequestsLoaded extends DoctorState {
  const RemoteSessionRequestsLoaded(this.requests);
  final List<AppointmentModel> requests;

  @override
  List<Object?> get props => [requests];
}

class RemoteSessionRequestApproved extends DoctorState {
  const RemoteSessionRequestApproved(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class RemoteSessionRequestRejected extends DoctorState {
  const RemoteSessionRequestRejected(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

// Error State
class DoctorError extends DoctorState {
  const DoctorError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
