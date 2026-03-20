/// Radiographer BLoC
library;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class RadioGrapherEvent extends Equatable {
  const RadioGrapherEvent();
  @override
  List<Object?> get props => [];
}

class LoadRadiographerDataEvent extends RadioGrapherEvent {
  const LoadRadiographerDataEvent({required this.radiographerId});
  final String radiographerId;
  @override
  List<Object?> get props => [radiographerId];
}

abstract class RadioGrapherState extends Equatable {
  const RadioGrapherState();
  @override
  List<Object?> get props => [];
}

class RadioGrapherInitial extends RadioGrapherState {
  const RadioGrapherInitial();
}

class RadioGrapherLoading extends RadioGrapherState {
  const RadioGrapherLoading();
}

class RadioGrapherDataLoaded extends RadioGrapherState {
  const RadioGrapherDataLoaded({
    required this.pendingRequests,
    required this.completedScans,
    required this.reportsReady,
  });
  final int pendingRequests;
  final int completedScans;
  final int reportsReady;

  @override
  List<Object?> get props => [pendingRequests, completedScans, reportsReady];
}

class RadioGrapherError extends RadioGrapherState {
  const RadioGrapherError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class RadioGrapherBloc extends Bloc<RadioGrapherEvent, RadioGrapherState> {
  RadioGrapherBloc() : super(const RadioGrapherInitial()) {
    on<LoadRadiographerDataEvent>(_onLoadData);
  }

  Future<void> _onLoadData(
    LoadRadiographerDataEvent event,
    Emitter<RadioGrapherState> emit,
  ) async {
    emit(const RadioGrapherLoading());
    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      emit(
        const RadioGrapherDataLoaded(
          pendingRequests: 9,
          completedScans: 11,
          reportsReady: 5,
        ),
      );
    } catch (e) {
      emit(RadioGrapherError('فشل تحميل البيانات: $e'));
    }
  }
}
