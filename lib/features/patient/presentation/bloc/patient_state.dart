/// Patient States
library;

import 'package:equatable/equatable.dart';
import 'package:mcs/core/models/appointment_model.dart';
import 'package:mcs/core/models/lab_result_model.dart';
import 'package:mcs/core/models/prescription_model.dart';
import 'package:mcs/core/models/video_session_model.dart';
import 'package:mcs/core/models/user_model.dart';

/// Base class for patient states
abstract class PatientState extends Equatable {
  const PatientState();

  @override
  List<Object?> get props => [];
}

// ═════════════════════════════════════════════════════════════════════════════
// Initial States
// ═════════════════════════════════════════════════════════════════════════════

/// Initial state
class PatientInitial extends PatientState {}

/// Loading state
class PatientLoading extends PatientState {}

// ═════════════════════════════════════════════════════════════════════════════
// Appointments States
// ═════════════════════════════════════════════════════════════════════════════

/// Appointments loaded
class AppointmentsLoaded extends PatientState {
  final List<AppointmentModel> appointments;

  const AppointmentsLoaded(this.appointments);

  @override
  List<Object?> get props => [appointments];
}

/// Appointment loaded
class AppointmentLoaded extends PatientState {
  final AppointmentModel appointment;

  const AppointmentLoaded(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

/// Appointment booked
class AppointmentBooked extends PatientState {
  final AppointmentModel appointment;

  const AppointmentBooked(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

/// Appointment cancelled
class AppointmentCancelled extends PatientState {
  final String appointmentId;

  const AppointmentCancelled(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

/// Appointment rescheduled
class AppointmentRescheduled extends PatientState {
  final AppointmentModel appointment;

  const AppointmentRescheduled(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

// ═════════════════════════════════════════════════════════════════════════════
// Remote Sessions States
// ═════════════════════════════════════════════════════════════════════════════

/// Remote sessions loaded
class RemoteSessionsLoaded extends PatientState {
  final List<VideoSessionModel> sessions;

  const RemoteSessionsLoaded(this.sessions);

  @override
  List<Object?> get props => [sessions];
}

/// Upcoming remote sessions loaded
class UpcomingRemoteSessionsLoaded extends PatientState {
  final List<VideoSessionModel> sessions;

  const UpcomingRemoteSessionsLoaded(this.sessions);

  @override
  List<Object?> get props => [sessions];
}

/// Past remote sessions loaded
class PastRemoteSessionsLoaded extends PatientState {
  final List<VideoSessionModel> sessions;

  const PastRemoteSessionsLoaded(this.sessions);

  @override
  List<Object?> get props => [sessions];
}

/// Video session joined
class VideoSessionJoined extends PatientState {
  final String channelId;

  const VideoSessionJoined(this.channelId);

  @override
  List<Object?> get props => [channelId];
}

/// Video session left
class VideoSessionLeft extends PatientState {
  final String channelId;

  const VideoSessionLeft(this.channelId);

  @override
  List<Object?> get props => [channelId];
}

// ═════════════════════════════════════════════════════════════════════════════
// Prescriptions States
// ═════════════════════════════════════════════════════════════════════════════

/// Prescriptions loaded
class PrescriptionsLoaded extends PatientState {
  final List<PrescriptionModel> prescriptions;

  const PrescriptionsLoaded(this.prescriptions);

  @override
  List<Object?> get props => [prescriptions];
}

/// Prescription loaded
class PrescriptionLoaded extends PatientState {
  final PrescriptionModel prescription;

  const PrescriptionLoaded(this.prescription);

  @override
  List<Object?> get props => [prescription];
}

/// Active prescriptions loaded
class ActivePrescriptionsLoaded extends PatientState {
  final List<PrescriptionModel> prescriptions;

  const ActivePrescriptionsLoaded(this.prescriptions);

  @override
  List<Object?> get props => [prescriptions];
}

// ═════════════════════════════════════════════════════════════════════════════
// Lab Results States
// ═════════════════════════════════════════════════════════════════════════════

/// Lab results loaded
class LabResultsLoaded extends PatientState {
  final List<LabResultModel> results;

  const LabResultsLoaded(this.results);

  @override
  List<Object?> get props => [results];
}

/// Lab result loaded
class LabResultLoaded extends PatientState {
  final LabResultModel result;

  const LabResultLoaded(this.result);

  @override
  List<Object?> get props => [result];
}

/// Lab result downloaded
class LabResultDownloaded extends PatientState {
  final String downloadUrl;

  const LabResultDownloaded(this.downloadUrl);

  @override
  List<Object?> get props => [downloadUrl];
}

// ═════════════════════════════════════════════════════════════════════════════
// Profile States
// ═════════════════════════════════════════════════════════════════════════════

/// Profile loaded
class ProfileLoaded extends PatientState {
  final UserModel user;

  const ProfileLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

/// Profile updated
class ProfileUpdated extends PatientState {
  final UserModel user;

  const ProfileUpdated(this.user);

  @override
  List<Object?> get props => [user];
}

/// Password changed
class PasswordChanged extends PatientState {
  final String message;

  const PasswordChanged(this.message);

  @override
  List<Object?> get props => [message];
}

// ═════════════════════════════════════════════════════════════════════════════
// Social Accounts States
// ═════════════════════════════════════════════════════════════════════════════

/// Social account linked
class SocialAccountLinked extends PatientState {
  final UserModel user;

  const SocialAccountLinked(this.user);

  @override
  List<Object?> get props => [user];
}

/// Social account unlinked
class SocialAccountUnlinked extends PatientState {
  final UserModel user;

  const SocialAccountUnlinked(this.user);

  @override
  List<Object?> get props => [user];
}

/// Linked social accounts loaded
class LinkedSocialAccountsLoaded extends PatientState {
  final List<Map<String, dynamic>> accounts;

  const LinkedSocialAccountsLoaded(this.accounts);

  @override
  List<Object?> get props => [accounts];
}

// ═════════════════════════════════════════════════════════════════════════════
// Error States
// ═════════════════════════════════════════════════════════════════════════════

/// Error state
class PatientError extends PatientState {
  final String message;

  const PatientError(this.message);

  @override
  List<Object?> get props => [message];
}

// ═════════════════════════════════════════════════════════════════════════════
// Success States
// ═════════════════════════════════════════════════════════════════════════════

/// Success state
class PatientSuccess extends PatientState {
  final String message;

  const PatientSuccess(this.message);

  @override
  List<Object?> get props => [message];
}