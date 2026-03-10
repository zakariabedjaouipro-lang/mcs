/// BuildContext extension for safe localization.
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/localization/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  /// Short alias for translating keys.
  /// Returns translated string or the key if translation not found.
  String tr(String key) {
    return AppLocalizations.of(this)?.translate(key) ?? key;
  }

  /// Alias for tr() - alternative naming.
  String translate(String key) => tr(key);

  /// Safe translation - returns key if context or translation is null.
  String trSafe(String key) {
    try {
      return AppLocalizations.of(this)?.translate(key) ?? key;
    } catch (_) {
      return key;
    }
  }

  /// Safe translation - returns key if context or translation is null.
  /// This is an alias for trSafe() for consistency with AppLocalizations naming.
  String translateSafe(String key) => trSafe(key);
}
