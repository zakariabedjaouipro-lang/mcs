/// Localization Event - All language/localization events
library;

import 'package:equatable/equatable.dart';

/// Base class for all localization events
abstract class LocalizationEvent extends Equatable {
  const LocalizationEvent();

  @override
  List<Object?> get props => [];
}

/// Toggle between Arabic and English
class ToggleLanguageEvent extends LocalizationEvent {
  const ToggleLanguageEvent();
}

/// Set specific language
class SetLanguageEvent extends LocalizationEvent {
  const SetLanguageEvent(this.languageCode);
  final String languageCode; // 'ar' or 'en'

  @override
  List<Object?> get props => [languageCode];
}

/// Load saved language preference from storage
class LoadLanguageEvent extends LocalizationEvent {
  const LoadLanguageEvent();
}
