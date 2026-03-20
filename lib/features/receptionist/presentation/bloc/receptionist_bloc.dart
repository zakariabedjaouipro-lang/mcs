/// Receptionist BLoC
library;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ReceptionistEvent extends Equatable {
  const ReceptionistEvent();
  @override
  List<Object?> get props => [];
}

class LoadReceptionistDataEvent extends ReceptionistEvent {
  const LoadReceptionistDataEvent({required this.receptionistId});
  final String receptionistId;
  @override
  List<Object?> get props => [receptionistId];
}

abstract class ReceptionistState extends Equatable {
  const ReceptionistState();
  @override
  List<Object?> get props => [];
}

class ReceptionistInitial extends ReceptionistState {
  const ReceptionistInitial();
}

class ReceptionistLoading extends ReceptionistState {
  const ReceptionistLoading();
}

class ReceptionistDataLoaded extends ReceptionistState {
  const ReceptionistDataLoaded({
    required this.todayAppointments,
    required this.newPatients,
    required this.pendingSchedules,
  });
  final int todayAppointments;
  final int newPatients;
  final int pendingSchedules;

  @override
  List<Object?> get props => [todayAppointments, newPatients, pendingSchedules];
}

class ReceptionistError extends ReceptionistState {
  const ReceptionistError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class ReceptionistBloc extends Bloc<ReceptionistEvent, ReceptionistState> {
  ReceptionistBloc() : super(const ReceptionistInitial()) {
    on<LoadReceptionistDataEvent>(_onLoadData);
  }

  Future<void> _onLoadData(
    LoadReceptionistDataEvent event,
    Emitter<ReceptionistState> emit,
  ) async {
    emit(const ReceptionistLoading());
    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      emit(
        const ReceptionistDataLoaded(
          todayAppointments: 24,
          newPatients: 3,
          pendingSchedules: 7,
        ),
      );
    } catch (e) {
      emit(ReceptionistError('فشل تحميل البيانات: $e'));
    }
  }
}
