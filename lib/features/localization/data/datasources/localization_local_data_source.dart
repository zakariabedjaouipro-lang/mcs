/// Localization Local Data Source
library;

import 'package:shared_preferences/shared_preferences.dart';

/// Data source for language/localization persistence
class LocalizationLocalDataSource {
  LocalizationLocalDataSource(this.sharedPreferences);

  final SharedPreferences sharedPreferences;
  static const String _languageKey = 'language_code';

  /// Load language from local storage
  Future<String> loadLanguage() async {
    final savedLanguage = sharedPreferences.getString(_languageKey);

    // Default to Arabic
    return savedLanguage ?? 'ar';
  }

  /// Save language to local storage
  Future<void> saveLanguage(String languageCode) async {
    await sharedPreferences.setString(_languageKey, languageCode);
  }
}
