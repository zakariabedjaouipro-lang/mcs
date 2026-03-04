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
  final DoctorModel profile;

  const DoctorProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class DoctorProfileUpdated extends DoctorState {
  final String message;

  const DoctorProfileUpdated(this.message);

  @override
  List<Object?> get props => [message];
}

class AvailabilityToggled extends DoctorState {
  final bool isAvailable;

  const AvailabilityToggled(this.isAvailable);

  @override
  List<Object?> get props => [isAvailable];
}

// Patient States
class PatientsLoaded extends DoctorState {
  final List<PatientModel> patients;

  const PatientsLoaded(this.patients);

  @override
  List<Object?> get props => [patients];
}

class PatientDetailsLoaded extends DoctorState {
  final PatientModel patient;

  const PatientDetailsLoaded(this.patient);

  @override
  List<Object?> get props => [patient];
}

class PatientsSearched extends DoctorState {
  final List<PatientModel> patients;

  const PatientsSearched(this.patients);

  @override
  List<Object?> get props => [patients];
}

// Appointment States
class AppointmentsLoaded extends DoctorState {
  final List<AppointmentModel> appointments;

  const AppointmentsLoaded(this.appointments);

  @override
  List<Object?> get props => [appointments];
}

class AppointmentDetailsLoaded extends DoctorState {
  final AppointmentModel appointment;

  const AppointmentDetailsLoaded(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

class AppointmentAccepted extends DoctorState {
  final String message;

  const AppointmentAccepted(this.message);

  @override
  List<Object?> get props => [message];
}

class AppointmentRejected extends DoctorState {
  final String message;

  const AppointmentRejected(this.message);

  @override
  List<Object?> get props => [message];
}

class AppointmentCancelled extends DoctorState {
  final String message;

  const AppointmentCancelled(this.message);

  @override
  List<Object?> get props => [message];
}

class AppointmentCompleted extends DoctorState {
  final String message;

  const AppointmentCompleted(this.message);

  @override
  List<Object?> get props => [message];
}

class AppointmentRescheduled extends DoctorState {
  final String message;

  const AppointmentRescheduled(this.message);

  @override
  List<Object?> get props => [message];
}

// Prescription States
class PrescriptionCreated extends DoctorState {
  final String message;

  const PrescriptionCreated(this.message);

  @override
  List<Object?> get props => [message];
}

class PrescriptionsLoaded extends DoctorState {
  final List<PrescriptionModel> prescriptions;

  const PrescriptionsLoaded(this.prescriptions);

  @override
  List<Object?> get props => [prescriptions];
}

class PrescriptionUpdated extends DoctorState {
  final String message;

  const PrescriptionUpdated(this.message);

  @override
  List<Object?> get props => [message];
}

class PrescriptionDeleted extends DoctorState {
  final String message;

  const PrescriptionDeleted(this.message);

  @override
  List<Object?> get props => [message];
}

// Remote Session States
class RemoteSessionStarted extends DoctorState {
  final String message;

  const RemoteSessionStarted(this.message);

  @override
  List<Object?> get props => [message];
}

class RemoteSessionEnded extends DoctorState {
  final String message;

  const RemoteSessionEnded(this.message);

  @override
  List<Object?> get props => [message];
}

class SessionTokenGenerated extends DoctorState {
  final String token;

  const SessionTokenGenerated(this.token);

  @override
  List<Object?> get props => [token];
}

// Lab Results States
class LabResultUploaded extends DoctorState {
  final String message;

  const LabResultUploaded(this.message);

  @override
  List<Object?> get props => [message];
}

class LabResultsLoaded extends DoctorState {
  final List<Map<String, dynamic>> results;

  const LabResultsLoaded(this.results);

  @override
  List<Object?> get props => [results];
}

// Statistics States
class DashboardStatsLoaded extends DoctorState {
  final Map<String, dynamic> stats;

  const DashboardStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

// Remote Session Request States
class RemoteSessionRequestsLoaded extends DoctorState {
  final List<AppointmentModel> requests;

  const RemoteSessionRequestsLoaded(this.requests);

  @override
  List<Object?> get props => [requests];
}

class RemoteSessionRequestApproved extends DoctorState {
  final String message;

  const RemoteSessionRequestApproved(this.message);

  @override
  List<Object?> get props => [message];
}

class RemoteSessionRequestRejected extends DoctorState {
  final String message;

  const RemoteSessionRequestRejected(this.message);

  @override
  List<Object?> get props => [message];
}

// Error State
class DoctorError extends DoctorState {
  final String message;

  const DoctorError(this.message);

  @override
  List<Object?> get props => [message];
}