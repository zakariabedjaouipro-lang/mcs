/// Nurse BLoC Events & States & BLoC
library;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// EVENTS
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

abstract class NurseEvent extends Equatable {
  const NurseEvent();
  @override
  List<Object?> get props => [];
}

class LoadNurseDataEvent extends NurseEvent {
  const LoadNurseDataEvent({required this.nurseId});
  final String nurseId;
  @override
  List<Object?> get props => [nurseId];
}

class RefreshNurseDataEvent extends NurseEvent {
  const RefreshNurseDataEvent({required this.nurseId});
  final String nurseId;
  @override
  List<Object?> get props => [nurseId];
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// STATES
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

abstract class NurseState extends Equatable {
  const NurseState();
  @override
  List<Object?> get props => [];
}

class NurseInitial extends NurseState {
  const NurseInitial();
}

class NurseLoading extends NurseState {
  const NurseLoading();
}

class NurseDataLoaded extends NurseState {
  const NurseDataLoaded({
    required this.assignedPatients,
    required this.todayTasks,
    required this.pendingAppointments,
  });
  final int assignedPatients;
  final int todayTasks;
  final int pendingAppointments;

  @override
  List<Object?> get props =>
      [assignedPatients, todayTasks, pendingAppointments];
}

class NurseError extends NurseState {
  const NurseError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// BLOC
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class NurseBloc extends Bloc<NurseEvent, NurseState> {
  NurseBloc() : super(const NurseInitial()) {
    on<LoadNurseDataEvent>(_onLoadData);
    on<RefreshNurseDataEvent>(_onRefreshData);
  }

  Future<void> _onLoadData(
    LoadNurseDataEvent event,
    Emitter<NurseState> emit,
  ) async {
    emit(const NurseLoading());
    try {
      // Load nurse data from repository/service
      await Future<void>.delayed(const Duration(milliseconds: 500));
      emit(
        const NurseDataLoaded(
          assignedPatients: 12,
          todayTasks: 8,
          pendingAppointments: 5,
        ),
      );
    } catch (e) {
      emit(NurseError('فشل تحميل البيانات: $e'));
    }
  }

  Future<void> _onRefreshData(
    RefreshNurseDataEvent event,
    Emitter<NurseState> emit,
  ) async {
    emit(const NurseLoading());
    await _onLoadData(LoadNurseDataEvent(nurseId: event.nurseId), emit);
  }
}
