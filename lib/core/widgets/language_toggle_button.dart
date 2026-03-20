/// Language Toggle Button - زر تبديل اللغة
/// Switches between Arabic and English
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/theme/premium_colors.dart';

/// زر تبديل اللغة (العربية/الإنجليزية)
class LanguageToggleButton extends StatelessWidget {
  final String currentLanguage; // 'ar' or 'en'
  final VoidCallback onToggle;
  final Color? color;
  final double size;
  final bool showLabel;

  const LanguageToggleButton({
    super.key,
    required this.currentLanguage,
    required this.onToggle,
    this.color,
    this.size = 24,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    final actualColor = color ?? PremiumColors.primaryBlue;
    final isArabic = currentLanguage == 'ar';

    if (showLabel) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIcon(actualColor, isArabic),
          const SizedBox(width: 8),
          Text(
            isArabic ? 'العربية' : 'English',
            style: TextStyle(
              fontSize: 12,
              color: actualColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return _buildIcon(actualColor, isArabic);
  }

  Widget _buildIcon(Color color, bool isArabic) {
    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Text(
          isArabic ? 'ع' : 'EN',
          key: ValueKey<String>(currentLanguage),
          style: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
      onPressed: onToggle,
      tooltip: isArabic ? 'English' : 'العربية',
    );
  }
}

/// Language Selector Dropdown - منتقي اللغة بقائمة منسدلة
class LanguageSelectorDropdown extends StatelessWidget {
  final String currentLanguage;
  final void Function(String) onLanguageChange;
  final Color? backgroundColor;
  final Color? textColor;

  const LanguageSelectorDropdown({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChange,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final languages = <String, String>{'ar': 'العربية', 'en': 'English'};

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: currentLanguage,
        isExpanded: true,
        underline: const SizedBox(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        items: languages.entries
            .map((e) => DropdownMenuItem(
                  value: e.key,
                  child: Text(e.value),
                ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            onLanguageChange(value);
          }
        },
      ),
    );
  }
}

/// Language Settings Card - بطاقة إعدادات اللغة
class LanguageSettingsCard extends StatelessWidget {
  final String currentLanguage;
  final void Function(String) onLanguageChange;

  const LanguageSettingsCard({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChange,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = currentLanguage == 'ar';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Text(
              isArabic ? 'اللغة' : 'Language',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Language Option Cards
            Row(
              spacing: 12,
              children: [
                Expanded(
                  child: _LanguageOptionCard(
                    flag: '🇸🇦',
                    label: 'العربية',
                    subtitle: isArabic ? 'مختار' : 'Selected',
                    isSelected: currentLanguage == 'ar',
                    onTap: () => onLanguageChange('ar'),
                  ),
                ),
                Expanded(
                  child: _LanguageOptionCard(
                    flag: '🇺🇸',
                    label: 'English',
                    subtitle: !isArabic ? 'Selected' : 'Choose',
                    isSelected: currentLanguage == 'en',
                    onTap: () => onLanguageChange('en'),
                  ),
                ),
              ],
            ),
            // Preview
            _LanguagePreview(isArabic: isArabic),
          ],
        ),
      ),
    );
  }
}

class _LanguageOptionCard extends StatelessWidget {
  final String flag;
  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOptionCard({
    required this.flag,
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isSelected ? PremiumColors.primaryBlue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? PremiumColors.primaryBlue.withValues(alpha: 0.05)
              : Colors.transparent,
        ),
        child: Column(
          spacing: 8,
          children: [
            Text(
              flag,
              style: const TextStyle(fontSize: 32),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? PremiumColors.primaryBlue : Colors.black,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? PremiumColors.primaryBlue
                    : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguagePreview extends StatelessWidget {
  final bool isArabic;

  const _LanguagePreview({required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(
            isArabic ? 'معاينة اللغة' : 'Language Preview',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Text(
            isArabic
                ? 'مرحباً بك في تطبيق العيادة الطبية'
                : 'Welcome to Medical Clinic Application',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          ),
        ],
      ),
    );
  }
}

/// Language Menu - قائمة اللغات
class LanguageMenu extends StatelessWidget {
  final String currentLanguage;
  final void Function(String) onLanguageChange;

  const LanguageMenu({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChange,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      initialValue: currentLanguage,
      onSelected: onLanguageChange,
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 'en',
          child: Row(
            spacing: 12,
            children: [
              const Text('🇺🇸'),
              const Text('English'),
              if (currentLanguage == 'en')
                const Icon(
                  Icons.check,
                  color: PremiumColors.successGreen,
                ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'ar',
          child: Row(
            spacing: 12,
            children: [
              const Text('🇸🇦'),
              const Text('العربية'),
              if (currentLanguage == 'ar')
                const Icon(
                  Icons.check,
                  color: PremiumColors.successGreen,
                ),
            ],
          ),
        ),
      ],
      child: IconButton(
        icon: Text(
          currentLanguage.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        onPressed: null,
        tooltip: currentLanguage == 'ar' ? 'تبديل اللغة' : 'Change Language',
      ),
    );
  }
}

/// Language Info Dialog - حوار معلومات اللغة
class LanguageInfoDialog extends StatelessWidget {
  final String currentLanguage;
  final VoidCallback onClose;

  const LanguageInfoDialog({
    super.key,
    required this.currentLanguage,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = currentLanguage == 'ar';

    return AlertDialog(
      title: Text(
        isArabic ? 'معلومات اللغة' : 'Language Information',
        textAlign: isArabic ? TextAlign.right : TextAlign.left,
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          _InfoRow(
            label: isArabic ? 'اللغة الحالية' : 'Current Language',
            value: isArabic ? 'العربية' : 'English',
            isArabic: isArabic,
          ),
          _InfoRow(
            label: isArabic ? 'الاتجاه' : 'Direction',
            value: isArabic ? 'يمين لـ يسار' : 'Left to Right',
            isArabic: isArabic,
          ),
          _InfoRow(
            label: isArabic ? 'الرمز' : 'Code',
            value: currentLanguage.toUpperCase(),
            isArabic: isArabic,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onClose,
          child: Text(isArabic ? 'حسناً' : 'OK'),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isArabic;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Text(
          value,
          style: TextStyle(
            color: PremiumColors.primaryBlue,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
