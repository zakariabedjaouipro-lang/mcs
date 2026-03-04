/// Employee States
library;

import 'package:equatable/equatable.dart';
import 'package:mcs/core/models/appointment_model.dart';
import 'package:mcs/core/models/employee_model.dart';
import 'package:mcs/core/models/inventory_model.dart';
import 'package:mcs/core/models/invoice_model.dart';
import 'package:mcs/core/models/patient_model.dart';

/// Base employee state
abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object?> get props => [];
}

// Initial State
class EmployeeInitial extends EmployeeState {
  const EmployeeInitial();
}

// Loading State
class EmployeeLoading extends EmployeeState {
  const EmployeeLoading();
}

// Profile States
class EmployeeProfileLoaded extends EmployeeState {
  final EmployeeModel profile;

  const EmployeeProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class EmployeeProfileUpdated extends EmployeeState {
  final String message;

  const EmployeeProfileUpdated(this.message);

  @override
  List<Object?> get props => [message];
}

// Patient States
class PatientsLoaded extends EmployeeState {
  final List<PatientModel> patients;

  const PatientsLoaded(this.patients);

  @override
  List<Object?> get props => [patients];
}

class PatientDetailsLoaded extends EmployeeState {
  final PatientModel patient;

  const PatientDetailsLoaded(this.patient);

  @override
  List<Object?> get props => [patient];
}

class PatientRegistered extends EmployeeState {
  final String message;

  const PatientRegistered(this.message);

  @override
  List<Object?> get props => [message];
}

class PatientUpdated extends EmployeeState {
  final String message;

  const PatientUpdated(this.message);

  @override
  List<Object?> get props => [message];
}

class PatientsSearched extends EmployeeState {
  final List<PatientModel> patients;

  const PatientsSearched(this.patients);

  @override
  List<Object?> get props => [patients];
}

// Appointment States
class AppointmentsLoaded extends EmployeeState {
  final List<AppointmentModel> appointments;

  const AppointmentsLoaded(this.appointments);

  @override
  List<Object?> get props => [appointments];
}

class AppointmentDetailsLoaded extends EmployeeState {
  final AppointmentModel appointment;

  const AppointmentDetailsLoaded(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

class AppointmentBooked extends EmployeeState {
  final String message;

  const AppointmentBooked(this.message);

  @override
  List<Object?> get props => [message];
}

class AppointmentCancelled extends EmployeeState {
  final String message;

  const AppointmentCancelled(this.message);

  @override
  List<Object?> get props => [message];
}

class AppointmentRescheduled extends EmployeeState {
  final String message;

  const AppointmentRescheduled(this.message);

  @override
  List<Object?> get props => [message];
}

class PatientCheckedIn extends EmployeeState {
  final String message;

  const PatientCheckedIn(this.message);

  @override
  List<Object?> get props => [message];
}

class PatientCheckedOut extends EmployeeState {
  final String message;

  const PatientCheckedOut(this.message);

  @override
  List<Object?> get props => [message];
}

// Vital Signs States
class VitalSignsRecorded extends EmployeeState {
  final String message;

  const VitalSignsRecorded(this.message);

  @override
  List<Object?> get props => [message];
}

class PatientVitalSignsLoaded extends EmployeeState {
  final Map<String, dynamic> vitalSigns;

  const PatientVitalSignsLoaded(this.vitalSigns);

  @override
  List<Object?> get props => [vitalSigns];
}

// Lab Results States
class LabResultUploaded extends EmployeeState {
  final String message;

  const LabResultUploaded(this.message);

  @override
  List<Object?> get props => [message];
}

class LabResultsLoaded extends EmployeeState {
  final List<Map<String, dynamic>> results;

  const LabResultsLoaded(this.results);

  @override
  List<Object?> get props => [results];
}

class LabResultUpdated extends EmployeeState {
  final String message;

  const LabResultUpdated(this.message);

  @override
  List<Object?> get props => [message];
}

// Inventory States
class InventoryLoaded extends EmployeeState {
  final List<InventoryModel> inventory;

  const InventoryLoaded(this.inventory);

  @override
  List<Object?> get props => [inventory];
}

class InventoryItemLoaded extends EmployeeState {
  final InventoryModel item;

  const InventoryItemLoaded(this.item);

  @override
  List<Object?> get props => [item];
}

class InventoryItemAdded extends EmployeeState {
  final String message;

  const InventoryItemAdded(this.message);

  @override
  List<Object?> get props => [message];
}

class InventoryItemUpdated extends EmployeeState {
  final String message;

  const InventoryItemUpdated(this.message);

  @override
  List<Object?> get props => [message];
}

class InventoryItemDeleted extends EmployeeState {
  final String message;

  const InventoryItemDeleted(this.message);

  @override
  List<Object?> get props => [message];
}

class InventoryTransactionRecorded extends EmployeeState {
  final String message;

  const InventoryTransactionRecorded(this.message);

  @override
  List<Object?> get props => [message];
}

// Invoice States
class InvoicesLoaded extends EmployeeState {
  final List<InvoiceModel> invoices;

  const InvoicesLoaded(this.invoices);

  @override
  List<Object?> get props => [invoices];
}

class InvoiceDetailsLoaded extends EmployeeState {
  final InvoiceModel invoice;

  const InvoiceDetailsLoaded(this.invoice);

  @override
  List<Object?> get props => [invoice];
}

class InvoiceCreated extends EmployeeState {
  final String message;

  const InvoiceCreated(this.message);

  @override
  List<Object?> get props => [message];
}

class InvoiceUpdated extends EmployeeState {
  final String message;

  const InvoiceUpdated(this.message);

  @override
  List<Object?> get props => [message];
}

class PaymentProcessed extends EmployeeState {
  final String message;

  const PaymentProcessed(this.message);

  @override
  List<Object?> get props => [message];
}

// Statistics States
class DashboardStatsLoaded extends EmployeeState {
  final Map<String, dynamic> stats;

  const DashboardStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

// Error State
class EmployeeError extends EmployeeState {
  final String message;

  const EmployeeError(this.message);

  @override
  List<Object?> get props => [message];
}