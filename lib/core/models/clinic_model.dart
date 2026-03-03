/// Clinic data model mapped to the `clinics` Supabase table.
library;

import 'package:equatable/equatable.dart';

class ClinicModel extends Equatable {
  const ClinicModel({
    required this.id,
    required this.name,
    this.country,
    this.region,
    this.address,
    this.phone,
    this.email,
    this.logoUrl,
    this.managerId,
    this.subscriptionId,
    this.isActive = true,
    this.createdAt,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      id: json['id'] as String,
      name: json['name'] as String,
      country: json['country'] as String?,
      region: json['region'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      logoUrl: json['logo_url'] as String?,
      managerId: json['manager_id'] as String?,
      subscriptionId: json['subscription_id'] as String?,
      isActive: (json['is_active'] as bool?) ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  // ── Fields ─────────────────────────────────────────────
  final String id;
  final String name;
  final String? country;
  final String? region;
  final String? address;
  final String? phone;
  final String? email;
  final String? logoUrl;
  final String? managerId;
  final String? subscriptionId;
  final bool isActive;
  final DateTime? createdAt;

  // ── Serialization ──────────────────────────────────────
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'region': region,
      'address': address,
      'phone': phone,
      'email': email,
      'logo_url': logoUrl,
      'manager_id': managerId,
      'subscription_id': subscriptionId,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  // ── Copy With ──────────────────────────────────────────
  ClinicModel copyWith({
    String? id,
    String? name,
    String? country,
    String? region,
    String? address,
    String? phone,
    String? email,
    String? logoUrl,
    String? managerId,
    String? subscriptionId,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return ClinicModel(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      region: region ?? this.region,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      logoUrl: logoUrl ?? this.logoUrl,
      managerId: managerId ?? this.managerId,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // ── Helpers ────────────────────────────────────────────

  /// Returns the full formatted address.
  String get fullAddress {
    final parts = <String>[
      if (address != null && address!.isNotEmpty) address!,
      if (region != null && region!.isNotEmpty) region!,
      if (country != null && country!.isNotEmpty) country!,
    ];
    return parts.join(', ');
  }

  bool get hasSubscription =>
      subscriptionId != null && subscriptionId!.isNotEmpty;

  // ── Equatable ──────────────────────────────────────────
  @override
  List<Object?> get props => [
        id,
        name,
        country,
        region,
        address,
        phone,
        email,
        logoUrl,
        managerId,
        subscriptionId,
        isActive,
        createdAt,
      ];
}
