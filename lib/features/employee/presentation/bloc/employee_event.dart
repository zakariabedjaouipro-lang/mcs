/// Employee Events
library;

import 'package:equatable/equatable.dart';
import 'package:mcs/core/models/employee_model.dart';

/// Base employee event
abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object?> get props => [];
}

// Profile Events
class LoadEmployeeProfile extends EmployeeEvent {
  const LoadEmployeeProfile();
}

class UpdateEmployeeProfile extends EmployeeEvent {
  const UpdateEmployeeProfile(this.profile);
  final EmployeeModel profile;

  @override
  List<Object?> get props => [profile];
}

// Patient Events
class LoadPatients extends EmployeeEvent {
  const LoadPatients();
}

class LoadPatientDetails extends EmployeeEvent {
  const LoadPatientDetails(this.patientId);
  final String patientId;

  @override
  List<Object?> get props => [patientId];
}

class RegisterPatient extends EmployeeEvent {
  const RegisterPatient(this.patientData);
  final Map<String, dynamic> patientData;

  @override
  List<Object?> get props => [patientData];
}

class UpdatePatient extends EmployeeEvent {
  const UpdatePatient(this.patientId, this.patientData);
  final String patientId;
  final Map<String, dynamic> patientData;

  @override
  List<Object?> get props => [patientId, patientData];
}

class SearchPatients extends EmployeeEvent {
  const SearchPatients(this.query);
  final String query;

  @override
  List<Object?> get props => [query];
}

// Appointment Events
class LoadAppointments extends EmployeeEvent {
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

class LoadAppointmentDetails extends EmployeeEvent {
  const LoadAppointmentDetails(this.appointmentId);
  final String appointmentId;

  @override
  List<Object?> get props => [appointmentId];
}

class BookAppointment extends EmployeeEvent {
  const BookAppointment(this.appointmentData);
  final Map<String, dynamic> appointmentData;

  @override
  List<Object?> get props => [appointmentData];
}

class CancelAppointment extends EmployeeEvent {
  const CancelAppointment(this.appointmentId, this.reason);
  final String appointmentId;
  final String reason;

  @override
  List<Object?> get props => [appointmentId, reason];
}

class RescheduleAppointment extends EmployeeEvent {
  const RescheduleAppointment(this.appointmentId, this.newDateTime);
  final String appointmentId;
  final DateTime newDateTime;

  @override
  List<Object?> get props => [appointmentId, newDateTime];
}

class CheckInPatient extends EmployeeEvent {
  const CheckInPatient(this.appointmentId);
  final String appointmentId;

  @override
  List<Object?> get props => [appointmentId];
}

class CheckOutPatient extends EmployeeEvent {
  const CheckOutPatient(this.appointmentId);
  final String appointmentId;

  @override
  List<Object?> get props => [appointmentId];
}

// Vital Signs Events
class RecordVitalSigns extends EmployeeEvent {
  const RecordVitalSigns(this.patientId, this.vitalSigns);
  final String patientId;
  final Map<String, dynamic> vitalSigns;

  @override
  List<Object?> get props => [patientId, vitalSigns];
}

class LoadPatientVitalSigns extends EmployeeEvent {
  const LoadPatientVitalSigns(this.patientId);
  final String patientId;

  @override
  List<Object?> get props => [patientId];
}

// Lab Results Events
class UploadLabResult extends EmployeeEvent {
  const UploadLabResult(this.labResult);
  final Map<String, dynamic> labResult;

  @override
  List<Object?> get props => [labResult];
}

class LoadLabResults extends EmployeeEvent {
  const LoadLabResults(this.patientId);
  final String patientId;

  @override
  List<Object?> get props => [patientId];
}

class UpdateLabResult extends EmployeeEvent {
  const UpdateLabResult(this.resultId, this.resultData);
  final String resultId;
  final Map<String, dynamic> resultData;

  @override
  List<Object?> get props => [resultId, resultData];
}

// Inventory Events
class LoadInventory extends EmployeeEvent {
  const LoadInventory();
}

class LoadInventoryItem extends EmployeeEvent {
  const LoadInventoryItem(this.itemId);
  final String itemId;

  @override
  List<Object?> get props => [itemId];
}

class AddInventoryItem extends EmployeeEvent {
  const AddInventoryItem(this.itemData);
  final Map<String, dynamic> itemData;

  @override
  List<Object?> get props => [itemData];
}

class UpdateInventoryItem extends EmployeeEvent {
  const UpdateInventoryItem(this.itemId, this.itemData);
  final String itemId;
  final Map<String, dynamic> itemData;

  @override
  List<Object?> get props => [itemId, itemData];
}

class DeleteInventoryItem extends EmployeeEvent {
  const DeleteInventoryItem(this.itemId);
  final String itemId;

  @override
  List<Object?> get props => [itemId];
}

class RecordInventoryTransaction extends EmployeeEvent {
  const RecordInventoryTransaction(this.transactionData);
  final Map<String, dynamic> transactionData;

  @override
  List<Object?> get props => [transactionData];
}

// Invoice Events
class LoadInvoices extends EmployeeEvent {
  const LoadInvoices({
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

class LoadInvoiceDetails extends EmployeeEvent {
  const LoadInvoiceDetails(this.invoiceId);
  final String invoiceId;

  @override
  List<Object?> get props => [invoiceId];
}

class CreateInvoice extends EmployeeEvent {
  const CreateInvoice(this.invoiceData);
  final Map<String, dynamic> invoiceData;

  @override
  List<Object?> get props => [invoiceData];
}

class UpdateInvoice extends EmployeeEvent {
  const UpdateInvoice(this.invoiceId, this.invoiceData);
  final String invoiceId;
  final Map<String, dynamic> invoiceData;

  @override
  List<Object?> get props => [invoiceId, invoiceData];
}

class ProcessPayment extends EmployeeEvent {
  const ProcessPayment(this.invoiceId, this.paymentData);
  final String invoiceId;
  final Map<String, dynamic> paymentData;

  @override
  List<Object?> get props => [invoiceId, paymentData];
}

// Statistics Events
class LoadDashboardStats extends EmployeeEvent {
  const LoadDashboardStats();
}

