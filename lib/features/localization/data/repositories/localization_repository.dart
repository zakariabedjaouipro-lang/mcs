/// Localization Repository Implementation
library;

import 'package:mcs/features/localization/data/datasources/localization_local_data_source.dart';
import 'package:mcs/features/localization/domain/repositories/localization_repository.dart';

/// Implementation of localization repository
class LocalizationRepositoryImpl extends LocalizationRepository {
  LocalizationRepositoryImpl(this._localDataSource);

  final LocalizationLocalDataSource _localDataSource;
  late String _currentLanguageCode;

  /// Load language preference from local storage
  @override
  Future<String> loadLanguage() async {
    _currentLanguageCode = await _localDataSource.loadLanguage();
    return _currentLanguageCode;
  }

  /// Save language preference to local storage
  @override
  Future<void> saveLanguage(String languageCode) async {
    _currentLanguageCode = languageCode;
    await _localDataSource.saveLanguage(languageCode);
  }

  /// Get current language code
  @override
  String getCurrentLanguageCode() => _currentLanguageCode;
}
