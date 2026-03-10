/// Patient Events
library;

import 'package:equatable/equatable.dart';

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
  const LoadAppointmentById(this.appointmentId);
  final String appointmentId;

  @override
  List<Object?> get props => [appointmentId];
}

/// Book new appointment
class BookAppointment extends PatientEvent {
  const BookAppointment({
    required this.clinicId,
    required this.doctorId,
    required this.appointmentDate,
    required this.timeSlot,
    required this.appointmentType,
    this.notes,
  });
  final String clinicId;
  final String doctorId;
  final DateTime appointmentDate;
  final String timeSlot;
  final String appointmentType;
  final String? notes;

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
  const CancelAppointment(this.appointmentId);
  final String appointmentId;

  @override
  List<Object?> get props => [appointmentId];
}

/// Reschedule appointment
class RescheduleAppointment extends PatientEvent {
  const RescheduleAppointment({
    required this.appointmentId,
    required this.newDate,
    required this.newTimeSlot,
  });
  final String appointmentId;
  final DateTime newDate;
  final String newTimeSlot;

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
  const JoinVideoSession(this.sessionId);
  final String sessionId;

  @override
  List<Object?> get props => [sessionId];
}

/// Leave video session
class LeaveVideoSession extends PatientEvent {
  const LeaveVideoSession(this.channelId);
  final String channelId;

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
  const LoadPrescriptionById(this.prescriptionId);
  final String prescriptionId;

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
  const LoadLabResultById(this.labResultId);
  final String labResultId;

  @override
  List<Object?> get props => [labResultId];
}

/// Download lab result
class DownloadLabResult extends PatientEvent {
  const DownloadLabResult(this.labResultId);
  final String labResultId;

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
  final String? name;
  final String? phone;
  final String? address;
  final DateTime? dateOfBirth;
  final String? bloodType;
  final String? allergies;
  final String? emergencyContact;
  final String? emergencyPhone;

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
  const ChangePassword({
    required this.currentPassword,
    required this.newPassword,
  });
  final String currentPassword;
  final String newPassword;

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

// ═════════════════════════════════════════════════════════════════════════════
// Social Accounts Events
// ═════════════════════════════════════════════════════════════════════════════

/// Link social account
class LinkSocialAccount extends PatientEvent {
  const LinkSocialAccount({
    required this.provider,
    required this.providerId,
    required this.accessToken,
  });
  final String provider;
  final String providerId;
  final String accessToken;

  @override
  List<Object?> get props => [provider, providerId, accessToken];
}

/// Unlink social account
class UnlinkSocialAccount extends PatientEvent {
  const UnlinkSocialAccount(this.provider);
  final String provider;

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

/// Logout user
class LogoutEvent extends PatientEvent {}

// ═════════════════════════════════════════════════════════════════════════════
// Generic Events
// ═════════════════════════════════════════════════════════════════════════════

/// Set loading state
class SetLoading extends PatientEvent {
  const SetLoading({required this.isLoading});
  final bool isLoading;

  @override
  List<Object?> get props => [isLoading];
}

/// Clear patient state
class ClearPatientState extends PatientEvent {}
