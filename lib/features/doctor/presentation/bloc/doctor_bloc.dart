/// Doctor BLoC
library;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/errors/failures.dart';
import 'package:mcs/features/doctor/domain/repositories/doctor_repository.dart';
import 'package:mcs/features/doctor/presentation/bloc/doctor_event.dart';
import 'package:mcs/features/doctor/presentation/bloc/doctor_state.dart';

/// Doctor BLoC
class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  DoctorBloc(this._doctorRepository) : super(const DoctorInitial()) {
    on<LoadDoctorProfile>(_onLoadDoctorProfile);
    on<UpdateDoctorProfile>(_onUpdateDoctorProfile);
    on<ToggleAvailability>(_onToggleAvailability);
    on<LoadPatients>(_onLoadPatients);
    on<LoadPatientDetails>(_onLoadPatientDetails);
    on<SearchPatients>(_onSearchPatients);
    on<LoadAppointments>(_onLoadAppointments);
    on<LoadAppointmentDetails>(_onLoadAppointmentDetails);
    on<AcceptAppointment>(_onAcceptAppointment);
    on<RejectAppointment>(_onRejectAppointment);
    on<CancelAppointment>(_onCancelAppointment);
    on<CompleteAppointment>(_onCompleteAppointment);
    on<RescheduleAppointment>(_onRescheduleAppointment);
    on<CreatePrescription>(_onCreatePrescription);
    on<LoadPrescriptions>(_onLoadPrescriptions);
    on<UpdatePrescription>(_onUpdatePrescription);
    on<DeletePrescription>(_onDeletePrescription);
    on<StartRemoteSession>(_onStartRemoteSession);
    on<EndRemoteSession>(_onEndRemoteSession);
    on<GenerateSessionToken>(_onGenerateSessionToken);
    on<UploadLabResult>(_onUploadLabResult);
    on<LoadLabResults>(_onLoadLabResults);
    on<LoadDashboardStats>(_onLoadDashboardStats);
    on<LoadRemoteSessionRequests>(_onLoadRemoteSessionRequests);
    on<ApproveRemoteSessionRequest>(_onApproveRemoteSessionRequest);
    on<RejectRemoteSessionRequest>(_onRejectRemoteSessionRequest);
  }
  final DoctorRepository _doctorRepository;

  Future<void> _onLoadDoctorProfile(
    LoadDoctorProfile event,
    Emitter<DoctorState> emit,
  ) async {
    emit(const DoctorLoading());
    final result = await _doctorRepository.getDoctorProfile();
    result.fold(
      (failure) => emit(DoctorError(_mapFailureToMessage(failure))),
      (profile) => emit(DoctorProfileLoaded(profile)),
    );
  }

  Future<void> _onUpdateDoctorProfile(
    UpdateDoctorProfile event,
    Emitter<DoctorState> emit,
  ) async {
    emit(const DoctorLoading());
    final result = await _doctorRepository.updateDoctorProfile(event.profile);
    result.fold(
      (failure) => emit(DoctorError(_mapFailureToMessage(failure))),
      (_) => emit(const DoctorProfileUpdated('تم تحديث الملف الشخصي بنجاح')),
    );
  }

  Future<void> _onToggleAvailability(
    ToggleAvailability event,
    Emitter<DoctorState> emit,
  ) async {
    final result =
        await _doctorRepository.updateAvailability(event.isAvailable);
    result.fold(
      (failure) => emit(DoctorError(_mapFailureToMessage(failure))),
      (_) => emit(AvailabilityToggled(event.isAvailable)),
    );
  }

  Future<void> _onLoadPatients(
    LoadPatients event,
    Emitter<DoctorState> emit,
  ) async {
    emit(const DoctorLoading());
    final result = await _doctorRepository.getPatients();
    result.fold(
      (failure) => emit(DoctorError(_mapFailureToMessage(failure))),
      (patients) => emit(PatientsLoaded(patients)),
    );
  }

  Future<void> _onLoadPatientDetails(
    LoadPatientDetails event,
    Emitter<DoctorState> emit,
  ) async {
    emit(const DoctorLoading());
    final result = await _doctorRepository.getPatientDetails(event.patientId);
    result.fold(
      (failure) => emit(DoctorError(_mapFailureToMessage(failure))),
      (patient) => emit(PatientDetailsLoaded(patient)),
    );
  }

  Future<void> _onSearchPatients(
    SearchPatients event,
    Emitter<DoctorState> emit,
  ) async {
    emit(const DoctorLoading());
    final result = await _doctorRepository.searchPatients(event.query);
    result.fold(
      (failure) => emit(DoctorError(_mapFailureToMessage(failure))),
      (patients) => emit(PatientsSearched(patients)),
    );
  }

  Future<void> _onLoadAppointments(
    LoadAppointments event,
    Emitter<DoctorState> emit,
  ) async {
    emit(const DoctorLoading());
    final result = await _doctorRepository.getAppointments(
      startDate: event.startDate,
      endDate: event.endDate,
      status: event.status,
    );
    result.fold(
      (failure) => emit(DoctorError(_mapFailureToMessage(failure))),
      (appointments) => emit(AppointmentsLoaded(appointments)),
    );
  }

  Future<void> _onLoadAppointmentDetails(
    LoadAppointmentDetails event,
    Emitter<DoctorState> emit,
  ) async {
    emit(const DoctorLoading());
    final result =
        await _doctorRepository.getAppointmentDetails(event.appointmentId);
    result.fold(
      (failure) => emit(DoctorError(_mapFailureToMessage(failure))),
      (appointment) => emit(AppointmentDetailsLoaded(appointment)),
    );
  }

  Future<void> _onAcceptAppointment(
    AcceptAppointment event,
    Emitter<DoctorState> emit,
  ) async {
    final result =
        await _doctorRepository.acceptAppointment(event.appointmentId);
    result.fold(
      (failure) => emit(DoctorError(_mapFailureToMessage(failure))),
      (_) => emit(const AppointmentAccepted('تم قبول الموعد بنجاح')),
    );
  }

  Future<void> _onRejectAppointment(
    RejectAppointment event,
    Emitter<DoctorState> emit,
  ) async {
    final result = await _doctorRepository.rejectAppointment(
      event.appointmentId,
      event.reason,
    );
    result.fold(
      (failure) => emit(DoctorError(_mapFailureToMessage(failure))),
      (_) => emit(const AppointmentRejected('تم رفض الموعد بنجاح')),
    );
  }

  Future<void> _onCancelAppointment(
    CancelAppointment event,
    Emitter<DoctorState> emit,
  ) async {
    final result = await _doctorRepository.cancelAppointment(
      event.appointmentId,
      event.reason,
    );
    result.fold(
      (failure) => emit(DoctorError(_mapFailureToMessage(failure))),
      (_) => emit(const AppointmentCancelled('تم إلغاء الموعد بنجاح')),
    );
  }

  Future<void> _onCompleteAppointment(
    CompleteAppointment event,
    Emitter<DoctorState> emit,
  ) async {
    final result = await _doctorRepository.completeAppointment(
      event.appointmentId,
      event.notes,
    );
    result.fold(
      (failure) => emit(DoctorError(_mapFailureToMessage(failure))),
      (_) => emit(const AppointmentCompleted('تم إكمال الموعد بنجاح')),
    );
  }

  Future<void> _onRescheduleAppointment(
    RescheduleAppointment event,
    Emitter<DoctorState> emit,
  ) async {
    final result = await _doctorRepository.rescheduleAppointment(
      event.appointmentId,
      event.newDateTime,
    );
    result.fold(
      (failure) => emit(DoctorError(_mapFailureToMessage(failure))),
      (_) => emit(const AppointmentRescheduled('تم إعادة جدولة الموعد بنجاح')),
    );
  }

  Future<void> _onCreatePrescription(
    CreatePrescription event,
    Emitter<DoctorState> emit,
  ) async {
    final result =
        await _doctorRepository.createPrescription(event.prescription);
    result.fold(
      (failure) => emit(DoctorError(_mapFailureToMessage(failure))),
      (_) => emit(const PrescriptionCreated('تم إنشاء الوصفة بنجاح')),
    );
  }

  Future<void> _onLoadPrescriptions(
    LoadPrescriptions event,
    Emitter<DoctorState> emit,
  ) async {
    emit(const DoctorLoading());
    final result = await _doctorRepository.getPrescriptions(event.patientId);
    result.fold(
      (failure) => emit(DoctorError(_mapFailureToMessage(failure))),
      (prescriptions) => emit(PrescriptionsLoaded(prescriptions)),
    );
  }

  Future<void> _onUpdatePrescription(
    UpdatePrescription event,
    Emitter<DoctorState> emit,
  ) async {
    final result = await _doctorRepository.updatePrescription(
      event.prescriptionId,
      event.prescription,
    );
    result.fold(
      (failure) => emit(DoctorError(_mapFailureToMessage(failure))),
      (_) => emit(const PrescriptionUpdated('تم تحديث الوصفة بنجاح')),
    );
  }

  Future<void> _onDeletePrescription(
    DeletePrescription event,
    Emitter<DoctorState> emit,
  ) async {
    final result =
        await _doctorRepository.deletePrescription(event.prescriptionId);
    result.fold(
      (failure) => emit(DoctorError(_mapFailureToMessage(failure))),
      (_) => emit(const PrescriptionDeleted('تم حذف الوصفة بنجاح')),
    );
  }

  Future<void> _onStartRemoteSession(
    StartRemoteSession event,
    Emitter<DoctorState> emit,
  ) async {
    final result =
        await _doctorRepository.startRemoteSession(event.appointmentId);
    result.fold(
      (failure) => emit(DoctorError(_mapFailureToMessage(failure))),
      (_) => emit(const RemoteSessionStarted('تم بدء الجلسة عن بعد بنجاح')),
    );
  }

  Future<void> _onEndRemoteSession(
    EndRemoteSession event,
    Emitter<DoctorState> emit,
  ) async {
    final result = await _doctorRepository.endRemoteSession(event.sessionId);
    result.fold(
      (failure) => emit(DoctorError(_mapFailureToMessage(failure))),
      (_) => emit(const RemoteSessionEnded('تم إنهاء الجلسة عن بعد بنجاح')),
    );
  }

  Future<void> _onGenerateSessionToken(
    GenerateSessionToken event,
    Emitter<DoctorState> emit,
  ) async {
    final result =
        await _doctorRepository.generateRemoteSessionToken(event.appointmentId);
    result.fold(
      (failure) => emit(DoctorError(_mapFailureToMessage(failure))),
      (token) => emit(SessionTokenGenerated(token)),
    );
  }

  Future<void> _onUploadLabResult(
    UploadLabResult event,
    Emitter<DoctorState> emit,
  ) async {
    final result = await _doctorRepository.uploadLabResult(event.labResult);
    result.fold(
      (failure) => emit(DoctorError(_mapFailureToMessage(failure))),
      (_) => emit(const LabResultUploaded('تم رفع نتيجة الفحص بنجاح')),
    );
  }

  Future<void> _onLoadLabResults(
    LoadLabResults event,
    Emitter<DoctorState> emit,
  ) async {
    emit(const DoctorLoading());
    final result = await _doctorRepository.getLabResults(event.patientId);
    result.fold(
      (failure) => emit(DoctorError(_mapFailureToMessage(failure))),
      (results) => emit(LabResultsLoaded(results)),
    );
  }

  Future<void> _onLoadDashboardStats(
    LoadDashboardStats event,
    Emitter<DoctorState> emit,
  ) async {
    emit(const DoctorLoading());
    final result = await _doctorRepository.getDashboardStats();
    result.fold(
      (failure) => emit(DoctorError(_mapFailureToMessage(failure))),
      (stats) => emit(DashboardStatsLoaded(stats)),
    );
  }

  Future<void> _onLoadRemoteSessionRequests(
    LoadRemoteSessionRequests event,
    Emitter<DoctorState> emit,
  ) async {
    emit(const DoctorLoading());
    final result = await _doctorRepository.getRemoteSessionRequests();
    result.fold(
      (failure) => emit(DoctorError(_mapFailureToMessage(failure))),
      (requests) => emit(RemoteSessionRequestsLoaded(requests)),
    );
  }

  Future<void> _onApproveRemoteSessionRequest(
    ApproveRemoteSessionRequest event,
    Emitter<DoctorState> emit,
  ) async {
    final result = await _doctorRepository
        .approveRemoteSessionRequest(event.appointmentId);
    result.fold(
      (failure) => emit(DoctorError(_mapFailureToMessage(failure))),
      (_) => emit(
        const RemoteSessionRequestApproved(
          'تم قبول طلب الجلسة عن بعد بنجاح',
        ),
      ),
    );
  }

  Future<void> _onRejectRemoteSessionRequest(
    RejectRemoteSessionRequest event,
    Emitter<DoctorState> emit,
  ) async {
    final result = await _doctorRepository.rejectRemoteSessionRequest(
      event.appointmentId,
      event.reason,
    );
    result.fold(
      (failure) => emit(DoctorError(_mapFailureToMessage(failure))),
      (_) => emit(
        const RemoteSessionRequestRejected('تم رفض طلب الجلسة عن بعد بنجاح'),
      ),
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

