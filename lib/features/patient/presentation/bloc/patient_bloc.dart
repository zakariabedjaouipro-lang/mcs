/// Patient BLoC
library;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/errors/failures.dart';
import 'package:mcs/features/patient/data/repositories/patient_repository_impl.dart';
import 'package:mcs/features/patient/domain/repositories/patient_repository.dart';
import 'package:mcs/features/patient/presentation/bloc/patient_event.dart';
import 'package:mcs/features/patient/presentation/bloc/patient_state.dart';

/// Patient BLoC
class PatientBloc extends Bloc<PatientEvent, PatientState> {
  final PatientRepository _patientRepository;

  PatientBloc(this._patientRepository) : super(PatientInitial()) {
    // ═════════════════════════════════════════════════════════════════════════════
    // Appointments Handlers
    // ═════════════════════════════════════════════════════════════════════════════
    on<LoadAppointments>(_onLoadAppointments);
    on<LoadAppointmentById>(_onLoadAppointmentById);
    on<BookAppointment>(_onBookAppointment);
    on<CancelAppointment>(_onCancelAppointment);
    on<RescheduleAppointment>(_onRescheduleAppointment);

    // ═════════════════════════════════════════════════════════════════════════════
    // Remote Sessions Handlers
    // ═════════════════════════════════════════════════════════════════════════════
    on<LoadRemoteSessions>(_onLoadRemoteSessions);
    on<LoadUpcomingRemoteSessions>(_onLoadUpcomingRemoteSessions);
    on<LoadPastRemoteSessions>(_onLoadPastRemoteSessions);
    on<JoinVideoSession>(_onJoinVideoSession);
    on<LeaveVideoSession>(_onLeaveVideoSession);

    // ═════════════════════════════════════════════════════════════════════════════
    // Prescriptions Handlers
    // ═════════════════════════════════════════════════════════════════════════════
    on<LoadPrescriptions>(_onLoadPrescriptions);
    on<LoadPrescriptionById>(_onLoadPrescriptionById);
    on<LoadActivePrescriptions>(_onLoadActivePrescriptions);

    // ═════════════════════════════════════════════════════════════════════════════
    // Lab Results Handlers
    // ═════════════════════════════════════════════════════════════════════════════
    on<LoadLabResults>(_onLoadLabResults);
    on<LoadLabResultById>(_onLoadLabResultById);
    on<DownloadLabResult>(_onDownloadLabResult);

    // ═════════════════════════════════════════════════════════════════════════════
    // Profile Handlers
    // ═════════════════════════════════════════════════════════════════════════════
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    onChangePassword(_onChangePassword);

    // ═════════════════════════════════════════════════════════════════════════════
    // Social Accounts Handlers
    // ═════════════════════════════════════════════════════════════════════════════
    on<LinkSocialAccount>(_onLinkSocialAccount);
    on<UnlinkSocialAccount>(_onUnlinkSocialAccount);
    on<LoadLinkedSocialAccounts>(_onLoadLinkedSocialAccounts);

    // ═════════════════════════════════════════════════════════════════════════════
    // Generic Handlers
    // ═════════════════════════════════════════════════════════════════════════════
    on<SetLoading>(_onSetLoading);
    on<ClearPatientState>(_onClearPatientState);
  }

  // ═════════════════════════════════════════════════════════════════════════════
  // Appointments Handlers
  // ═════════════════════════════════════════════════════════════════════════════

  Future<void> _onLoadAppointments(
    LoadAppointments event,
    Emitter<PatientState> emit,
  ) async {
    emit(const PatientLoading());
    final result = await _patientRepository.getAppointments();
    result.fold(
      (failure) => emit(PatientError(_mapFailureToMessage(failure))),
      (appointments) => emit(AppointmentsLoaded(appointments)),
    );
  }

  Future<void> _onLoadAppointmentById(
    LoadAppointmentById event,
    Emitter<PatientState> emit,
  ) async {
    emit(const PatientLoading());
    final result =
        await _patientRepository.getAppointmentById(event.appointmentId);
    result.fold(
      (failure) => emit(PatientError(_mapFailureToMessage(failure))),
      (appointment) => emit(AppointmentLoaded(appointment)),
    );
  }

  Future<void> _onBookAppointment(
    BookAppointment event,
    Emitter<PatientState> emit,
  ) async {
    emit(PatientLoading());
    final result = await _patientRepository.bookAppointment(
      clinicId: event.clinicId,
      doctorId: event.doctorId,
      appointmentDate: event.appointmentDate,
      timeSlot: event.timeSlot,
      appointmentType: event.appointmentType,
      notes: event.notes,
    );
    result.fold(
      (failure) => emit(PatientError(_mapFailureToMessage(failure))),
      (appointment) => emit(AppointmentBooked(appointment)),
    );
  }

