/// Employee BLoC
library;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/errors/failures.dart';
import 'package:mcs/features/employee/domain/repositories/employee_repository.dart';
import 'package:mcs/features/employee/presentation/bloc/employee_event.dart';
import 'package:mcs/features/employee/presentation/bloc/employee_state.dart';

/// Employee BLoC
class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  EmployeeBloc(this._employeeRepository) : super(const EmployeeInitial()) {
    on<LoadEmployeeProfile>(_onLoadEmployeeProfile);
    on<UpdateEmployeeProfile>(_onUpdateEmployeeProfile);
    on<LoadPatients>(_onLoadPatients);
    on<LoadPatientDetails>(_onLoadPatientDetails);
    on<RegisterPatient>(_onRegisterPatient);
    on<UpdatePatient>(_onUpdatePatient);
    on<SearchPatients>(_onSearchPatients);
    on<LoadAppointments>(_onLoadAppointments);
    on<LoadAppointmentDetails>(_onLoadAppointmentDetails);
    on<BookAppointment>(_onBookAppointment);
    on<CancelAppointment>(_onCancelAppointment);
    on<RescheduleAppointment>(_onRescheduleAppointment);
    on<CheckInPatient>(_onCheckInPatient);
    on<CheckOutPatient>(_onCheckOutPatient);
    on<RecordVitalSigns>(_onRecordVitalSigns);
    on<LoadPatientVitalSigns>(_onLoadPatientVitalSigns);
    on<UploadLabResult>(_onUploadLabResult);
    on<LoadLabResults>(_onLoadLabResults);
    on<UpdateLabResult>(_onUpdateLabResult);
    on<LoadInventory>(_onLoadInventory);
    on<LoadInventoryItem>(_onLoadInventoryItem);
    on<AddInventoryItem>(_onAddInventoryItem);
    on<UpdateInventoryItem>(_onUpdateInventoryItem);
    on<DeleteInventoryItem>(_onDeleteInventoryItem);
    on<RecordInventoryTransaction>(_onRecordInventoryTransaction);
    on<LoadInvoices>(_onLoadInvoices);
    on<LoadInvoiceDetails>(_onLoadInvoiceDetails);
    on<CreateInvoice>(_onCreateInvoice);
    on<UpdateInvoice>(_onUpdateInvoice);
    on<ProcessPayment>(_onProcessPayment);
    on<LoadDashboardStats>(_onLoadDashboardStats);
  }
  final EmployeeRepository _employeeRepository;

  Future<void> _onLoadEmployeeProfile(
    LoadEmployeeProfile event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(const EmployeeLoading());
    final result = await _employeeRepository.getEmployeeProfile();
    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (profile) => emit(EmployeeProfileLoaded(profile)),
    );
  }

  Future<void> _onUpdateEmployeeProfile(
    UpdateEmployeeProfile event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(const EmployeeLoading());
    final result =
        await _employeeRepository.updateEmployeeProfile(event.profile);
    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (_) => emit(const EmployeeProfileUpdated('تم تحديث الملف الشخصي بنجاح')),
    );
  }

  Future<void> _onLoadPatients(
    LoadPatients event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(const EmployeeLoading());
    final result = await _employeeRepository.getPatients();
    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (patients) => emit(PatientsLoaded(patients)),
    );
  }

  Future<void> _onLoadPatientDetails(
    LoadPatientDetails event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(const EmployeeLoading());
    final result = await _employeeRepository.getPatientDetails(event.patientId);
    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (patient) => emit(PatientDetailsLoaded(patient)),
    );
  }

  Future<void> _onRegisterPatient(
    RegisterPatient event,
    Emitter<EmployeeState> emit,
  ) async {
    final result = await _employeeRepository.registerPatient(event.patientData);
    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (_) => emit(const PatientRegistered('تم تسجيل المريض بنجاح')),
    );
  }

  Future<void> _onUpdatePatient(
    UpdatePatient event,
    Emitter<EmployeeState> emit,
  ) async {
    final result = await _employeeRepository.updatePatient(
      event.patientId,
      event.patientData,
    );
    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (_) => emit(const PatientUpdated('تم تحديث بيانات المريض بنجاح')),
    );
  }

  Future<void> _onSearchPatients(
    SearchPatients event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(const EmployeeLoading());
    final result = await _employeeRepository.searchPatients(event.query);
    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (patients) => emit(PatientsSearched(patients)),
    );
  }

  Future<void> _onLoadAppointments(
    LoadAppointments event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(const EmployeeLoading());
    final result = await _employeeRepository.getAppointments(
      startDate: event.startDate,
      endDate: event.endDate,
      status: event.status,
    );
    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (appointments) => emit(AppointmentsLoaded(appointments)),
    );
  }

  Future<void> _onLoadAppointmentDetails(
    LoadAppointmentDetails event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(const EmployeeLoading());
    final result =
        await _employeeRepository.getAppointmentDetails(event.appointmentId);
    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (appointment) => emit(AppointmentDetailsLoaded(appointment)),
    );
  }

  Future<void> _onBookAppointment(
    BookAppointment event,
    Emitter<EmployeeState> emit,
  ) async {
    final result =
        await _employeeRepository.bookAppointment(event.appointmentData);
    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (_) => emit(const AppointmentBooked('تم حجز الموعد بنجاح')),
    );
  }

  Future<void> _onCancelAppointment(
    CancelAppointment event,
    Emitter<EmployeeState> emit,
  ) async {
    final result = await _employeeRepository.cancelAppointment(
      event.appointmentId,
      event.reason,
    );
    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (_) => emit(const AppointmentCancelled('تم إلغاء الموعد بنجاح')),
    );
  }

  Future<void> _onRescheduleAppointment(
    RescheduleAppointment event,
    Emitter<EmployeeState> emit,
  ) async {
    final result = await _employeeRepository.rescheduleAppointment(
      event.appointmentId,
      event.newDateTime,
    );
    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (_) => emit(const AppointmentRescheduled('تم إعادة جدولة الموعد بنجاح')),
    );
  }

  Future<void> _onCheckInPatient(
    CheckInPatient event,
    Emitter<EmployeeState> emit,
  ) async {
    final result =
        await _employeeRepository.checkInPatient(event.appointmentId);
    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (_) => emit(const PatientCheckedIn('تم تسجيل دخول المريض بنجاح')),
    );
  }

  Future<void> _onCheckOutPatient(
    CheckOutPatient event,
    Emitter<EmployeeState> emit,
  ) async {
    final result =
        await _employeeRepository.checkOutPatient(event.appointmentId);
    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (_) => emit(const PatientCheckedOut('تم تسجيل خروج المريض بنجاح')),
    );
  }

  Future<void> _onRecordVitalSigns(
    RecordVitalSigns event,
    Emitter<EmployeeState> emit,
  ) async {
    final result = await _employeeRepository.recordVitalSigns(
      event.patientId,
      event.vitalSigns,
    );
    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (_) => emit(const VitalSignsRecorded('تم تسجيل العلامات الحيوية بنجاح')),
    );
  }

  Future<void> _onLoadPatientVitalSigns(
    LoadPatientVitalSigns event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(const EmployeeLoading());
    final result =
        await _employeeRepository.getPatientVitalSigns(event.patientId);
    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (vitalSigns) => emit(PatientVitalSignsLoaded(vitalSigns)),
    );
  }

  Future<void> _onUploadLabResult(
    UploadLabResult event,
    Emitter<EmployeeState> emit,
  ) async {
    final result = await _employeeRepository.uploadLabResult(event.labResult);
    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (_) => emit(const LabResultUploaded('تم رفع نتيجة الفحص بنجاح')),
    );
  }

  Future<void> _onLoadLabResults(
    LoadLabResults event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(const EmployeeLoading());
    final result = await _employeeRepository.getLabResults(event.patientId);
    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (results) => emit(LabResultsLoaded(results)),
    );
  }

  Future<void> _onUpdateLabResult(
    UpdateLabResult event,
    Emitter<EmployeeState> emit,
  ) async {
    final result = await _employeeRepository.updateLabResult(
      event.resultId,
      event.resultData,
    );
    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (_) => emit(const LabResultUpdated('تم تحديث نتيجة الفحص بنجاح')),
    );
  }

  Future<void> _onLoadInventory(
    LoadInventory event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(const EmployeeLoading());
    final result = await _employeeRepository.getInventory();
    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (inventory) => emit(InventoryLoaded(inventory)),
    );
  }

  Future<void> _onLoadInventoryItem(
    LoadInventoryItem event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(const EmployeeLoading());
    final result = await _employeeRepository.getInventoryItem(event.itemId);
    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (item) => emit(InventoryItemLoaded(item)),
    );
  }

  Future<void> _onAddInventoryItem(
    AddInventoryItem event,
    Emitter<EmployeeState> emit,
  ) async {
    final result = await _employeeRepository.addInventoryItem(event.itemData);
    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (_) => emit(const InventoryItemAdded('تم إضافة عنصر المخزون بنجاح')),
    );
  }

  Future<void> _onUpdateInventoryItem(
    UpdateInventoryItem event,
    Emitter<EmployeeState> emit,
  ) async {
    final result = await _employeeRepository.updateInventoryItem(
      event.itemId,
      event.itemData,
    );
    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (_) => emit(const InventoryItemUpdated('تم تحديث عنصر المخزون بنجاح')),
    );
  }

  Future<void> _onDeleteInventoryItem(
    DeleteInventoryItem event,
    Emitter<EmployeeState> emit,
  ) async {
    final result = await _employeeRepository.deleteInventoryItem(event.itemId);
    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (_) => emit(const InventoryItemDeleted('تم حذف عنصر المخزون بنجاح')),
    );
  }

  Future<void> _onRecordInventoryTransaction(
    RecordInventoryTransaction event,
    Emitter<EmployeeState> emit,
  ) async {
    final result = await _employeeRepository
        .recordInventoryTransaction(event.transactionData);
    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (_) => emit(
        const InventoryTransactionRecorded('تم تسجيل حركة المخزون بنجاح'),
      ),
    );
  }

  Future<void> _onLoadInvoices(
    LoadInvoices event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(const EmployeeLoading());
    final result = await _employeeRepository.getInvoices(
      startDate: event.startDate,
      endDate: event.endDate,
      status: event.status,
    );
    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (invoices) => emit(InvoicesLoaded(invoices)),
    );
  }

  Future<void> _onLoadInvoiceDetails(
    LoadInvoiceDetails event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(const EmployeeLoading());
    final result = await _employeeRepository.getInvoiceDetails(event.invoiceId);
    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (invoice) => emit(InvoiceDetailsLoaded(invoice)),
    );
  }

  Future<void> _onCreateInvoice(
    CreateInvoice event,
    Emitter<EmployeeState> emit,
  ) async {
    final result = await _employeeRepository.createInvoice(event.invoiceData);
    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (_) => emit(const InvoiceCreated('تم إنشاء الفاتورة بنجاح')),
    );
  }

  Future<void> _onUpdateInvoice(
    UpdateInvoice event,
    Emitter<EmployeeState> emit,
  ) async {
    final result = await _employeeRepository.updateInvoice(
      event.invoiceId,
      event.invoiceData,
    );
    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (_) => emit(const InvoiceUpdated('تم تحديث الفاتورة بنجاح')),
    );
  }

  Future<void> _onProcessPayment(
    ProcessPayment event,
    Emitter<EmployeeState> emit,
  ) async {
    final result = await _employeeRepository.processPayment(
      event.invoiceId,
      event.paymentData,
    );
    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (_) => emit(const PaymentProcessed('تم معالجة الدفع بنجاح')),
    );
  }

  Future<void> _onLoadDashboardStats(
    LoadDashboardStats event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(const EmployeeLoading());
    final result = await _employeeRepository.getDashboardStats();
    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (stats) => emit(DashboardStatsLoaded(stats)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).message;
      case NetworkFailure:
        return 'فشل الاتصال بالشبكة';
      case CacheFailure:
        return 'فشل الوصول إلى البيانات المحلية';
      default:
        return 'حدث خطأ غير متوقع';
    }
  }
}

