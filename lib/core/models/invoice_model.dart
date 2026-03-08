/// Invoice model for appointment billing and payments.
library;

import 'package:equatable/equatable.dart';

enum InvoiceStatus { draft, issued, pending, paid, cancelled }

class InvoiceItem extends Equatable {
  const InvoiceItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.amount,
  });

  /// Create from JSON.
  factory InvoiceItem.fromJson(Map<String, dynamic> json) => InvoiceItem(
        description: json['description'] as String,
        quantity: json['quantity'] as int,
        unitPrice: (json['unitPrice'] as num).toDouble(),
        amount: (json['amount'] as num).toDouble(),
      );
  final String description;
  final int quantity;
  final double unitPrice;
  final double amount;

  /// Convert to JSON.
  Map<String, dynamic> toJson() => {
        'description': description,
        'quantity': quantity,
        'unitPrice': unitPrice,
        'amount': amount,
      };

  @override
  List<Object?> get props => [description, quantity, unitPrice, amount];
}

class InvoiceModel extends Equatable {
  const InvoiceModel({
    required this.id,
    required this.clinicId,
    required this.patientId,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.totalAmount,
    required this.currency,
    required this.status,
    required this.createdAt,
    this.appointmentId,
    this.paidAt,
  });

  /// Create from JSON.
  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
        id: json['id'] as String,
        clinicId: json['clinicId'] as String,
        patientId: json['patientId'] as String,
        appointmentId: json['appointmentId'] as String?,
        items: (json['items'] as List<dynamic>)
            .map((i) => InvoiceItem.fromJson(i as Map<String, dynamic>))
            .toList(),
        subtotal: (json['subtotal'] as num).toDouble(),
        tax: (json['tax'] as num).toDouble(),
        discount: (json['discount'] as num).toDouble(),
        totalAmount: (json['totalAmount'] as num).toDouble(),
        currency: json['currency'] as String,
        status: InvoiceStatus.values.byName(json['status'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
        paidAt: json['paidAt'] != null
            ? DateTime.parse(json['paidAt'] as String)
            : null,
      );
  final String id;
  final String clinicId;
  final String patientId;
  final String? appointmentId;
  final List<InvoiceItem> items;
  final double subtotal;
  final double tax;
  final double discount;
  final double totalAmount;
  final String currency;
  final InvoiceStatus status;
  final DateTime createdAt;
  final DateTime? paidAt;

  /// Create a copy with optional field overrides.
  InvoiceModel copyWith({
    String? id,
    String? clinicId,
    String? patientId,
    String? appointmentId,
    List<InvoiceItem>? items,
    double? subtotal,
    double? tax,
    double? discount,
    double? totalAmount,
    String? currency,
    InvoiceStatus? status,
    DateTime? createdAt,
    DateTime? paidAt,
  }) =>
      InvoiceModel(
        id: id ?? this.id,
        clinicId: clinicId ?? this.clinicId,
        patientId: patientId ?? this.patientId,
        appointmentId: appointmentId ?? this.appointmentId,
        items: items ?? this.items,
        subtotal: subtotal ?? this.subtotal,
        tax: tax ?? this.tax,
        discount: discount ?? this.discount,
        totalAmount: totalAmount ?? this.totalAmount,
        currency: currency ?? this.currency,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        paidAt: paidAt ?? this.paidAt,
      );

  /// Calculate total amount from items.
  double calculateTotal() {
    final itemsTotal = items.fold<double>(0, (sum, item) => sum + item.amount);
    return (itemsTotal + tax) - discount;
  }

  /// Check if invoice is paid.
  bool get isPaid => status == InvoiceStatus.paid && paidAt != null;

  /// Check if invoice is pending payment.
  bool get isPending => status == InvoiceStatus.pending;

  /// Check if invoice is overdue (issued more than 30 days ago without payment).
  bool get isOverdue {
    if (isPaid) return false;
    final diff = DateTime.now().difference(createdAt);
    return diff.inDays > 30;
  }

  /// Get number of items in invoice.
  int get itemCount => items.length;

  /// Get invoice status name.
  String getStatusName() {
    switch (status) {
      case InvoiceStatus.draft:
        return 'Draft';
      case InvoiceStatus.issued:
        return 'Issued';
      case InvoiceStatus.pending:
        return 'Pending';
      case InvoiceStatus.paid:
        return 'Paid';
      case InvoiceStatus.cancelled:
        return 'Cancelled';
    }
  }

  /// Get days since invoice creation.
  int get daysSinceCreation => DateTime.now().difference(createdAt).inDays;

  /// Get days until due (30 days from creation).
  int get daysUntilDue {
    final dueDate = createdAt.add(const Duration(days: 30));
    return dueDate.difference(DateTime.now()).inDays;
  }

  /// Alias for createdAt for backward compatibility
  DateTime get invoiceDate => createdAt;

  /// Convert to JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'clinicId': clinicId,
        'patientId': patientId,
        'appointmentId': appointmentId,
        'items': items.map((i) => i.toJson()).toList(),
        'subtotal': subtotal,
        'tax': tax,
        'discount': discount,
        'totalAmount': totalAmount,
        'currency': currency,
        'status': status.toString().split('.').last,
        'createdAt': createdAt.toIso8601String(),
        'paidAt': paidAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        clinicId,
        patientId,
        appointmentId,
        items,
        subtotal,
        tax,
        discount,
        totalAmount,
        currency,
        status,
        createdAt,
        paidAt,
      ];
}
