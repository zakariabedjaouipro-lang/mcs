/// Employee Events
library;

import 'package:equatable/equatable.dart';
import 'package:mcs/core/models/appointment_model.dart';
import 'package:mcs/core/models/employee_model.dart';
import 'package:mcs/core/models/inventory_model.dart';
import 'package:mcs/core/models/invoice_model.dart';
import 'package:mcs/core/models/patient_model.dart';

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
  final EmployeeModel profile;

  const UpdateEmployeeProfile(this.profile);

  @override
  List<Object?> get props => [profile];
}

// Patient Events
class LoadPatients extends EmployeeEvent {
  const LoadPatients();
}

class LoadPatientDetails extends EmployeeEvent {
  final String patientId;

  const LoadPatientDetails(this.patientId);

  @override
  List<Object?> get props => [patientId];
}

class RegisterPatient extends EmployeeEvent {
  final Map<String, dynamic> patientData;

  const RegisterPatient(this.patientData);

  @override
  List<Object?> get props => [patientData];
}

class UpdatePatient extends EmployeeEvent {
  final String patientId;
  final Map<String, dynamic> patientData;

  const UpdatePatient(this.patientId, this.patientData);

  @override
  List<Object?> get props => [patientId, patientData];
}

class SearchPatients extends EmployeeEvent {
  final String query;

  const SearchPatients(this.query);

  @override
  List<Object?> get props => [query];
}

// Appointment Events
class LoadAppointments extends EmployeeEvent {
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

class LoadAppointmentDetails extends EmployeeEvent {
  final String appointmentId;

  const LoadAppointmentDetails(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

class BookAppointment extends EmployeeEvent {
  final Map<String, dynamic> appointmentData;

  const BookAppointment(this.appointmentData);

  @override
  List<Object?> get props => [appointmentData];
}

class CancelAppointment extends EmployeeEvent {
  final String appointmentId;
  final String reason;

  const CancelAppointment(this.appointmentId, this.reason);

  @override
  List<Object?> get props => [appointmentId, reason];
}

class RescheduleAppointment extends EmployeeEvent {
  final String appointmentId;
  final DateTime newDateTime;

  const RescheduleAppointment(this.appointmentId, this.newDateTime);

  @override
  List<Object?> get props => [appointmentId, newDateTime];
}

class CheckInPatient extends EmployeeEvent {
  final String appointmentId;

  const CheckInPatient(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

class CheckOutPatient extends EmployeeEvent {
  final String appointmentId;

  const CheckOutPatient(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

// Vital Signs Events
class RecordVitalSigns extends EmployeeEvent {
  final String patientId;
  final Map<String, dynamic> vitalSigns;

  const RecordVitalSigns(this.patientId, this.vitalSigns);

  @override
  List<Object?> get props => [patientId, vitalSigns];
}

class LoadPatientVitalSigns extends EmployeeEvent {
  final String patientId;

  const LoadPatientVitalSigns(this.patientId);

  @override
  List<Object?> get props => [patientId];
}

// Lab Results Events
class UploadLabResult extends EmployeeEvent {
  final Map<String, dynamic> labResult;

  const UploadLabResult(this.labResult);

  @override
  List<Object?> get props => [labResult];
}

class LoadLabResults extends EmployeeEvent {
  final String patientId;

  const LoadLabResults(this.patientId);

  @override
  List<Object?> get props => [patientId];
}

class UpdateLabResult extends EmployeeEvent {
  final String resultId;
  final Map<String, dynamic> resultData;

  const UpdateLabResult(this.resultId, this.resultData);

  @override
  List<Object?> get props => [resultId, resultData];
}

// Inventory Events
class LoadInventory extends EmployeeEvent {
  const LoadInventory();
}

class LoadInventoryItem extends EmployeeEvent {
  final String itemId;

  const LoadInventoryItem(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class AddInventoryItem extends EmployeeEvent {
  final Map<String, dynamic> itemData;

  const AddInventoryItem(this.itemData);

  @override
  List<Object?> get props => [itemData];
}

class UpdateInventoryItem extends EmployeeEvent {
  final String itemId;
  final Map<String, dynamic> itemData;

  const UpdateInventoryItem(this.itemId, this.itemData);

  @override
  List<Object?> get props => [itemId, itemData];
}

class DeleteInventoryItem extends EmployeeEvent {
  final String itemId;

  const DeleteInventoryItem(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class RecordInventoryTransaction extends EmployeeEvent {
  final Map<String, dynamic> transactionData;

  const RecordInventoryTransaction(this.transactionData);

  @override
  List<Object?> get props => [transactionData];
}

// Invoice Events
class LoadInvoices extends EmployeeEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status;

  const LoadInvoices({
    this.startDate,
    this.endDate,
    this.status,
  });

  @override
  List<Object?> get props => [startDate, endDate, status];
}

class LoadInvoiceDetails extends EmployeeEvent {
  final String invoiceId;

  const LoadInvoiceDetails(this.invoiceId);

  @override
  List<Object?> get props => [invoiceId];
}

class CreateInvoice extends EmployeeEvent {
  final Map<String, dynamic> invoiceData;

  const CreateInvoice(this.invoiceData);

  @override
  List<Object?> get props => [invoiceData];
}

class UpdateInvoice extends EmployeeEvent {
  final String invoiceId;
  final Map<String, dynamic> invoiceData;

  const UpdateInvoice(this.invoiceId, this.invoiceData);

  @override
  List<Object?> get props => [invoiceId, invoiceData];
}

class ProcessPayment extends EmployeeEvent {
  final String invoiceId;
  final Map<String, dynamic> paymentData;

  const ProcessPayment(this.invoiceId, this.paymentData);

  @override
  List<Object?> get props => [invoiceId, paymentData];
}

// Statistics Events
class LoadDashboardStats extends EmployeeEvent {
  const LoadDashboardStats();
}