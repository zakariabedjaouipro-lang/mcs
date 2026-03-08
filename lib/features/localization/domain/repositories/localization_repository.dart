/// Localization Repository Interface
library;

/// Abstract repository for localization/language management
abstract class LocalizationRepository {
  /// Load language preference from local storage
  Future<String> loadLanguage();

  /// Save language preference to local storage
  Future<void> saveLanguage(String languageCode);

  /// Get current language code
  String getCurrentLanguageCode();
}