  Future<void> _onCancelAppointment(
    CancelAppointment event,
    Emitter<PatientState> emit,
  ) async {
    emit(const PatientLoading());
    final result =
        await _patientRepository.cancelAppointment(event.appointmentId);
    result.fold(
      (failure) => emit(PatientError(_mapFailureToMessage(failure))),
      (_) => emit(AppointmentCancelled(event.appointmentId)),
    );
  }

  Future<void> _onRescheduleAppointment(
    RescheduleAppointment event,
    Emitter<PatientState> emit,
  ) async {
    emit(const PatientLoading());
    final result = await _patientRepository.rescheduleAppointment(
      appointmentId: event.appointmentId,
      newDate: event.newDate,
      newTimeSlot: event.newTimeSlot,
    );
    result.fold(
      (failure) => emit(PatientError(_mapFailureToMessage(failure))),
      (appointment) => emit(AppointmentRescheduled(appointment)),
    );
  }

  // ═════════════════════════════════════════════════════════════════════════════
  // Remote Sessions Handlers
  // ═════════════════════════════════════════════════════════════════════════════

  Future<void> _onLoadRemoteSessions(
    LoadRemoteSessions event,
    Emitter<PatientState> emit,
  ) async {
    emit(const PatientLoading());
    final result = await _patientRepository.getRemoteSessions();
    result.fold(
      (failure) => emit(PatientError(_mapFailureToMessage(failure))),
      (sessions) => emit(RemoteSessionsLoaded(sessions)),
    );
  }

  Future<void> _onLoadUpcomingRemoteSessions(
    LoadUpcomingRemoteSessions event,
    Emitter<PatientState> emit,
  ) async {
    emit(const PatientLoading());
    final result = await _patientRepository.getUpcomingRemoteSessions();
    result.fold(
      (failure) => emit(PatientError(_mapFailureToMessage(failure))),
      (sessions) => emit(UpcomingRemoteSessionsLoaded(sessions)),
    );
  }

  Future<void> _onLoadPastRemoteSessions(
    LoadPastRemoteSessions event,
    Emitter<PatientState> emit,
  ) async {
    emit(const PatientLoading());
    final result = await _patientRepository.getPastRemoteSessions();
    result.fold(
      (failure) => emit(PatientError(_mapFailureToMessage(failure))),
      (sessions) => emit(PastRemoteSessionsLoaded(sessions)),
    );
  }

  Future<void> _onJoinVideoSession(
    JoinVideoSession event,
    Emitter<PatientState> emit,
  ) async {
    emit(const PatientLoading());
    final result = await _patientRepository.joinVideoSession(event.sessionId);
    result.fold(
      (failure) => emit(PatientError(_mapFailureToMessage(failure))),
      (channelId) => emit(VideoSessionJoined(channelId)),
    );
  }

  Future<void> _onLeaveVideoSession(
    LeaveVideoSession event,
    Emitter<PatientState> emit,
  ) async {
    emit(PatientLoading());
    final result = await _patientRepository.leaveVideoSession(event.channelId);
    result.fold(
      (failure) => emit(PatientError(_mapFailureToMessage(failure))),
      (_) => emit(VideoSessionLeft(event.channelId)),
    );
  }

  // ═════════════════════════════════════════════════════════════════════════════
  // Prescriptions Handlers
  // ═════════════════════════════════════════════════════════════════════════════

  Future<void> _onLoadPrescriptions(
    LoadPrescriptions event,
    Emitter<PatientState> emit,
  ) async {
    emit(PatientLoading());
    final result = await _patientRepository.getPrescriptions();
    result.fold(
      (failure) => emit(PatientError(_mapFailureToMessage(failure))),
      (prescriptions) => emit(PrescriptionsLoaded(prescriptions)),
    );
  }

  Future<void> _onLoadPrescriptionById(
    LoadPrescriptionById event,
    Emitter<PatientState> emit,
  ) async {
    emit(PatientLoading());
    final result =
        await _patientRepository.getPrescriptionById(event.prescriptionId);
    result.fold(
      (failure) => emit(PatientError(_mapFailureToMessage(failure))),
      (prescription) => emit(PrescriptionLoaded(prescription)),
    );
  }

  Future<void> _onLoadActivePrescriptions(
    LoadActivePrescriptions event,
    Emitter<PatientState> emit,
  ) async {
    emit(PatientLoading());
    final result = await _patientRepository.getActivePrescriptions();
    result.fold(
      (failure) => emit(PatientError(_mapFailureToMessage(failure))),
      (prescriptions) => emit(ActivePrescriptionsLoaded(prescriptions)),
    );
  }

  // ═════════════════════════════════════════════════════════════════════════════
  // Lab Results Handlers
  // ═════════════════════════════════════════════════════════════════════════════

  Future<void> _onLoadLabResults(
    LoadLabResults event,
    Emitter<PatientState> emit,
  ) async {
    emit(PatientLoading());
    final result = await _patientRepository.getLabResults();
    result.fold(
      (failure) => emit(PatientError(_mapFailureToMessage(failure))),
      (results) => emit(LabResultsLoaded(results)),
    );
  }

