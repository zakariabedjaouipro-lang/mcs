/// Patient Events
library;

import 'package:equatable/equatable.dart';
import 'package:mcs/core/models/appointment_model.dart';
import 'package:mcs/core/models/lab_result_model.dart';
import 'package:mcs/core/models/prescription_model.dart';
import 'package:mcs/core/models/video_session_model.dart';
import 'package:mcs/core/models/user_model.dart';

/// Base class for patient events
abstract class PatientEvent extends Equatable {
  const PatientEvent();

  @override
  List<Object?> get props => [];
}

// ═════════════════════════════════════════════════════════════════════════════
// Appointments Events
// ═════════════════════════════════════════════════════════════════════════════

/// Load all appointments
class LoadAppointments extends PatientEvent {}

/// Load appointment by ID
class LoadAppointmentById extends PatientEvent {
  final String appointmentId;

  const LoadAppointmentById(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

/// Book new appointment
class BookAppointment extends PatientEvent {
  final String clinicId;
  final String doctorId;
  final DateTime appointmentDate;
  final String timeSlot;
  final String appointmentType;
  final String? notes;

  const BookAppointment({
    required this.clinicId,
    required this.doctorId,
    required this.appointmentDate,
    required this.timeSlot,
    required this.appointmentType,
    this.notes,
  });

  @override
  List<Object?> get props => [
        clinicId,
        doctorId,
        appointmentDate,
        timeSlot,
        appointmentType,
        notes,
      ];
}

/// Cancel appointment
class CancelAppointment extends PatientEvent {
  final String appointmentId;

  const CancelAppointment(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

/// Reschedule appointment
class RescheduleAppointment extends PatientEvent {
  final String appointmentId;
  final DateTime newDate;
  final String newTimeSlot;

  const RescheduleAppointment({
    required this.appointmentId,
    required this.newDate,
    required this.newTimeSlot,
  });

  @override
  List<Object?> get props => [appointmentId, newDate, newTimeSlot];
}

// ═════════════════════════════════════════════════════════════════════════════
// Remote Sessions Events
// ═════════════════════════════════════════════════════════════════════════════

/// Load all remote sessions
class LoadRemoteSessions extends PatientEvent {}

/// Load upcoming remote sessions
class LoadUpcomingRemoteSessions extends PatientEvent {}

/// Load past remote sessions
class LoadPastRemoteSessions extends PatientEvent {}

/// Join video session
class JoinVideoSession extends PatientEvent {
  final String sessionId;

  const JoinVideoSession(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

/// Leave video session
class LeaveVideoSession extends PatientEvent {
  final String channelId;

  const LeaveVideoSession(this.channelId);

  @override
  List<Object?> get props => [channelId];
}

// ═════════════════════════════════════════════════════════════════════════════
// Prescriptions Events
// ═════════════════════════════════════════════════════════════════════════════

/// Load all prescriptions
class LoadPrescriptions extends PatientEvent {}

/// Load prescription by ID
class LoadPrescriptionById extends PatientEvent {
  final String prescriptionId;

  const LoadPrescriptionById(this.prescriptionId);

  @override
  List<Object?> get props => [prescriptionId];
}

/// Load active prescriptions
class LoadActivePrescriptions extends PatientEvent {}

// ═════════════════════════════════════════════════════════════════════════════
// Lab Results Events
// ═════════════════════════════════════════════════════════════════════════════

/// Load all lab results
class LoadLabResults extends PatientEvent {}

/// Load lab result by ID
class LoadLabResultById extends PatientEvent {
  final String labResultId;

  const LoadLabResultById(this.labResultId);

  @override
  List<Object?> get props => [labResultId];
}

/// Download lab result
class DownloadLabResult extends PatientEvent {
  final String labResultId;

  const DownloadLabResult(this.labResultId);

  @override
  List<Object?> get props => [labResultId];
}

// ═════════════════════════════════════════════════════════════════════════════
// Profile Events
// ═════════════════════════════════════════════════════════════════════════════

/// Load user profile
class LoadProfile extends PatientEvent {}

/// Update user profile
class UpdateProfile extends PatientEvent {
  final String? name;
  final String? phone;
  final String? address;
  final DateTime? dateOfBirth;
  final String? bloodType;
  final String? allergies;
  final String? emergencyContact;
  final String? emergencyPhone;

  const UpdateProfile({
    this.name,
    this.phone,
    this.address,
    this.dateOfBirth,
    this.bloodType,
    this.allergies,
    this.emergencyContact,
    this.emergencyPhone,
  });

  @override
  List<Object?> get props => [
        name,
        phone,
        address,
        dateOfBirth,
        bloodType,
        allergies,
        emergencyContact,
        emergencyPhone,
      ];
}

/// Change password
class ChangePassword extends PatientEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePassword({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

// ═════════════════════════════════════════════════════════════════════════════
// Social Accounts Events
// ═════════════════════════════════════════════════════════════════════════════

/// Link social account
class LinkSocialAccount extends PatientEvent {
  final String provider;
  final String providerId;
  final String accessToken;

  const LinkSocialAccount({
    required this.provider,
    required this.providerId,
    required this.accessToken,
  });

  @override
  List<Object?> get props => [provider, providerId, accessToken];
}

/// Unlink social account
class UnlinkSocialAccount extends PatientEvent {
  final String provider;

  const UnlinkSocialAccount(this.provider);

  @override
  List<Object?> get props => [provider];
}

/// Load linked social accounts
class LoadLinkedSocialAccounts extends PatientEvent {}

// ═════════════════════════════════════════════════════════════════════════════
// Navigation Events
// ═════════════════════════════════════════════════════════════════════════════

/// Navigate to appointments screen
class NavigateToAppointments extends PatientEvent {}

/// Navigate to appointments booking screen
class NavigateToBooking extends PatientEvent {}

/// Navigate to remote sessions screen
class NavigateToRemoteSessions extends PatientEvent {}

/// Navigate to prescriptions screen
class NavigateToPrescriptions extends PatientEvent {}

/// Navigate to lab results screen
class NavigateToLabResults extends PatientEvent {}

/// Navigate to profile screen
class NavigateToProfile extends PatientEvent {}

/// Navigate to settings screen
class NavigateToSettings extends PatientEvent {}

// ═════════════════════════════════════════════════════════════════════════════
// Generic Events
// ═════════════════════════════════════════════════════════════════════════════

/// Set loading state
class SetLoading extends PatientEvent {
  final bool isLoading;

  const SetLoading(this.isLoading);

  @override
  List<Object?> get props => [isLoading];
}

/// Clear patient state
class ClearPatientState extends PatientEvent {}