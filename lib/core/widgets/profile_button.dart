/// Profile Button - زر الملف الشخصي
/// Shows user avatar with dropdown menu for profile, settings, logout
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/assets/icons/custom_icons.dart';
import 'package:mcs/core/theme/premium_colors.dart';

/// زر الملف الشخصي مع قائمة منسدلة
class ProfileButton extends StatelessWidget {
  final String userName;
  final String userRole;
  final String? avatarUrl;
  final VoidCallback? onProfileTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onLogoutTap;
  final double size;
  final Color? accentColor;

  const ProfileButton({
    super.key,
    required this.userName,
    required this.userRole,
    this.avatarUrl,
    this.onProfileTap,
    this.onSettingsTap,
    this.onLogoutTap,
    this.size = 40,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final roleColor = CustomIcons.getRoleColor(userRole);
    final actualAccentColor = accentColor ?? roleColor;

    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'profile':
            onProfileTap?.call();
            break;
          case 'settings':
            onSettingsTap?.call();
            break;
          case 'logout':
            onLogoutTap?.call();
            break;
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 'profile',
          child: Row(
            spacing: 12,
            children: [
              Icon(Icons.person, color: actualAccentColor),
              Text(isArabic ? 'الملف الشخصي' : 'Profile'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'settings',
          child: Row(
            spacing: 12,
            children: [
              Icon(Icons.settings, color: actualAccentColor),
              Text(isArabic ? 'الإعدادات' : 'Settings'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'logout',
          child: Row(
            spacing: 12,
            children: [
              const Icon(Icons.logout, color: PremiumColors.errorRed),
              Text(
                isArabic ? 'تسجيل الخروج' : 'Logout',
                style: const TextStyle(color: PremiumColors.errorRed),
              ),
            ],
          ),
        ),
      ],
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: actualAccentColor,
            width: 2,
          ),
        ),
        child: CircleAvatar(
          radius: size / 2,
          backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
          backgroundColor: avatarUrl == null
              ? actualAccentColor.withValues(alpha: 0.2)
              : null,
          child: avatarUrl == null
              ? Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: actualAccentColor,
                    fontSize: size * 0.4,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

/// Profile Card - بطاقة الملف الشخصي
class ProfileCard extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userRole;
  final String? avatarUrl;
  final VoidCallback? onEditTap;
  final Color? accentColor;

  const ProfileCard({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userRole,
    this.avatarUrl,
    this.onEditTap,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final roleColor = CustomIcons.getRoleColor(userRole);
    final actualAccentColor = accentColor ?? roleColor;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              actualAccentColor.withValues(alpha: 0.1),
              actualAccentColor.withValues(alpha: 0.05),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          spacing: 16,
          children: [
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundImage:
                  avatarUrl != null ? NetworkImage(avatarUrl!) : null,
              backgroundColor: avatarUrl == null
                  ? actualAccentColor.withValues(alpha: 0.2)
                  : null,
              child: avatarUrl == null
                  ? Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: actualAccentColor,
                        fontSize: 32,
                      ),
                    )
                  : null,
            ),
            // User Info
            Column(
              spacing: 4,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textDirection:
                      isArabic ? TextDirection.rtl : TextDirection.ltr,
                ),
                Text(
                  userEmail,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  textDirection:
                      isArabic ? TextDirection.rtl : TextDirection.ltr,
                ),
                SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: actualAccentColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    userRole,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: actualAccentColor,
                    ),
                  ),
                ),
              ],
            ),
            // Edit Button
            if (onEditTap != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onEditTap,
                  icon: const Icon(Icons.edit),
                  label: Text(
                    isArabic ? 'تعديل الملف' : 'Edit Profile',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: actualAccentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Profile Menu Dialog - حوار قائمة الملف الشخصي
class ProfileMenuDialog extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userRole;
  final String? avatarUrl;
  final List<ProfileMenuItem> menuItems;
  final VoidCallback? onClose;
  final Color? accentColor;

  const ProfileMenuDialog({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userRole,
    this.avatarUrl,
    required this.menuItems,
    this.onClose,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final roleColor = CustomIcons.getRoleColor(userRole);
    final actualAccentColor = accentColor ?? roleColor;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                color: actualAccentColor.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                spacing: 12,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                    backgroundColor: avatarUrl == null
                        ? actualAccentColor.withValues(alpha: 0.2)
                        : null,
                    child: avatarUrl == null
                        ? Text(
                            userName.isNotEmpty
                                ? userName[0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: actualAccentColor,
                              fontSize: 24,
                            ),
                          )
                        : null,
                  ),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    userEmail,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: actualAccentColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      userRole,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: actualAccentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Menu Items
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: menuItems.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, indent: 16, endIndent: 16),
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return ListTile(
                  leading: Icon(item.icon, color: item.color),
                  title: Text(item.label),
                  trailing: item.trailingIcon != null
                      ? Icon(item.trailingIcon)
                      : null,
                  onTap: () {
                    item.onTap?.call();
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Profile Menu Item Model
class ProfileMenuItem {
  final String label;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;
  final IconData? trailingIcon;

  ProfileMenuItem({
    required this.label,
    required this.icon,
    this.color,
    this.onTap,
    this.trailingIcon,
  });
}

/// Profile Dropdown - قائمة الملف الشخصي المنسدلة
class ProfileDropdown extends StatefulWidget {
  final String userName;
  final String userRole;
  final String? avatarUrl;
  final void Function(String) onMenuItemSelected;
  final List<String> menuItems;

  const ProfileDropdown({
    super.key,
    required this.userName,
    required this.userRole,
    this.avatarUrl,
    required this.onMenuItemSelected,
    this.menuItems = const ['profile', 'settings', 'logout'],
  });

  @override
  State<ProfileDropdown> createState() => _ProfileDropdownState();
}

class _ProfileDropdownState extends State<ProfileDropdown> {
  final GlobalKey<PopupMenuButtonState<String>> _menuKey =
      GlobalKey<PopupMenuButtonState<String>>();

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final roleColor = CustomIcons.getRoleColor(widget.userRole);

    return PopupMenuButton<String>(
      key: _menuKey,
      onSelected: widget.onMenuItemSelected,
      itemBuilder: (BuildContext context) {
        return widget.menuItems.map((item) {
          late String label;
          late IconData icon;
          Color? color;

          switch (item) {
            case 'profile':
              label = isArabic ? 'الملف الشخصي' : 'Profile';
              icon = Icons.person;
              break;
            case 'settings':
              label = isArabic ? 'الإعدادات' : 'Settings';
              icon = Icons.settings;
              break;
            case 'logout':
              label = isArabic ? 'تسجيل الخروج' : 'Logout';
              icon = Icons.logout;
              color = PremiumColors.errorRed;
              break;
            default:
              label = item;
              icon = Icons.info;
          }

          return PopupMenuItem<String>(
            value: item,
            child: Row(
              spacing: 12,
              children: [
                Icon(icon, color: color),
                Text(label, style: TextStyle(color: color)),
              ],
            ),
          );
        }).toList();
      },
      child: CircleAvatar(
        radius: 20,
        backgroundImage:
            widget.avatarUrl != null ? NetworkImage(widget.avatarUrl!) : null,
        backgroundColor:
            widget.avatarUrl == null ? roleColor.withValues(alpha: 0.2) : null,
        child: widget.avatarUrl == null
            ? Text(
                widget.userName.isNotEmpty
                    ? widget.userName[0].toUpperCase()
                    : '?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: roleColor,
                  fontSize: 16,
                ),
              )
            : null,
      ),
    );
  }
}
