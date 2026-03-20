/// Custom icons system for MCS application.
/// Provides Material Design SVG icons for all user roles.
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Custom icons for all medical clinic roles and features.
///
/// Provides a centralized system for managing SVG-based icons
/// with consistent sizing and coloring.
class CustomIcons {
  CustomIcons._();

  static const String _basePath = 'assets/icons/svg/';

  /// Reception desk staff icon
  static Widget reception({
    double size = 24,
    Color? color,
  }) =>
      _buildSvg(
        '${_basePath}reception.svg',
        size: size,
        color: color ?? Colors.blue,
      );

  /// Radiography/X-ray specialist icon
  static Widget radiology({
    double size = 24,
    Color? color,
  }) =>
      _buildSvg(
        '${_basePath}radiology.svg',
        size: size,
        color: color ?? Colors.amber,
      );

  /// Lab technician icon
  static Widget labTechnician({
    double size = 24,
    Color? color,
  }) =>
      _buildSvg(
        '${_basePath}lab_technician.svg',
        size: size,
        color: color ?? Colors.cyan,
      );

  /// Pharmacist icon
  static Widget pharmacist({
    double size = 24,
    Color? color,
  }) =>
      _buildSvg(
        '${_basePath}pharmacist.svg',
        size: size,
        color: color ?? Colors.green,
      );

  /// Nurse icon
  static Widget nurse({
    double size = 24,
    Color? color,
  }) =>
      _buildSvg(
        '${_basePath}nurse.svg',
        size: size,
        color: color ?? Colors.teal,
      );

  /// Receptionist icon
  static Widget receptionist({
    double size = 24,
    Color? color,
  }) =>
      _buildSvg(
        '${_basePath}receptionist.svg',
        size: size,
        color: color ?? Colors.orange,
      );

  /// Patient relative/family member icon
  static Widget relative({
    double size = 24,
    Color? color,
  }) =>
      _buildSvg(
        '${_basePath}relative.svg',
        size: size,
        color: color ?? Colors.brown,
      );

  /// Clinic administrator icon
  static Widget clinicAdmin({
    double size = 24,
    Color? color,
  }) =>
      _buildSvg(
        '${_basePath}clinic_admin.svg',
        size: size,
        color: color ?? Colors.indigo,
      );

  /// Radiographer/Photography specialist icon
  static Widget radiographer({
    double size = 24,
    Color? color,
  }) =>
      _buildSvg(
        '${_basePath}radiographer.svg',
        size: size,
        color: color ?? Colors.orange,
      );

  /// Generic medical doctor icon
  static Widget doctor({
    double size = 24,
    Color? color,
  }) =>
      Icon(
        Icons.medical_services,
        size: size,
        color: color ?? Colors.blue,
      );

  /// Generic patient icon
  static Widget patient({
    double size = 24,
    Color? color,
  }) =>
      Icon(
        Icons.person,
        size: size,
        color: color ?? Colors.green,
      );

  /// Generic admin icon
  static Widget admin({
    double size = 24,
    Color? color,
  }) =>
      Icon(
        Icons.admin_panel_settings,
        size: size,
        color: color ?? Colors.purple,
      );

  /// Super admin icon
  static Widget superAdmin({
    double size = 24,
    Color? color,
  }) =>
      Icon(
        Icons.shield,
        size: size,
        color: color ?? Colors.deepPurple,
      );

  /// Employee/staff icon
  static Widget employee({
    double size = 24,
    Color? color,
  }) =>
      Icon(
        Icons.people,
        size: size,
        color: color ?? Colors.blueGrey,
      );

  /// Common appointment icon
  static Widget appointment({
    double size = 24,
    Color? color,
  }) =>
      Icon(
        Icons.calendar_today,
        size: size,
        color: color ?? Colors.purple,
      );

  /// Common prescription icon
  static Widget prescription({
    double size = 24,
    Color? color,
  }) =>
      Icon(
        Icons.description,
        size: size,
        color: color ?? Colors.indigo,
      );

  /// Common medical report icon
  static Widget report({
    double size = 24,
    Color? color,
  }) =>
      Icon(
        Icons.assessment,
        size: size,
        color: color ?? Colors.orange,
      );

  /// Building SVG with proper error handling
  static Widget _buildSvg(
    String assetPath, {
    required double size,
    required Color color,
  }) =>
      SvgPicture.asset(
        assetPath,
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        placeholderBuilder: (context) => SizedBox(
          width: size,
          height: size,
          child: Icon(
            Icons.image_not_supported,
            size: size,
            color: color,
          ),
        ),
      );

  /// Get icon widget by role name
  static Widget getIconByRole(
    String role, {
    double size = 24,
    Color? color,
  }) {
    switch (role.toLowerCase()) {
      case 'receptionist':
        return receptionist(size: size, color: color);
      case 'radiographer':
        return radiographer(size: size, color: color);
      case 'lab_technician':
        return labTechnician(size: size, color: color);
      case 'pharmacist':
        return pharmacist(size: size, color: color);
      case 'nurse':
        return nurse(size: size, color: color);
      case 'doctor':
        return doctor(size: size, color: color);
      case 'clinic_admin':
        return clinicAdmin(size: size, color: color);
      case 'patient':
        return patient(size: size, color: color);
      case 'relative':
        return relative(size: size, color: color);
      case 'admin':
        return admin(size: size, color: color);
      case 'super_admin':
        return superAdmin(size: size, color: color);
      default:
        return Icon(
          Icons.person,
          size: size,
          color: color ?? Colors.grey,
        );
    }
  }

  /// Get default color for role
  static Color getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'super_admin':
        return Colors.deepPurple;
      case 'clinic_admin':
        return Colors.indigo;
      case 'doctor':
        return Colors.blue;
      case 'nurse':
        return Colors.teal;
      case 'receptionist':
        return Colors.orange;
      case 'pharmacist':
        return Colors.green;
      case 'lab_technician':
        return Colors.cyan;
      case 'radiographer':
        return Colors.amber;
      case 'patient':
        return Colors.green;
      case 'relative':
        return Colors.brown;
      case 'admin':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
