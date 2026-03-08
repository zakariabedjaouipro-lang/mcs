/// Doctor Events
library;

import 'package:equatable/equatable.dart';
import 'package:mcs/core/models/doctor_model.dart';
import 'package:mcs/core/models/prescription_model.dart';

/// Base doctor event
abstract class DoctorEvent extends Equatable {
  const DoctorEvent();

  @override
  List<Object?> get props => [];
}

// Profile Events
class LoadDoctorProfile extends DoctorEvent {
  const LoadDoctorProfile();
}

class UpdateDoctorProfile extends DoctorEvent {
  const UpdateDoctorProfile(this.profile);
  final DoctorModel profile;

  @override
  List<Object?> get props => [profile];
}

class ToggleAvailability extends DoctorEvent {
  const ToggleAvailability(this.isAvailable);
  final bool isAvailable;

  @override
  List<Object?> get props => [isAvailable];
}

// Patient Events
class LoadPatients extends DoctorEvent {
  const LoadPatients();
}

class LoadPatientDetails extends DoctorEvent {
  const LoadPatientDetails(this.patientId);
  final String patientId;

  @override
  List<Object?> get props => [patientId];
}

class SearchPatients extends DoctorEvent {
  const SearchPatients(this.query);
  final String query;

  @override
  List<Object?> get props => [query];
}

// Appointment Events
class LoadAppointments extends DoctorEvent {
  const LoadAppointments({
    this.startDate,
    this.endDate,
    this.status,
  });
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status;

  @override
  List<Object?> get props => [startDate, endDate, status];
}

class LoadAppointmentDetails extends DoctorEvent {
  const LoadAppointmentDetails(this.appointmentId);
  final String appointmentId;

  @override
  List<Object?> get props => [appointmentId];
}

class AcceptAppointment extends DoctorEvent {
  const AcceptAppointment(this.appointmentId);
  final String appointmentId;

  @override
  List<Object?> get props => [appointmentId];
}

class RejectAppointment extends DoctorEvent {
  const RejectAppointment(this.appointmentId, this.reason);
  final String appointmentId;
  final String reason;

  @override
  List<Object?> get props => [appointmentId, reason];
}

class CancelAppointment extends DoctorEvent {
  const CancelAppointment(this.appointmentId, this.reason);
  final String appointmentId;
  final String reason;

  @override
  List<Object?> get props => [appointmentId, reason];
}

class CompleteAppointment extends DoctorEvent {
  const CompleteAppointment(this.appointmentId, this.notes);
  final String appointmentId;
  final Map<String, dynamic> notes;

  @override
  List<Object?> get props => [appointmentId, notes];
}

class RescheduleAppointment extends DoctorEvent {
  const RescheduleAppointment(this.appointmentId, this.newDateTime);
  final String appointmentId;
  final DateTime newDateTime;

  @override
  List<Object?> get props => [appointmentId, newDateTime];
}

// Prescription Events
class CreatePrescription extends DoctorEvent {
  const CreatePrescription(this.prescription);
  final PrescriptionModel prescription;

  @override
  List<Object?> get props => [prescription];
}

class LoadPrescriptions extends DoctorEvent {
  const LoadPrescriptions(this.patientId);
  final String patientId;

  @override
  List<Object?> get props => [patientId];
}

class UpdatePrescription extends DoctorEvent {
  const UpdatePrescription(this.prescriptionId, this.prescription);
  final String prescriptionId;
  final PrescriptionModel prescription;

  @override
  List<Object?> get props => [prescriptionId, prescription];
}

class DeletePrescription extends DoctorEvent {
  const DeletePrescription(this.prescriptionId);
  final String prescriptionId;

  @override
  List<Object?> get props => [prescriptionId];
}

// Remote Session Events
class StartRemoteSession extends DoctorEvent {
  const StartRemoteSession(this.appointmentId);
  final String appointmentId;

  @override
  List<Object?> get props => [appointmentId];
}

class EndRemoteSession extends DoctorEvent {
  const EndRemoteSession(this.sessionId);
  final String sessionId;

  @override
  List<Object?> get props => [sessionId];
}

class GenerateSessionToken extends DoctorEvent {
  const GenerateSessionToken(this.appointmentId);
  final String appointmentId;

  @override
  List<Object?> get props => [appointmentId];
}

// Lab Results Events
class UploadLabResult extends DoctorEvent {
  const UploadLabResult(this.labResult);
  final Map<String, dynamic> labResult;

  @override
  List<Object?> get props => [labResult];
}

class LoadLabResults extends DoctorEvent {
  const LoadLabResults(this.patientId);
  final String patientId;

  @override
  List<Object?> get props => [patientId];
}

// Statistics Events
class LoadDashboardStats extends DoctorEvent {
  const LoadDashboardStats();
}

// Remote Session Request Events
class LoadRemoteSessionRequests extends DoctorEvent {
  const LoadRemoteSessionRequests();
}

class ApproveRemoteSessionRequest extends DoctorEvent {
  const ApproveRemoteSessionRequest(this.appointmentId);
  final String appointmentId;

  @override
  List<Object?> get props => [appointmentId];
}

class RejectRemoteSessionRequest extends DoctorEvent {
  const RejectRemoteSessionRequest(this.appointmentId, this.reason);
  final String appointmentId;
  final String reason;

  @override
  List<Object?> get props => [appointmentId, reason];
}
