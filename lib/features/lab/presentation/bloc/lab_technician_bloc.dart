/// Lab Technician BLoC
library;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class LabTechnicianEvent extends Equatable {
  const LabTechnicianEvent();
  @override
  List<Object?> get props => [];
}

class LoadLabDataEvent extends LabTechnicianEvent {
  const LoadLabDataEvent({required this.technicianId});
  final String technicianId;
  @override
  List<Object?> get props => [technicianId];
}

abstract class LabTechnicianState extends Equatable {
  const LabTechnicianState();
  @override
  List<Object?> get props => [];
}

class LabTechnicianInitial extends LabTechnicianState {
  const LabTechnicianInitial();
}

class LabTechnicianLoading extends LabTechnicianState {
  const LabTechnicianLoading();
}

class LabTechnicianDataLoaded extends LabTechnicianState {
  const LabTechnicianDataLoaded({
    required this.pendingTests,
    required this.completedToday,
    required this.pendingReports,
  });
  final int pendingTests;
  final int completedToday;
  final int pendingReports;

  @override
  List<Object?> get props => [pendingTests, completedToday, pendingReports];
}

class LabTechnicianError extends LabTechnicianState {
  const LabTechnicianError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class LabTechnicianBloc extends Bloc<LabTechnicianEvent, LabTechnicianState> {
  LabTechnicianBloc() : super(const LabTechnicianInitial()) {
    on<LoadLabDataEvent>(_onLoadData);
  }

  Future<void> _onLoadData(
    LoadLabDataEvent event,
    Emitter<LabTechnicianState> emit,
  ) async {
    emit(const LabTechnicianLoading());
    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      emit(
        const LabTechnicianDataLoaded(
          pendingTests: 18,
          completedToday: 12,
          pendingReports: 6,
        ),
      );
    } catch (e) {
      emit(LabTechnicianError('فشل تحميل البيانات: $e'));
    }
  }
}
