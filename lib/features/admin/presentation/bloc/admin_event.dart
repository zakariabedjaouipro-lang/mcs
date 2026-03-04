import 'package:equatable/equatable.dart';
import 'package:mcs/core/enums/subscription_type.dart';

/// Base event for admin operations
abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object?> get props => [];
}

// ── Subscription Events ──────────────────────────────────────

/// Generate new subscription code
class GenerateSubscriptionCode extends AdminEvent {
  const GenerateSubscriptionCode({
    required this.type,
    required this.priceUsd,
    required this.priceEur,
    required this.priceDzd,
  });
  final SubscriptionType type;
  final double priceUsd;
  final double priceEur;
  final double priceDzd;

  @override
  List<Object?> get props => [type, priceUsd, priceEur, priceDzd];
}

/// Load all subscription codes
class LoadSubscriptionCodes extends AdminEvent {
  const LoadSubscriptionCodes();
}

/// Activate subscription code for clinic
class ActivateSubscriptionCode extends AdminEvent {
  const ActivateSubscriptionCode({
    required this.code,
    required this.clinicId,
  });
  final String code;
  final String clinicId;

  @override
  List<Object?> get props => [code, clinicId];
}

// ── Clinic Events ────────────────────────────────────────────

/// Load all clinics
class LoadClinics extends AdminEvent {
  const LoadClinics();
}

/// Create new clinic
class CreateClinic extends AdminEvent {
  const CreateClinic({
    required this.name,
    required this.email,
    required this.phone,
    required this.country,
    required this.region,
    this.address,
    this.description,
  });
  final String name;
  final String email;
  final String phone;
  final String country;
  final String region;
  final String? address;
  final String? description;

  @override
  List<Object?> get props =>
      [name, email, phone, country, region, address, description];
}

/// Update clinic
class UpdateClinic extends AdminEvent {
  const UpdateClinic({
    required this.clinicId,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.description,
    this.logoUrl,
    this.isActive,
  });
  final String clinicId;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final String? description;
  final String? logoUrl;
  final bool? isActive;

  @override
  List<Object?> get props =>
      [clinicId, name, email, phone, address, description, logoUrl, isActive];
}

/// Deactivate clinic
class DeactivateClinic extends AdminEvent {
  const DeactivateClinic({required this.clinicId});
  final String clinicId;

  @override
  List<Object?> get props => [clinicId];
}

// ── Currency Events ─────────────────────────────────────────

/// Load exchange rates
class LoadExchangeRates extends AdminEvent {
  const LoadExchangeRates();
}

/// Update exchange rate
class UpdateExchangeRate extends AdminEvent {
  const UpdateExchangeRate({
    required this.fromCurrency,
    required this.toCurrency,
    required this.rate,
  });
  final String fromCurrency;
  final String toCurrency;
  final double rate;

  @override
  List<Object?> get props => [fromCurrency, toCurrency, rate];
}

// ── Stats Events ─────────────────────────────────────────────

/// Load dashboard statistics
class LoadDashboardStats extends AdminEvent {
  const LoadDashboardStats();
}
