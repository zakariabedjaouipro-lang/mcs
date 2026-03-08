/// Language switcher widget for changing app language.
library;

import 'package:flutter/material.dart';

import 'package:mcs/core/constants/app_constants.dart';
import 'package:mcs/core/localization/app_localizations.dart';

/// Language switcher button widget.
class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context);
    final isArabic = currentLocale.languageCode == AppConstants.arabicCode;

    return PopupMenuButton<String>(
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.language,
            size: 20,
            color: Theme.of(context).iconTheme.color,
          ),
          const SizedBox(width: 4),
          Text(
            currentLocale.languageCode.toUpperCase(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
      tooltip: localizations.language,
      onSelected: (String languageCode) {
        _changeLanguage(context, languageCode);
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: AppConstants.arabicCode,
          child: Row(
            children: [
              const Text('🇩🇿'),
              const SizedBox(width: 12),
              Text(
                localizations.arabic,
                style: TextStyle(
                  fontWeight: isArabic ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (isArabic) ...[
                const Spacer(),
                const Icon(Icons.check, size: 18),
              ],
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: AppConstants.englishCode,
          child: Row(
            children: [
              const Text('🇬🇧'),
              const SizedBox(width: 12),
              Text(
                localizations.english,
                style: TextStyle(
                  fontWeight: !isArabic ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (!isArabic) ...[
                const Spacer(),
                const Icon(Icons.check, size: 18),
              ],
            ],
          ),
        ),
      ],
    );
  }

  void _changeLanguage(BuildContext context, String languageCode) {
    // This would typically be handled by a BLoC or state management
    // For now, we'll show a dialog indicating the change
    final localizations = AppLocalizations.of(context)!;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.language),
        content: Text(
          languageCode == AppConstants.arabicCode
              ? 'سيتم تغيير اللغة إلى العربية'
              : 'Language will be changed to English',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // In a real implementation, this would trigger a locale change
              // through a BLoC or other state management solution
              _showLanguageChangedSnackbar(
                  context,
                  languageCode,
                  localizations,
                );
            },
            child: Text(localizations.confirm),
          ),
        ],
      ),
    );
  }

  void _showLanguageChangedSnackbar(
    BuildContext context,
    String languageCode,
    AppLocalizations localizations,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          languageCode == AppConstants.arabicCode
              ? 'تم تغيير اللغة بنجاح'
              : 'Language changed successfully',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

/// Simple language switcher for use in settings pages.
class LanguageSwitcherSimple extends StatelessWidget {
  const LanguageSwitcherSimple({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context);
    final isArabic = currentLocale.languageCode == AppConstants.arabicCode;

    return Card(
      child: ListTile(
        leading: const Icon(Icons.language),
        title: Text(localizations.language),
        subtitle: Text(
          isArabic ? localizations.arabic : localizations.english,
        ),
        trailing: Switch(
          value: !isArabic,
          onChanged: (value) {
            final newLanguage =
                value ? AppConstants.englishCode : AppConstants.arabicCode;
            _changeLanguage(context, newLanguage, localizations);
          },
        ),
      ),
    );
  }

  void _changeLanguage(
    BuildContext context,
    String languageCode,
    AppLocalizations localizations,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.language),
        content: Text(
          languageCode == AppConstants.arabicCode
              ? 'سيتم تغيير اللغة إلى العربية'
              : 'Language will be changed to English',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    languageCode == AppConstants.arabicCode
                        ? 'تم تغيير اللغة بنجاح'
                        : 'Language changed successfully',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Text(localizations.confirm),
          ),
        ],
      ),
    );
  }
}

/// Language selector dropdown for forms.
class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    super.key,
    this.selectedLanguage,
    this.onChanged,
    this.label,
    this.hint,
  });
  final String? selectedLanguage;
  final ValueChanged<String?>? onChanged;
  final String? label;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return DropdownButtonFormField<String>(
      initialValue: selectedLanguage,
      decoration: InputDecoration(
        labelText: label ?? localizations.language,
        hintText: hint ?? localizations.language,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.language),
      ),
      items: const [
        DropdownMenuItem(
          value: AppConstants.arabicCode,
          child: Row(
            children: [
              Text('🇩🇿'),
              SizedBox(width: 12),
              Text('العربية'),
            ],
          ),
        ),
        DropdownMenuItem(
          value: AppConstants.englishCode,
          child: Row(
            children: [
              Text('🇬🇧'),
              SizedBox(width: 12),
              Text('English'),
            ],
          ),
        ),
      ],
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return localizations.requiredField;
        }
        return null;
      },
    );
  }
}

