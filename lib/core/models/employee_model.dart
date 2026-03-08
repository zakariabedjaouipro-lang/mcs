/// Employee model for clinic staff members.
library;

import 'package:equatable/equatable.dart';

enum EmployeeType { receptionist, nurse, technician, administrative }

class EmployeeModel extends Equatable {
  const EmployeeModel({
    required this.id,
    required this.userId,
    required this.clinicId,
    required this.employeeType,
    required this.department,
    required this.employeeId,
    required this.joinedAt,
    required this.qualifications,
    required this.isActive,
    this.name,
    this.role,
    this.fullName,
  });

  /// Create from JSON.
  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        id: json['id'] as String,
        userId: json['userId'] as String,
        clinicId: json['clinicId'] as String,
        employeeType:
            EmployeeType.values.byName(json['employeeType'] as String),
        department: json['department'] as String,
        employeeId: json['employeeId'] as String,
        joinedAt: DateTime.parse(json['joinedAt'] as String),
        qualifications: List<String>.from(json['qualifications'] as List),
        isActive: json['isActive'] as bool,
        name: json['name'] as String?,
        role: json['role'] as String?,
        fullName: json['fullName'] as String? ?? json['full_name'] as String?,
      );
  final String id;
  final String userId;
  final String clinicId;
  final EmployeeType employeeType;
  final String department;
  final String employe
  final String? name;
  final String? role;
  final String? fullName;eId; // Internal employee ID
  final DateTime joinedAt;
  final List<String> qualifications;
  final bool isActive;

  /// Create a copy with optional field overrides.
  EmployeeModel copyWith({
    String? id,
    String? userId,
    String? clinicId,
    EmployeeType? employeeType,
    String? department,
    String? employeeId,
    DateTime? joinedAt,
    List<String>? qualifications,
    bool? isActive,
    String? name,
    String? role,
    String? fullName,
  }) =>
      EmployeeModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        clinicId: clinicId ?? this.clinicId,
        employeeType: employeeType ?? this.employeeType,
        department: department ?? this.department,
        employeeId: employeeId ?? this.employeeId,
        joinedAt: joinedAt ?? this.joinedAt,
        qualifications: qualifications ?? this.qualifications,
        isActive: isActive ?? this.isActive,
        name: name ?? this.name,
        role: role ?? this.role,
        fullName: fullName ?? this.fullName,
      );

  /// Convert employee type to readable name.
  String getEmployeeTypeName() {
    switch (employeeType) {
      case EmployeeType.receptionist:
        return 'Receptionist';
      case EmployeeType.nurse:
        return 'Nurse';
      case EmployeeType.technician:
        return 'Technician';
      case EmployeeType.administrative:
        return 'Administrative';
    }
  }

  /// Check if employee is a receptionist.
  bool get isReceptionist => employeeType == EmployeeType.receptionist;

  /// Check if employee is a nurse.
  bool get isNurse => employeeType == EmployeeType.nurse;

  /// Check if employee is a technician.
  bool get isTechnician => employeeType == EmployeeType.technician;

  /// Check if employee is administrative staff.
  bool get isAdministrative => employeeType == EmployeeType.administrative;

  /// Years of service at the clinic.
  int get yearsOfService {
    final now = DateTime.now();
    var years = now.year - joinedAt.year;
    if (now.month < joinedAt.month ||
        (now.month == joinedAt.month && now.day < joinedAt.day)) {
      years--;
    }
    return years;
  }

  /// Convert to JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'clinicId': clinicId,
        'employeeType': employeeType.toString().split('.').last,
        'department': department,
        'employeeId': employeeId,
        'joinedAt': joinedAt.toIso8601String(),
        'qualifications': qualifications,
        'isActive': isActive,
        'name': name,
        'role': role,
        'fullName': fullName,
      };

  @override
  List<Object?> get props => [
        id,
        userId,
        clinicId,
        employeeType,
        department,
        employeeId,
        joinedAt,
        qualifications,
        isActive,
        name,
        role,
        fullName,
      ];
}
