/// Inventory model for clinic stock management.
library;

import 'package:equatable/equatable.dart';

class InventoryModel extends Equatable {
  const InventoryModel({
    required this.id,
    required this.clinicId,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.minQuantity,
    required this.price,
    required this.currency,
    required this.updatedAt,
    this.supplier,
    this.expiryDate,
  });

  /// Create from JSON.
  factory InventoryModel.fromJson(Map<String, dynamic> json) => InventoryModel(
        id: json['id'] as String,
        clinicId: json['clinicId'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        quantity: json['quantity'] as int,
        unit: json['unit'] as String,
        minQuantity: json['minQuantity'] as int,
        price: (json['price'] as num).toDouble(),
        currency: json['currency'] as String,
        supplier: json['supplier'] as String?,
        expiryDate: json['expiryDate'] != null
            ? DateTime.parse(json['expiryDate'] as String)
            : null,
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
  final String id;
  final String clinicId;
  final String name;
  final String category;
  final int quantity;
  final String unit;
  final int minQuantity;
  final double price;
  final String currency;
  final String? supplier;
  final DateTime? expiryDate;
  final DateTime updatedAt;

  /// Create a copy with optional field overrides.
  InventoryModel copyWith({
    String? id,
    String? clinicId,
    String? name,
    String? category,
    int? quantity,
    String? unit,
    int? minQuantity,
    double? price,
    String? currency,
    String? supplier,
    DateTime? expiryDate,
    DateTime? updatedAt,
  }) =>
      InventoryModel(
        id: id ?? this.id,
        clinicId: clinicId ?? this.clinicId,
        name: name ?? this.name,
        category: category ?? this.category,
        quantity: quantity ?? this.quantity,
        unit: unit ?? this.unit,
        minQuantity: minQuantity ?? this.minQuantity,
        price: price ?? this.price,
        currency: currency ?? this.currency,
        supplier: supplier ?? this.supplier,
        expiryDate: expiryDate ?? this.expiryDate,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  /// Check if inventory needs reordering.
  bool get needsReorder => quantity <= minQuantity;

  /// Check if item is expired.
  bool get isExpired {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }

  /// Get expiry status string.
  String getExpiryStatus() {
    if (expiryDate == null) return 'No expiry date';
    if (isExpired) return 'Expired';

    final daysUntilExpiry = expiryDate!.difference(DateTime.now()).inDays;
    if (daysUntilExpiry <= 0) return 'Expired';
    if (daysUntilExpiry <= 7) return 'Expires in $daysUntilExpiry days';
    if (daysUntilExpiry <= 30) {
      return 'Expires in ${(daysUntilExpiry / 7).ceil()} weeks';
    }
    return 'Expires in ${(daysUntilExpiry / 30).floor()} months';
  }

  /// Calculate total value of this inventory item.
  double getValue() => quantity * price;

  /// Get percentage of stock remaining compared to minimum.
  double getStockPercentage() {
    if (minQuantity == 0) return 100;
    final percentage = (quantity / (minQuantity * 2)) * 100;
    return percentage > 100 ? 100 : percentage;
  }

  /// Check if stock is low (between min and min * 1.5).
  bool get isLowStock =>
      quantity > minQuantity && quantity <= (minQuantity * 1.5).toInt();

  /// Check if stock is critical (at or below minimum).
  bool get isCriticalStock => quantity <= minQuantity;

  /// Days since last update.
  int get daysSinceUpdate => DateTime.now().difference(updatedAt).inDays;

  /// Convert to JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'clinicId': clinicId,
        'name': name,
        'category': category,
        'quantity': quantity,
        'unit': unit,
        'minQuantity': minQuantity,
        'price': price,
        'currency': currency,
        'supplier': supplier,
        'expiryDate': expiryDate?.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        clinicId,
        name,
        category,
        quantity,
        unit,
        minQuantity,
        price,
        currency,
        supplier,
        expiryDate,
        updatedAt,
      ];
}
