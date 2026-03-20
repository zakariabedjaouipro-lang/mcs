/// Clinic Business Logic Component
library;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/features/clinic/domain/repositories/clinic_repository.dart';
import 'clinic_event.dart';
import 'clinic_state.dart';

/// Clinic BLoC for managing clinic operations
class ClinicBloc extends Bloc<ClinicEvent, ClinicState> {
  ClinicBloc(this._clinicRepository) : super(const ClinicInitial()) {
    on<LoadClinicStatsEvent>(_onLoadStats);
    on<LoadClinicDoctorsEvent>(_onLoadDoctors);
    on<LoadClinicPatientsEvent>(_onLoadPatients);
    on<LoadClinicAppointmentsEvent>(_onLoadAppointments);
    on<RefreshClinicDataEvent>(_onRefreshData);
  }

  final ClinicRepository _clinicRepository;

  /// Load clinic statistics
  Future<void> _onLoadStats(
    LoadClinicStatsEvent event,
    Emitter<ClinicState> emit,
  ) async {
    emit(const ClinicLoading());
    final result = await _clinicRepository.getClinicStats(event.clinicId);

    result.fold(
      (failure) => emit(ClinicError(failure.message)),
      (stats) {
        emit(
          ClinicStatsLoaded(
            totalDoctors: (stats['totalDoctors'] as int?) ?? 0,
            totalPatients: (stats['totalPatients'] as int?) ?? 0,
            todayAppointments: (stats['todayAppointments'] as int?) ?? 0,
            activeDoctors: (stats['activeDoctors'] as int?) ?? 0,
          ),
        );
      },
    );
  }

  /// Load clinic doctors
  Future<void> _onLoadDoctors(
    LoadClinicDoctorsEvent event,
    Emitter<ClinicState> emit,
  ) async {
    emit(const ClinicLoading());
    final result = await _clinicRepository.getClinicDoctors(event.clinicId);

    result.fold(
      (failure) => emit(ClinicError(failure.message)),
      (doctors) => emit(ClinicDoctorsLoaded(doctors)),
    );
  }

  /// Load clinic patients
  Future<void> _onLoadPatients(
    LoadClinicPatientsEvent event,
    Emitter<ClinicState> emit,
  ) async {
    emit(const ClinicLoading());
    final result = await _clinicRepository.getClinicPatients(event.clinicId);

    result.fold(
      (failure) => emit(ClinicError(failure.message)),
      (patients) => emit(ClinicPatientsLoaded(patients)),
    );
  }

  /// Load clinic appointments
  Future<void> _onLoadAppointments(
    LoadClinicAppointmentsEvent event,
    Emitter<ClinicState> emit,
  ) async {
    emit(const ClinicLoading());
    final result =
        await _clinicRepository.getClinicAppointments(event.clinicId);

    result.fold(
      (failure) => emit(ClinicError(failure.message)),
      (appointments) => emit(ClinicAppointmentsLoaded(appointments)),
    );
  }

  /// Refresh all clinic data
  Future<void> _onRefreshData(
    RefreshClinicDataEvent event,
    Emitter<ClinicState> emit,
  ) async {
    emit(const ClinicLoading());
    await _onLoadStats(LoadClinicStatsEvent(clinicId: event.clinicId), emit);
  }
}