  Future<void> _onLoadLabResultById(
    LoadLabResultById event,
    Emitter<PatientState> emit,
  ) async {
    emit(PatientLoading());
    final result = await _patientRepository.getLabResultById(event.labResultId);
    result.fold(
      (failure) => emit(PatientError(_mapFailureToMessage(failure))),
      (result) => emit(LabResultLoaded(result)),
    );
  }

  Future<void> _onDownloadLabResult(
    DownloadLabResult event,
    Emitter<PatientState> emit,
  ) async {
    emit(PatientLoading());
    final result =
        await _patientRepository.downloadLabResult(event.labResultId);
    result.fold(
      (failure) => emit(PatientError(_mapFailureToMessage(failure))),
      (downloadUrl) => emit(LabResultDownloaded(downloadUrl)),
    );
  }

  // ═════════════════════════════════════════════════════════════════════════════
  // Profile Handlers
  // ═════════════════════════════════════════════════════════════════════════════

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<PatientState> emit,
  ) async {
    emit(PatientLoading());
    final result = await _patientRepository.getProfile();
    result.fold(
      (failure) => emit(PatientError(_mapFailureToMessage(failure))),
      (user) => emit(ProfileLoaded(user)),
    );
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<PatientState> emit,
  ) async {
    emit(PatientLoading());
    final result = await _patientRepository.updateProfile(
      name: event.name,
      phone: event.phone,
      address: event.address,
      dateOfBirth: event.dateOfBirth,
      bloodType: event.bloodType,
      allergies: event.allergies,
      emergencyContact: event.emergencyContact,
      emergencyPhone: event.emergencyPhone,
    );
    result.fold(
      (failure) => emit(PatientError(_mapFailureToMessage(failure))),
      (user) => emit(ProfileUpdated(user)),
    );
  }

  Future<void> _onChangePassword(
    ChangePassword event,
    Emitter<PatientState> emit,
  ) async {
    emit(PatientLoading());
    final result = await _patientRepository.changePassword(
      currentPassword: event.currentPassword,
      newPassword: event.newPassword,
    );
    result.fold(
      (failure) => emit(PatientError(_mapFailureToMessage(failure))),
      (_) => emit(const PasswordChanged('تم تغيير كلمة المرور بنجاح')),
    );
  }

  // ═════════════════════════════════════════════════════════════════════════════
  // Social Accounts Handlers
  // ═════════════════════════════════════════════════════════════════════════════

  Future<void> _onLinkSocialAccount(
    LinkSocialAccount event,
    Emitter<PatientState> emit,
  ) async {
    emit(PatientLoading());
    final result = await _patientRepository.linkSocialAccount(
      provider: event.provider,
      providerId: event.providerId,
      accessToken: event.accessToken,
    );
    result.fold(
      (failure) => emit(PatientError(_mapFailureToMessage(failure))),
      (user) => emit(SocialAccountLinked(user)),
    );
  }

  Future<void> _onUnlinkSocialAccount(
    UnlinkSocialAccount event,
    Emitter<PatientState> emit,
  ) async {
    emit(PatientLoading());
    final result = await _patientRepository.unlinkSocialAccount(event.provider);
    result.fold(
      (failure) => emit(PatientError(_mapFailureToMessage(failure))),
      (user) => emit(SocialAccountUnlinked(user)),
    );
  }

  Future<void> _onLoadLinkedSocialAccounts(
    LoadLinkedSocialAccounts event,
    Emitter<PatientState> emit,
  ) async {
    emit(PatientLoading());
    final result = await _patientRepository.getLinkedSocialAccounts();
    result.fold(
      (failure) => emit(PatientError(_mapFailureToMessage(failure))),
      (accounts) => emit(LinkedSocialAccountsLoaded(accounts)),
    );
  }

  // ═════════════════════════════════════════════════════════════════════════════
  // Generic Handlers
  // ═════════════════════════════════════════════════════════════════════════════

  Future<void> _onSetLoading(
    SetLoading event,
    Emitter<PatientState> emit,
  ) async {
    if (event.isLoading) {
      emit(PatientLoading());
    }
  }

  Future<void> _onClearPatientState(
    ClearPatientState event,
    Emitter<PatientState> emit,
  ) async {
    emit(PatientInitial());
  }

  // ═════════════════════════════════════════════════════════════════════════════
  // Helper Methods
  // ═════════════════════════════════════════════════════════════════════════════

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'حدث خطأ في الخادم. يرجى المحاولة مرة أخرى.';
      case NetworkFailure:
        return 'لا يوجد اتصال بالإنترنت. يرجى التحقق من اتصالك.';
      case AuthFailure:
        return 'غير مصرح لك بالوصول. يرجى تسجيل الدخول مرة أخرى.';
      case NotFoundFailure:
        return 'لم يتم العثور على البيانات المطلوبة.';
      case ValidationFailure:
        return (failure as ValidationFailure).message;
      default:
        return 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';
    }
  }
}
