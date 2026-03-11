/// Premium Dashboard Card Component
/// High-end card for dashboard metrics and widgets
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/theme/premium_colors.dart';
import 'package:mcs/core/theme/premium_text_styles.dart';

class PremiumDashboardCard extends StatefulWidget {
  const PremiumDashboardCard({
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
    this.trend,
    this.trendColor,
    this.onTap,
    this.backgroundColor,
    super.key,
  });

  final String title;
  final String value;
  final IconData icon;
  final String? subtitle;
  final String? trend;
  final Color? trendColor;
  final VoidCallback? onTap;
  final LinearGradient? backgroundColor;

  @override
  State<PremiumDashboardCard> createState() => _PremiumDashboardCardState();
}

class _PremiumDashboardCardState extends State<PremiumDashboardCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 20),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                gradient:
                    widget.backgroundColor ?? PremiumColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: _isHovered
                    ? PremiumColors.elevatedShadow
                    : PremiumColors.mediumShadow,
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.1),
                      Colors.white.withValues(alpha: 0.05),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Title
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: PremiumTextStyles.bodyMedium.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                            if (widget.subtitle != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                widget.subtitle!,
                                style: PremiumTextStyles.caption.copyWith(
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ],
                        ),

                        // Icon
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            widget.icon,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Value
                    Text(
                      widget.value,
                      style: PremiumTextStyles.displayLarge.copyWith(
                        color: Colors.white,
                        fontSize: 32,
                      ),
                    ),

                    if (widget.trend != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              (widget.trendColor ?? PremiumColors.successGreen)
                                  .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              widget.trend!.startsWith('+')
                                  ? Icons.trending_up
                                  : Icons.trending_down,
                              size: 14,
                              color: widget.trendColor ??
                                  PremiumColors.successGreen,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.trend!,
                              style: PremiumTextStyles.labelSmall.copyWith(
                                color: widget.trendColor ??
                                    PremiumColors.successGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Premium Navigation Tab
class PremiumNavTab extends StatefulWidget {
  const PremiumNavTab({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
    super.key,
  });

  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<PremiumNavTab> createState() => _PremiumNavTabState();
}

class _PremiumNavTabState extends State<PremiumNavTab> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isActive
                ? PremiumColors.primaryBlue.withValues(alpha: 0.1)
                : _isHovered
                    ? PremiumColors.lightGrey
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: widget.isActive
                ? Border.all(
                    color: PremiumColors.primaryBlue,
                    width: 1.5,
                  )
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 18,
                color: widget.isActive
                    ? PremiumColors.primaryBlue
                    : PremiumColors.darkText,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: PremiumTextStyles.bodyMedium.copyWith(
                  color: widget.isActive
                      ? PremiumColors.primaryBlue
                      : PremiumColors.darkText,
                  fontWeight:
                      widget.isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Premium Stats Row
class PremiumStatsRow extends StatelessWidget {
  const PremiumStatsRow({
    required this.stats,
    super.key,
  });

  final List<StatItem> stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        stats.length,
        (index) {
          final stat = stats[index];
          return Expanded(
            child: Padding(
              padding:
                  EdgeInsets.only(right: index < stats.length - 1 ? 12 : 0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: PremiumColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: PremiumColors.mediumGrey,
                  ),
                  boxShadow: PremiumColors.softShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stat.label,
                      style: PremiumTextStyles.bodySmall.copyWith(
                        color: PremiumColors.lightText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      stat.value,
                      style: PremiumTextStyles.headingSmall,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class StatItem {
  StatItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}
