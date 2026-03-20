/// Relative BLoC
library;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class RelativeEvent extends Equatable {
  const RelativeEvent();
  @override
  List<Object?> get props => [];
}

class LoadRelativeDataEvent extends RelativeEvent {
  const LoadRelativeDataEvent({required this.relativeId});
  final String relativeId;
  @override
  List<Object?> get props => [relativeId];
}

abstract class RelativeState extends Equatable {
  const RelativeState();
  @override
  List<Object?> get props => [];
}

class RelativeInitial extends RelativeState {
  const RelativeInitial();
}

class RelativeLoading extends RelativeState {
  const RelativeLoading();
}

class RelativeDataLoaded extends RelativeState {
  const RelativeDataLoaded({
    required this.patientsCount,
    required this.upcomingAppointments,
    required this.medicalRecords,
  });
  final int patientsCount;
  final int upcomingAppointments;
  final int medicalRecords;

  @override
  List<Object?> get props =>
      [patientsCount, upcomingAppointments, medicalRecords];
}

class RelativeError extends RelativeState {
  const RelativeError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class RelativeBloc extends Bloc<RelativeEvent, RelativeState> {
  RelativeBloc() : super(const RelativeInitial()) {
    on<LoadRelativeDataEvent>(_onLoadData);
  }

  Future<void> _onLoadData(
    LoadRelativeDataEvent event,
    Emitter<RelativeState> emit,
  ) async {
    emit(const RelativeLoading());
    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      emit(
        const RelativeDataLoaded(
          patientsCount: 3,
          upcomingAppointments: 2,
          medicalRecords: 8,
        ),
      );
    } catch (e) {
      emit(RelativeError('فشل تحميل البيانات: $e'));
    }
  }
}
