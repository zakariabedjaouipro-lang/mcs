/// Role avatar widget for displaying user role with custom icon.
/// Provides circular and customizable role indicators.
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/assets/icons/custom_icons.dart';

/// Avatar widget displaying role icon in a circle
class RoleAvatar extends StatelessWidget {
  final String role;
  final double radius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback? onTap;
  final Border? border;
  final BoxShadow? shadow;

  const RoleAvatar({
    super.key,
    required this.role,
    this.radius = 20,
    this.backgroundColor,
    this.foregroundColor,
    this.onTap,
    this.border,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    final roleColor = foregroundColor ?? CustomIcons.getRoleColor(role);
    final bgColor = backgroundColor ?? roleColor.withValues(alpha: 0.2);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: border,
          boxShadow: shadow != null ? [shadow!] : null,
        ),
        child: CircleAvatar(
          radius: radius,
          backgroundColor: bgColor,
          child: CustomIcons.getIconByRole(
            role,
            size: radius * 1.2,
            color: roleColor,
          ),
        ),
      ),
    );
  }
}

/// Larger avatar with role label
class RoleAvatarWithLabel extends StatelessWidget {
  final String role;
  final String label;
  final double radius;
  final TextStyle? labelStyle;
  final VoidCallback? onTap;

  const RoleAvatarWithLabel({
    super.key,
    required this.role,
    required this.label,
    this.radius = 24,
    this.labelStyle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RoleAvatar(
            role: role,
            radius: radius,
            foregroundColor: CustomIcons.getRoleColor(role),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: labelStyle ??
                Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: CustomIcons.getRoleColor(role),
                      fontWeight: FontWeight.w600,
                    ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Avatar group showing multiple role avatars
class RoleAvatarGroup extends StatelessWidget {
  final List<String> roles;
  final double radius;
  final double overlapSize;
  final MainAxisAlignment mainAxisAlignment;

  const RoleAvatarGroup({
    super.key,
    required this.roles,
    this.radius = 16,
    this.overlapSize = 8,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: radius * 2,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: roles.length,
        itemBuilder: (context, index) {
          return Transform.translate(
            offset: Offset(-overlapSize * index.toDouble(), 0),
            child: RoleAvatar(
              role: roles[index],
              radius: radius,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Badge widget showing role with count
class RoleBadge extends StatelessWidget {
  final String role;
  final String? badgeLabel;
  final int? badgeCount;
  final Color? badgeBackgroundColor;
  final double radius;

  const RoleBadge({
    super.key,
    required this.role,
    this.badgeLabel,
    this.badgeCount,
    this.badgeBackgroundColor,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    final badgeBgColor = badgeBackgroundColor ?? Colors.red;

    return Stack(
      children: [
        RoleAvatar(role: role, radius: radius),
        if (badgeLabel != null || badgeCount != null)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: badgeBgColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Text(
                badgeLabel ?? (badgeCount?.toString() ?? ''),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Status avatar showing role with status indicator
class RoleAvatarWithStatus extends StatelessWidget {
  final String role;
  final bool isOnline;
  final double radius;

  const RoleAvatarWithStatus({
    super.key,
    required this.role,
    required this.isOnline,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RoleAvatar(role: role, radius: radius),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: radius * 0.7,
            height: radius * 0.7,
            decoration: BoxDecoration(
              color: isOnline ? Colors.green : Colors.grey,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

/// Animated role avatar
class AnimatedRoleAvatar extends StatefulWidget {
  final String role;
  final double radius;
  final Duration duration;

  const AnimatedRoleAvatar({
    super.key,
    required this.role,
    this.radius = 20,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedRoleAvatar> createState() => _AnimatedRoleAvatarState();
}

class _AnimatedRoleAvatarState extends State<AnimatedRoleAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: RoleAvatar(
        role: widget.role,
        radius: widget.radius,
      ),
    );
  }
}

/// Mini avatar for list items
class MiniRoleAvatar extends StatelessWidget {
  final String role;
  final double size;

  const MiniRoleAvatar({
    super.key,
    required this.role,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: RoleAvatar(
        role: role,
        radius: size / 2,
      ),
    );
  }
}

/// Create role avatar by specific role name
RoleAvatar createRoleAvatar(
  String role, {
  double radius = 20,
  VoidCallback? onTap,
}) =>
    RoleAvatar(
      role: role,
      radius: radius,
      onTap: onTap,
    );
