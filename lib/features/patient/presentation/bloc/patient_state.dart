/// Patient States
library;

import 'package:equatable/equatable.dart';
import 'package:mcs/core/models/appointment_model.dart';
import 'package:mcs/core/models/lab_result_model.dart';
import 'package:mcs/core/models/prescription_model.dart';
import 'package:mcs/core/models/user_model.dart';
import 'package:mcs/core/models/video_session_model.dart';

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
  const AppointmentsLoaded(this.appointments);
  final List<AppointmentModel> appointments;

  @override
  List<Object?> get props => [appointments];
}

/// Appointment loaded
class AppointmentLoaded extends PatientState {
  const AppointmentLoaded(this.appointment);
  final AppointmentModel appointment;

  @override
  List<Object?> get props => [appointment];
}

/// Appointment booked
class AppointmentBooked extends PatientState {
  const AppointmentBooked(this.appointment);
  final AppointmentModel appointment;

  @override
  List<Object?> get props => [appointment];
}

/// Appointment cancelled
class AppointmentCancelled extends PatientState {
  const AppointmentCancelled(this.appointmentId);
  final String appointmentId;

  @override
  List<Object?> get props => [appointmentId];
}

/// Appointment rescheduled
class AppointmentRescheduled extends PatientState {
  const AppointmentRescheduled(this.appointment);
  final AppointmentModel appointment;

  @override
  List<Object?> get props => [appointment];
}

// ═════════════════════════════════════════════════════════════════════════════
// Remote Sessions States
// ═════════════════════════════════════════════════════════════════════════════

/// Remote sessions loaded
class RemoteSessionsLoaded extends PatientState {
  const RemoteSessionsLoaded(this.sessions);
  final List<VideoSessionModel> sessions;

  @override
  List<Object?> get props => [sessions];
}

/// Upcoming remote sessions loaded
class UpcomingRemoteSessionsLoaded extends PatientState {
  const UpcomingRemoteSessionsLoaded(this.sessions);
  final List<VideoSessionModel> sessions;

  @override
  List<Object?> get props => [sessions];
}

/// Past remote sessions loaded
class PastRemoteSessionsLoaded extends PatientState {
  const PastRemoteSessionsLoaded(this.sessions);
  final List<VideoSessionModel> sessions;

  @override
  List<Object?> get props => [sessions];
}

/// Video session joined
class VideoSessionJoined extends PatientState {
  const VideoSessionJoined(this.channelId);
  final String channelId;

  @override
  List<Object?> get props => [channelId];
}

/// Video session left
class VideoSessionLeft extends PatientState {
  const VideoSessionLeft(this.channelId);
  final String channelId;

  @override
  List<Object?> get props => [channelId];
}

// ═════════════════════════════════════════════════════════════════════════════
// Prescriptions States
// ═════════════════════════════════════════════════════════════════════════════

/// Prescriptions loaded
class PrescriptionsLoaded extends PatientState {
  const PrescriptionsLoaded(this.prescriptions);
  final List<PrescriptionModel> prescriptions;

  @override
  List<Object?> get props => [prescriptions];
}

/// Prescription loaded
class PrescriptionLoaded extends PatientState {
  const PrescriptionLoaded(this.prescription);
  final PrescriptionModel prescription;

  @override
  List<Object?> get props => [prescription];
}

/// Active prescriptions loaded
class ActivePrescriptionsLoaded extends PatientState {
  const ActivePrescriptionsLoaded(this.prescriptions);
  final List<PrescriptionModel> prescriptions;

  @override
  List<Object?> get props => [prescriptions];
}

// ═════════════════════════════════════════════════════════════════════════════
// Lab Results States
// ═════════════════════════════════════════════════════════════════════════════

/// Lab results loaded
class LabResultsLoaded extends PatientState {
  const LabResultsLoaded(this.results);
  final List<LabResultModel> results;

  @override
  List<Object?> get props => [results];
}

/// Lab result loaded
class LabResultLoaded extends PatientState {
  const LabResultLoaded(this.result);
  final LabResultModel result;

  @override
  List<Object?> get props => [result];
}

/// Lab result downloaded
class LabResultDownloaded extends PatientState {
  const LabResultDownloaded(this.downloadUrl);
  final String downloadUrl;

  @override
  List<Object?> get props => [downloadUrl];
}

// ═════════════════════════════════════════════════════════════════════════════
// Profile States
// ═════════════════════════════════════════════════════════════════════════════

/// Profile loaded
class ProfileLoaded extends PatientState {
  const ProfileLoaded(this.user);
  final UserModel user;

  @override
  List<Object?> get props => [user];
}

/// Profile updated
class ProfileUpdated extends PatientState {
  const ProfileUpdated(this.user);
  final UserModel user;

  @override
  List<Object?> get props => [user];
}

/// Password changed
class PasswordChanged extends PatientState {
  const PasswordChanged(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

// ═════════════════════════════════════════════════════════════════════════════
// Social Accounts States
// ═════════════════════════════════════════════════════════════════════════════

/// Social account linked
class SocialAccountLinked extends PatientState {
  const SocialAccountLinked(this.user);
  final UserModel user;

  @override
  List<Object?> get props => [user];
}

/// Social account unlinked
class SocialAccountUnlinked extends PatientState {
  const SocialAccountUnlinked(this.user);
  final UserModel user;

  @override
  List<Object?> get props => [user];
}

/// Linked social accounts loaded
class LinkedSocialAccountsLoaded extends PatientState {
  const LinkedSocialAccountsLoaded(this.accounts);
  final List<Map<String, dynamic>> accounts;

  @override
  List<Object?> get props => [accounts];
}

// ═════════════════════════════════════════════════════════════════════════════
// Error States
// ═════════════════════════════════════════════════════════════════════════════

/// Error state
class PatientError extends PatientState {
  const PatientError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

// ═════════════════════════════════════════════════════════════════════════════
// Success States
// ═════════════════════════════════════════════════════════════════════════════

/// Success state
class PatientSuccess extends PatientState {
  const PatientSuccess(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
