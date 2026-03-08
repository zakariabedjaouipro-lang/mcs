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
  const EmployeeProfileLoaded(this.profile);
  final EmployeeModel profile;

  @override
  List<Object?> get props => [profile];
}

class EmployeeProfileUpdated extends EmployeeState {
  const EmployeeProfileUpdated(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

// Patient States
class PatientsLoaded extends EmployeeState {
  const PatientsLoaded(this.patients);
  final List<PatientModel> patients;

  @override
  List<Object?> get props => [patients];
}

class PatientDetailsLoaded extends EmployeeState {
  const PatientDetailsLoaded(this.patient);
  final PatientModel patient;

  @override
  List<Object?> get props => [patient];
}

class PatientRegistered extends EmployeeState {
  const PatientRegistered(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class PatientUpdated extends EmployeeState {
  const PatientUpdated(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class PatientsSearched extends EmployeeState {
  const PatientsSearched(this.patients);
  final List<PatientModel> patients;

  @override
  List<Object?> get props => [patients];
}

// Appointment States
class AppointmentsLoaded extends EmployeeState {
  const AppointmentsLoaded(this.appointments);
  final List<AppointmentModel> appointments;

  @override
  List<Object?> get props => [appointments];
}

class AppointmentDetailsLoaded extends EmployeeState {
  const AppointmentDetailsLoaded(this.appointment);
  final AppointmentModel appointment;

  @override
  List<Object?> get props => [appointment];
}

class AppointmentBooked extends EmployeeState {
  const AppointmentBooked(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class AppointmentCancelled extends EmployeeState {
  const AppointmentCancelled(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class AppointmentRescheduled extends EmployeeState {
  const AppointmentRescheduled(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class PatientCheckedIn extends EmployeeState {
  const PatientCheckedIn(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class PatientCheckedOut extends EmployeeState {
  const PatientCheckedOut(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

// Vital Signs States
class VitalSignsRecorded extends EmployeeState {
  const VitalSignsRecorded(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class PatientVitalSignsLoaded extends EmployeeState {
  const PatientVitalSignsLoaded(this.vitalSigns);
  final Map<String, dynamic> vitalSigns;

  @override
  List<Object?> get props => [vitalSigns];
}

// Lab Results States
class LabResultUploaded extends EmployeeState {
  const LabResultUploaded(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class LabResultsLoaded extends EmployeeState {
  const LabResultsLoaded(this.results);
  final List<Map<String, dynamic>> results;

  @override
  List<Object?> get props => [results];
}

class LabResultUpdated extends EmployeeState {
  const LabResultUpdated(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

// Inventory States
class InventoryLoaded extends EmployeeState {
  const InventoryLoaded(this.inventory);
  final List<InventoryModel> inventory;

  @override
  List<Object?> get props => [inventory];
}

class InventoryItemLoaded extends EmployeeState {
  const InventoryItemLoaded(this.item);
  final InventoryModel item;

  @override
  List<Object?> get props => [item];
}

class InventoryItemAdded extends EmployeeState {
  const InventoryItemAdded(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class InventoryItemUpdated extends EmployeeState {
  const InventoryItemUpdated(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class InventoryItemDeleted extends EmployeeState {
  const InventoryItemDeleted(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class InventoryTransactionRecorded extends EmployeeState {
  const InventoryTransactionRecorded(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

// Invoice States
class InvoicesLoaded extends EmployeeState {
  const InvoicesLoaded(this.invoices);
  final List<InvoiceModel> invoices;

  @override
  List<Object?> get props => [invoices];
}

class InvoiceDetailsLoaded extends EmployeeState {
  const InvoiceDetailsLoaded(this.invoice);
  final InvoiceModel invoice;

  @override
  List<Object?> get props => [invoice];
}

class InvoiceCreated extends EmployeeState {
  const InvoiceCreated(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class InvoiceUpdated extends EmployeeState {
  const InvoiceUpdated(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class PaymentProcessed extends EmployeeState {
  const PaymentProcessed(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

// Statistics States
class DashboardStatsLoaded extends EmployeeState {
  const DashboardStatsLoaded(this.stats);
  final Map<String, dynamic> stats;

  @override
  List<Object?> get props => [stats];
}

// Error State
class EmployeeError extends EmployeeState {
  const EmployeeError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

