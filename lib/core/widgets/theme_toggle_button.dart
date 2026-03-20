/// Theme Toggle Button - زر تبديل المظهر
/// Switches between light and dark themes
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/theme/premium_colors.dart';

/// زر تبديل المظهر (فاتح/داكن)
class ThemeToggleButton extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggle;
  final Color? color;
  final double size;
  final bool showLabel;

  const ThemeToggleButton({
    super.key,
    required this.isDarkMode,
    required this.onToggle,
    this.color,
    this.size = 24,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    final actualColor = color ?? PremiumColors.primaryBlue;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    if (showLabel) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIcon(actualColor),
          const SizedBox(width: 8),
          Text(
            isDarkMode
                ? (isArabic ? 'داكن' : 'Dark')
                : (isArabic ? 'فاتح' : 'Light'),
            style: TextStyle(
              fontSize: 12,
              color: actualColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return _buildIcon(actualColor);
  }

  Widget _buildIcon(Color color) {
    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Icon(
          isDarkMode ? Icons.light_mode : Icons.dark_mode,
          key: ValueKey<bool>(isDarkMode),
          size: size,
          color: color,
        ),
      ),
      onPressed: onToggle,
      tooltip: isDarkMode ? 'Light Mode' : 'Dark Mode',
    );
  }
}

/// Theme Preview - معاينة المظهر
class ThemePreview extends StatelessWidget {
  final bool isDarkMode;

  const ThemePreview({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
        ),
      ),
      child: Column(
        spacing: 12,
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'Header',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.grey.shade900,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            height: 30,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          Container(
            height: 30,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
      ),
    );
  }
}

/// Theme Settings Card - بطاقة إعدادات المظهر
class ThemeSettingsCard extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggle;
  final bool allowCustomColor;
  final Color? primaryColor;
  final VoidCallback? onColorChange;

  const ThemeSettingsCard({
    super.key,
    required this.isDarkMode,
    required this.onToggle,
    this.allowCustomColor = false,
    this.primaryColor,
    this.onColorChange,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isArabic ? 'إعدادات المظهر' : 'Theme Settings',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Theme Mode Selector
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _ThemeModeOption(
                      icon: Icons.light_mode,
                      label: isArabic ? 'فاتح' : 'Light',
                      isSelected: !isDarkMode,
                      onTap: isDarkMode ? onToggle : null,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey.shade300,
                  ),
                  Expanded(
                    child: _ThemeModeOption(
                      icon: Icons.dark_mode,
                      label: isArabic ? 'داكن' : 'Dark',
                      isSelected: isDarkMode,
                      onTap: !isDarkMode ? onToggle : null,
                    ),
                  ),
                ],
              ),
            ),
            // Preview
            ThemePreview(isDarkMode: isDarkMode),
            // Color Selection (if allowed)
            if (allowCustomColor && primaryColor != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text(
                    isArabic ? 'اللون الأساسي' : 'Primary Color',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 12,
                      children: [
                        Colors.blue,
                        Colors.teal,
                        Colors.green,
                        Colors.purple,
                        Colors.pink,
                      ]
                          .map((color) => _ColorOption(
                                color: color,
                                isSelected: primaryColor == color,
                                onTap: onColorChange,
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _ThemeModeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const _ThemeModeOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            spacing: 8,
            children: [
              Icon(
                icon,
                color: isSelected ? PremiumColors.primaryBlue : Colors.grey,
                size: 24,
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? PremiumColors.primaryBlue : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorOption extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback? onTap;

  const _ColorOption({
    required this.color,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(
                  color: Colors.black,
                  width: 3,
                )
              : null,
        ),
        child: isSelected
            ? const Center(
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20,
                ),
              )
            : null,
      ),
    );
  }
}

/// Animation Preview - معاينة الرسوم المتحركة
class AnimationPreview extends StatefulWidget {
  final bool isDarkMode;

  const AnimationPreview({super.key, required this.isDarkMode});

  @override
  State<AnimationPreview> createState() => _AnimationPreviewState();
}

class _AnimationPreviewState extends State<AnimationPreview>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: _animation,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color:
                widget.isDarkMode ? Colors.grey.shade800 : Colors.blue.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.animation,
            color: PremiumColors.primaryBlue,
            size: 32,
          ),
        ),
      ),
    );
  }
}
