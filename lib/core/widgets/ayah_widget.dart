/// Islamic Ayah Widget - عرض الآية الكريمة بأناقة
/// Displays Islamic verses with glassmorphism effect and spiritual touch
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/theme/premium_colors.dart';

/// عرض الآية الكريمة برسوم متحركة وتصميم أنيق
class AyahWidget extends StatefulWidget {
  final double size;
  final bool showText;
  final bool animated;
  final VoidCallback? onTap;
  final String? customText;

  const AyahWidget({
    super.key,
    this.size = 100,
    this.showText = false,
    this.animated = true,
    this.onTap,
    this.customText,
  });

  @override
  State<AyahWidget> createState() => _AyahWidgetState();
}

class _AyahWidgetState extends State<AyahWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.animated) {
      _controller = AnimationController(
        duration: const Duration(seconds: 2),
        vsync: this,
      )..repeat(reverse: true);

      _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
    }
  }

  @override
  void dispose() {
    if (widget.animated) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return GestureDetector(
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: widget.animated ? _pulseAnimation : AlwaysStoppedAnimation(1.0),
        child: Container(
          padding: EdgeInsets.all(widget.size * 0.2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.size * 0.15),
            // Glassmorphism effect
            color: Colors.white.withValues(alpha: 0.15),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: PremiumColors.successGreen.withValues(alpha: 0.3),
                blurRadius: widget.size * 0.3,
                offset: Offset(0, widget.size * 0.1),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Icon(
                Icons.menu_book,
                size: widget.size * 0.4,
                color: PremiumColors.successGreen,
              ),
              if (widget.showText) ...[
                SizedBox(height: widget.size * 0.15),
                Text(
                  widget.customText ?? 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                  style: TextStyle(
                    fontSize: widget.size * 0.12,
                    fontWeight: FontWeight.bold,
                    color: PremiumColors.successGreen,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                  textDirection:
                      isArabic ? TextDirection.rtl : TextDirection.ltr,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// عرض الآية مع نص أسفلها
class AyahCard extends StatelessWidget {
  final String ayahText;
  final String? surahName;
  final String? ayahNumber;
  final double elevation;
  final VoidCallback? onTap;

  const AyahCard({
    super.key,
    required this.ayahText,
    this.surahName,
    this.ayahNumber,
    this.elevation = 2,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                PremiumColors.successGreen.withValues(alpha: 0.1),
                PremiumColors.successGreen.withValues(alpha: 0.05),
              ],
            ),
            border: Border.all(
              color: PremiumColors.successGreen.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              const AyahWidget(size: 60, animated: true),
              const SizedBox(height: 16),
              Text(
                ayahText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.8,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
              if (surahName != null || ayahNumber != null) ...[
                const SizedBox(height: 12),
                Text(
                  '${surahName ?? ''} ${ayahNumber ?? ''}'.trim(),
                  style: TextStyle(
                    fontSize: 12,
                    color: PremiumColors.successGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Decorative divider with Ayah icon
class AyahDivider extends StatelessWidget {
  final double height;
  final Color? color;

  const AyahDivider({
    super.key,
    this.height = 50,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final actualColor = color ?? PremiumColors.successGreen;

    return Container(
      height: height,
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: actualColor.withValues(alpha: 0.3),
              thickness: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(
              Icons.menu_book,
              color: actualColor,
              size: 20,
            ),
          ),
          Expanded(
            child: Divider(
              color: actualColor.withValues(alpha: 0.3),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
