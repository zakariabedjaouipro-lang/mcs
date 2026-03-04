/// Doctor Events
library;

import 'package:equatable/equatable.dart';
import 'package:mcs/core/models/appointment_model.dart';
import 'package:mcs/core/models/doctor_model.dart';
import 'package:mcs/core/models/patient_model.dart';
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
  final DoctorModel profile;

  const UpdateDoctorProfile(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ToggleAvailability extends DoctorEvent {
  final bool isAvailable;

  const ToggleAvailability(this.isAvailable);

  @override
  List<Object?> get props => [isAvailable];
}

// Patient Events
class LoadPatients extends DoctorEvent {
  const LoadPatients();
}

class LoadPatientDetails extends DoctorEvent {
  final String patientId;

  const LoadPatientDetails(this.patientId);

  @override
  List<Object?> get props => [patientId];
}

class SearchPatients extends DoctorEvent {
  final String query;

  const SearchPatients(this.query);

  @override
  List<Object?> get props => [query];
}

// Appointment Events
class LoadAppointments extends DoctorEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status;

  const LoadAppointments({
    this.startDate,
    this.endDate,
    this.status,
  });

  @override
  List<Object?> get props => [startDate, endDate, status];
}

class LoadAppointmentDetails extends DoctorEvent {
  final String appointmentId;

  const LoadAppointmentDetails(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

class AcceptAppointment extends DoctorEvent {
  final String appointmentId;

  const AcceptAppointment(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

class RejectAppointment extends DoctorEvent {
  final String appointmentId;
  final String reason;

  const RejectAppointment(this.appointmentId, this.reason);

  @override
  List<Object?> get props => [appointmentId, reason];
}

class CancelAppointment extends DoctorEvent {
  final String appointmentId;
  final String reason;

  const CancelAppointment(this.appointmentId, this.reason);

  @override
  List<Object?> get props => [appointmentId, reason];
}

class CompleteAppointment extends DoctorEvent {
  final String appointmentId;
  final Map<String, dynamic> notes;

  const CompleteAppointment(this.appointmentId, this.notes);

  @override
  List<Object?> get props => [appointmentId, notes];
}

class RescheduleAppointment extends DoctorEvent {
  final String appointmentId;
  final DateTime newDateTime;

  const RescheduleAppointment(this.appointmentId, this.newDateTime);

  @override
  List<Object?> get props => [appointmentId, newDateTime];
}

// Prescription Events
class CreatePrescription extends DoctorEvent {
  final PrescriptionModel prescription;

  const CreatePrescription(this.prescription);

  @override
  List<Object?> get props => [prescription];
}

class LoadPrescriptions extends DoctorEvent {
  final String patientId;

  const LoadPrescriptions(this.patientId);

  @override
  List<Object?> get props => [patientId];
}

class UpdatePrescription extends DoctorEvent {
  final String prescriptionId;
  final PrescriptionModel prescription;

  const UpdatePrescription(this.prescriptionId, this.prescription);

  @override
  List<Object?> get props => [prescriptionId, prescription];
}

class DeletePrescription extends DoctorEvent {
  final String prescriptionId;

  const DeletePrescription(this.prescriptionId);

  @override
  List<Object?> get props => [prescriptionId];
}

// Remote Session Events
class StartRemoteSession extends DoctorEvent {
  final String appointmentId;

  const StartRemoteSession(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

class EndRemoteSession extends DoctorEvent {
  final String sessionId;

  const EndRemoteSession(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class GenerateSessionToken extends DoctorEvent {
  final String appointmentId;

  const GenerateSessionToken(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

// Lab Results Events
class UploadLabResult extends DoctorEvent {
  final Map<String, dynamic> labResult;

  const UploadLabResult(this.labResult);

  @override
  List<Object?> get props => [labResult];
}

class LoadLabResults extends DoctorEvent {
  final String patientId;

  const LoadLabResults(this.patientId);

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
  final String appointmentId;

  const ApproveRemoteSessionRequest(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

class RejectRemoteSessionRequest extends DoctorEvent {
  final String appointmentId;
  final String reason;

  const RejectRemoteSessionRequest(this.appointmentId, this.reason);

  @override
  List<Object?> get props => [appointmentId, reason];
}