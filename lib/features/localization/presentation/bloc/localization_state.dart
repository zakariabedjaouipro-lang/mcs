/// Localization State - All localization-related states
library;

import 'package:equatable/equatable.dart';

/// Base class for all localization states
abstract class LocalizationState extends Equatable {
  const LocalizationState();

  @override
  List<Object?> get props => [];
}

/// Initial localization state
class LocalizationInitial extends LocalizationState {
  const LocalizationInitial();
}

/// Localization loading state
class LocalizationLoading extends LocalizationState {
  const LocalizationLoading();
}

/// Language changed successfully
class LanguageChanged extends LocalizationState {
  const LanguageChanged(this.languageCode);
  final String languageCode; // 'ar' or 'en'

  @override
  List<Object?> get props => [languageCode];
}

/// Language changed to Arabic
class LanguageArabicState extends LocalizationState {
  const LanguageArabicState();
}

/// Language changed to English
class LanguageEnglishState extends LocalizationState {
  const LanguageEnglishState();
}

/// Localization error state
class LocalizationError extends LocalizationState {
  const LocalizationError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
