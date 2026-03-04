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
    this.address,
    this.logoUrl,
    this.description,
    this.isActive = true,
    this.isTrial = true,
    this.subscriptionType = SubscriptionType.trial,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
    this.agoraAppId,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String country;
  final String region;
  final String? address;
  final String? logoUrl;
  final String? description;
  final bool isActive;
  final bool isTrial;
  final SubscriptionType subscriptionType;
  final DateTime? subscriptionStartDate;
  final DateTime? subscriptionEndDate;
  final String? agoraAppId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Check if subscription is expired
  bool get isSubscriptionExpired {
    if (subscriptionEndDate == null) return true;
    return DateTime.now().isAfter(subscriptionEndDate!);
  }

  /// Get days remaining in subscription
  int get daysRemaining {
    if (subscriptionEndDate == null) return 0;
    return subscriptionEndDate!.difference(DateTime.now()).inDays;
  }

  /// Check if subscription is about to expire (within 7 days)
  bool get isSubscriptionExpiringSoon {
    final days = daysRemaining;
    return days <= 7 && days >= 0;
  }

  /// Check if trial period is active
  bool get isTrialActive => isTrial && !isSubscriptionExpired;

  /// Get end date based on subscription type
  DateTime getEndDate(DateTime startDate) {
    return subscriptionType.getEndDate(startDate);
  }

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      country: json['country'] as String,
      region: json['region'] as String,
      address: json['address'] as String?,
      logoUrl: json['logo_url'] as String?,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      isTrial: json['is_trial'] as bool? ?? true,
      subscriptionType: SubscriptionType.fromDbValue(json['subscription_type'] as String? ?? 'trial'),
      subscriptionStartDate: json['subscription_start_date'] != null
          ? DateTime.parse(json['subscription_start_date'] as String)
          : null,
      subscriptionEndDate: json['subscription_end_date'] != null
          ? DateTime.parse(json['subscription_end_date'] as String)
          : null,
      agoraAppId: json['agora_app_id'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'country': country,
      'region': region,
      'address': address,
      'logo_url': logoUrl,
      'description': description,
      'is_active': isActive,
      'is_trial': isTrial,
      'subscription_type': subscriptionType.toDbValue(),
      'subscription_start_date': subscriptionStartDate?.toIso8601String(),
      'subscription_end_date': subscriptionEndDate?.toIso8601String(),
      'agora_app_id': agoraAppId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  ClinicModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? country,
    String? region,
    String? address,
    String? logoUrl,
    String? description,
    bool? isActive,
    bool? isTrial,
    SubscriptionType? subscriptionType,
    DateTime? subscriptionStartDate,
    DateTime? subscriptionEndDate,
    String? agoraAppId,
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
      address: address ?? this.address,
      logoUrl: logoUrl ?? this.logoUrl,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      isTrial: isTrial ?? this.isTrial,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      subscriptionStartDate: subscriptionStartDate ?? this.subscriptionStartDate,
      subscriptionEndDate: subscriptionEndDate ?? this.subscriptionEndDate,
      agoraAppId: agoraAppId ?? this.agoraAppId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        country,
        region,
        address,
        logoUrl,
        description,
        isActive,
        isTrial,
        subscriptionType,
        subscriptionStartDate,
        subscriptionEndDate,
        agoraAppId,
        createdAt,
        updatedAt,
      ];
}