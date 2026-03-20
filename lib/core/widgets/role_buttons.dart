/// Role-based button widgets for MCS application.
/// Provides customizable buttons for different user roles with icons and styling.
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/assets/icons/custom_icons.dart';

/// Base role button widget with customizable appearance
class RoleButton extends StatelessWidget {
  final String role;
  final String label;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData? icon;
  final Widget? customIcon;
  final double? width;
  final double? height;
  final bool isSelected;
  final EdgeInsets? padding;

  const RoleButton({
    super.key,
    required this.role,
    required this.label,
    required this.onTap,
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
    this.customIcon,
    this.width,
    this.height,
    this.isSelected = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final color = foregroundColor ?? CustomIcons.getRoleColor(role);
    final bgColor = backgroundColor ?? color.withValues(alpha: 0.1);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: width,
          height: height,
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? bgColor.withValues(alpha: 0.3) : bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : color.withValues(alpha: 0.3),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (customIcon != null)
                customIcon!
              else if (icon != null)
                Icon(icon, color: color, size: 20)
              else
                CustomIcons.getIconByRole(role, size: 20, color: color),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Role button with card-style appearance
class RoleCard extends StatelessWidget {
  final String role;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final double elevation;
  final bool isSelected;

  const RoleCard({
    super.key,
    required this.role,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.elevation = 2,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = CustomIcons.getRoleColor(role);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: isSelected ? elevation + 2 : elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color:
                isSelected ? color.withValues(alpha: 0.05) : Colors.transparent,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIcons.getIconByRole(
                role,
                size: 40,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: color.withValues(alpha: 0.7),
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Receptionist role button
class ReceptionistButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSelected;

  const ReceptionistButton({
    super.key,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return RoleButton(
      role: 'receptionist',
      label: Localizations.localeOf(context).languageCode == 'ar'
          ? 'موظف استقبال'
          : 'Receptionist',
      onTap: onTap,
      isSelected: isSelected,
    );
  }
}

/// Nurse role button
class NurseButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSelected;

  const NurseButton({
    super.key,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return RoleButton(
      role: 'nurse',
      label: Localizations.localeOf(context).languageCode == 'ar'
          ? 'ممرضة'
          : 'Nurse',
      onTap: onTap,
      isSelected: isSelected,
    );
  }
}

/// Radiographer role button
class RadiographerButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSelected;

  const RadiographerButton({
    super.key,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return RoleButton(
      role: 'radiographer',
      label: Localizations.localeOf(context).languageCode == 'ar'
          ? 'أخصائي أشعة'
          : 'Radiographer',
      onTap: onTap,
      isSelected: isSelected,
    );
  }
}

/// Lab Technician role button
class LabTechnicianButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSelected;

  const LabTechnicianButton({
    super.key,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return RoleButton(
      role: 'lab_technician',
      label: Localizations.localeOf(context).languageCode == 'ar'
          ? 'فني مختبر'
          : 'Lab Technician',
      onTap: onTap,
      isSelected: isSelected,
    );
  }
}

/// Pharmacist role button
class PharmacistButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSelected;

  const PharmacistButton({
    super.key,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return RoleButton(
      role: 'pharmacist',
      label: Localizations.localeOf(context).languageCode == 'ar'
          ? 'صيدلي'
          : 'Pharmacist',
      onTap: onTap,
      isSelected: isSelected,
    );
  }
}

/// Relative role button
class RelativeButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSelected;

  const RelativeButton({
    super.key,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return RoleButton(
      role: 'relative',
      label: Localizations.localeOf(context).languageCode == 'ar'
          ? 'قريب المريض'
          : 'Relative',
      onTap: onTap,
      isSelected: isSelected,
    );
  }
}

/// Clinic Admin role button
class ClinicAdminButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSelected;

  const ClinicAdminButton({
    super.key,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return RoleButton(
      role: 'clinic_admin',
      label: Localizations.localeOf(context).languageCode == 'ar'
          ? 'مسؤول العيادة'
          : 'Clinic Admin',
      onTap: onTap,
      isSelected: isSelected,
    );
  }
}

/// Grid view of role buttons
class RoleButtonGrid extends StatelessWidget {
  final List<Map<String, dynamic>> roles;
  final int crossAxisCount;
  final double childAspectRatio;
  final EdgeInsets padding;
  final MainAxisAlignment mainAxisAlignment;

  const RoleButtonGrid({
    super.key,
    required this.roles,
    this.crossAxisCount = 2,
    this.childAspectRatio = 2.5,
    this.padding = const EdgeInsets.all(16),
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: roles.length,
      itemBuilder: (context, index) {
        final role = roles[index];
        return RoleCard(
          role: role['role'] as String,
          title: role['title'] as String,
          subtitle: role['subtitle'] as String?,
          onTap: role['onTap'] as VoidCallback,
          isSelected: role['isSelected'] as bool? ?? false,
        );
      },
    );
  }
}
