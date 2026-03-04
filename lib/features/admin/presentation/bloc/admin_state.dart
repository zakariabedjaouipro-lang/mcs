import 'package:equatable/equatable.dart';
import 'package:mcs/core/models/clinic_model.dart';
import 'package:mcs/core/models/subscription_model.dart';

/// Base state for admin operations
abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AdminInitial extends AdminState {
  const AdminInitial();
}

/// Loading state
class AdminLoading extends AdminState {
  const AdminLoading();
}

/// Subscription codes loaded
class SubscriptionCodesLoaded extends AdminState {
  final List<SubscriptionModel> subscriptions;

  const SubscriptionCodesLoaded(this.subscriptions);

  @override
  List<Object?> get props => [subscriptions];
}

/// Clinics loaded
class ClinicsLoaded extends AdminState {
  final List<ClinicModel> clinics;

  const ClinicsLoaded(this.clinics);

  @override
  List<Object?> get props => [clinics];
}

/// Dashboard stats loaded
class DashboardStatsLoaded extends AdminState {
  final int totalClinics;
  final int activeSubscriptions;
  final int trialSubscriptions;
  final int expiredSubscriptions;
  final double totalRevenueUsd;
  final int totalUsers;

  const DashboardStatsLoaded({
    required this.totalClinics,
    required this.activeSubscriptions,
    required this.trialSubscriptions,
    required this.expiredSubscriptions,
    required this.totalRevenueUsd,
    required this.totalUsers,
  });

  @override
  List<Object?> get props => [
        totalClinics,
        activeSubscriptions,
        trialSubscriptions,
        expiredSubscriptions,
        totalRevenueUsd,
        totalUsers,
      ];
}

/// Exchange rates loaded
class ExchangeRatesLoaded extends AdminState {
  final Map<String, double> rates;

  const ExchangeRatesLoaded(this.rates);

  @override
  List<Object?> get props => [rates];
}

/// Error state
class AdminError extends AdminState {
  final String message;

  const AdminError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Success state (generic)
class AdminSuccess extends AdminState {
  final String message;

  const AdminSuccess(this.message);

  @override
  List<Object?> get props => [message];
}