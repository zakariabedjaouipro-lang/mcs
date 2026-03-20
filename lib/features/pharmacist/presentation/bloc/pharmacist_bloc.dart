/// Pharmacist BLoC
library;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class PharmacistEvent extends Equatable {
  const PharmacistEvent();
  @override
  List<Object?> get props => [];
}

class LoadPharmacistDataEvent extends PharmacistEvent {
  const LoadPharmacistDataEvent({required this.pharmacistId});
  final String pharmacistId;
  @override
  List<Object?> get props => [pharmacistId];
}

abstract class PharmacistState extends Equatable {
  const PharmacistState();
  @override
  List<Object?> get props => [];
}

class PharmacistInitial extends PharmacistState {
  const PharmacistInitial();
}

class PharmacistLoading extends PharmacistState {
  const PharmacistLoading();
}

class PharmacistDataLoaded extends PharmacistState {
  const PharmacistDataLoaded({
    required this.pendingPrescriptions,
    required this.lowStockMedicines,
    required this.totalInventory,
  });
  final int pendingPrescriptions;
  final int lowStockMedicines;
  final int totalInventory;

  @override
  List<Object?> get props =>
      [pendingPrescriptions, lowStockMedicines, totalInventory];
}

class PharmacistError extends PharmacistState {
  const PharmacistError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class PharmacistBloc extends Bloc<PharmacistEvent, PharmacistState> {
  PharmacistBloc() : super(const PharmacistInitial()) {
    on<LoadPharmacistDataEvent>(_onLoadData);
  }

  Future<void> _onLoadData(
    LoadPharmacistDataEvent event,
    Emitter<PharmacistState> emit,
  ) async {
    emit(const PharmacistLoading());
    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      emit(
        const PharmacistDataLoaded(
          pendingPrescriptions: 15,
          lowStockMedicines: 4,
          totalInventory: 542,
        ),
      );
    } catch (e) {
      emit(PharmacistError('فشل تحميل البيانات: $e'));
    }
  }
}
