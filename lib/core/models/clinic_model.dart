/// Clinic model representing a medical clinic in the system.
library;

import 'package:equatable/equatable.dart';
import 'package:mcs/core/enums/subscription_type.dart';

class ClinicModel extends Equatable {
  const ClinicModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.country,
    required this.region,
    this.city,
    this.address,
    this.logoUrl,
    this.description,
    this.isActive = true,
    this.isTrial = true,
    this.subscriptionType = SubscriptionType.trial,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory constructor for creating ClinicModel from JSON
  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      country: json['country'] as String,
      region: json['region'] as String,
      city: json['city'] as String?,
      address: json['address'] as String?,
      logoUrl: json['logo_url'] as String?,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      isTrial: json['is_trial'] as bool? ?? true,
      subscriptionType: SubscriptionType.fromDbValue(
        json['subscription_type'] as String? ?? 'trial',
      ),
      subscriptionStartDate: json['subscription_start_date'] != null
          ? DateTime.parse(json['subscription_start_date'] as String)
          : null,
      subscriptionEndDate: json['subscription_end_date'] != null
          ? DateTime.parse(json['subscription_end_date'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// Basic Information
  final String id;
  final String name;
  final String email;
  final String phone;

  /// Location
  final String country;
  final String region;
  final String? city;
  final String? address;

  /// Media
  final String? logoUrl;
  final String? description;

  /// Status
  final bool isActive;
  final bool isTrial;

  /// Subscription
  final SubscriptionType subscriptionType;
  final DateTime? subscriptionStartDate;
  final DateTime? subscriptionEndDate;

  /// Metadata
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // =========================
  // Computed Getters
  // =========================

  /// Full clinic location
  String get fullLocation {
    if (city != null && city!.isNotEmpty) {
      return '$city, $region, $country';
    }
    return '$region, $country';
  }

  /// Check if subscription expired
  bool get isSubscriptionExpired {
    if (subscriptionEndDate == null) return true;
    return DateTime.now().isAfter(subscriptionEndDate!);
  }

  /// Remaining days in subscription
  int get daysRemaining {
    if (subscriptionEndDate == null) return 0;
    return subscriptionEndDate!.difference(DateTime.now()).inDays;
  }

  /// Subscription expiring within 7 days
  bool get isSubscriptionExpiringSoon {
    final days = daysRemaining;
    return days <= 7 && days >= 0;
  }

  /// Trial still active
  bool get isTrialActive => isTrial && !isSubscriptionExpired;

  /// Get calculated end date
  DateTime getEndDate(DateTime startDate) {
    return subscriptionType.getEndDate(startDate);
  }

  // =========================
  // JSON Serialization
  // =========================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'country': country,
      'region': region,
      'city': city,
      'address': address,
      'logo_url': logoUrl,
      'description': description,
      'is_active': isActive,
      'is_trial': isTrial,
      'subscription_type': subscriptionType.toDbValue(),
      'subscription_start_date': subscriptionStartDate?.toIso8601String(),
      'subscription_end_date': subscriptionEndDate?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // =========================
  // CopyWith
  // =========================

  ClinicModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? country,
    String? region,
    String? city,
    String? address,
    String? logoUrl,
    String? description,
    bool? isActive,
    bool? isTrial,
    SubscriptionType? subscriptionType,
    DateTime? subscriptionStartDate,
    DateTime? subscriptionEndDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClinicModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      region: region ?? this.region,
      city: city ?? this.city,
      address: address ?? this.address,
      logoUrl: logoUrl ?? this.logoUrl,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      isTrial: isTrial ?? this.isTrial,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      subscriptionStartDate:
          subscriptionStartDate ?? this.subscriptionStartDate,
      subscriptionEndDate: subscriptionEndDate ?? this.subscriptionEndDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // =========================
  // Equatable
  // =========================

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        country,
        region,
        city,
        address,
        logoUrl,
        description,
        isActive,
        isTrial,
        subscriptionType,
        subscriptionStartDate,
        subscriptionEndDate,
        createdAt,
        updatedAt,
      ];
}
