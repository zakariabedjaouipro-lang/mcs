/// Localization BLoC - Manages language/localization state
library;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/features/localization/domain/repositories/localization_repository.dart';
import 'package:mcs/features/localization/presentation/bloc/localization_event.dart';
import 'package:mcs/features/localization/presentation/bloc/localization_state.dart';

/// BLoC for localization/language management
class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  LocalizationBloc({required LocalizationRepository localizationRepository})
      : _localizationRepository = localizationRepository,
        super(const LocalizationInitial()) {
    on<ToggleLanguageEvent>(_onToggleLanguage);
    on<SetLanguageEvent>(_onSetLanguage);
    on<LoadLanguageEvent>(_onLoadLanguage);
  }

  final LocalizationRepository _localizationRepository;

  /// Get current language code
  String get currentLanguageCode =>
      _localizationRepository.getCurrentLanguageCode();

  /// Handle toggle language
  Future<void> _onToggleLanguage(
    ToggleLanguageEvent event,
    Emitter<LocalizationState> emit,
  ) async {
    emit(const LocalizationLoading());
    try {
      final newLanguage = currentLanguageCode == 'ar' ? 'en' : 'ar';

      await _localizationRepository.saveLanguage(newLanguage);
      emit(LanguageChanged(newLanguage));

      if (newLanguage == 'ar') {
        emit(const LanguageArabicState());
      } else {
        emit(const LanguageEnglishState());
      }
    } catch (e) {
      emit(LocalizationError('فشل تغيير اللغة: ${e.toString()}'));
    }
  }

  /// Handle set language
  Future<void> _onSetLanguage(
    SetLanguageEvent event,
    Emitter<LocalizationState> emit,
  ) async {
    emit(const LocalizationLoading());
    try {
      // Validate language code
      if (!['ar', 'en'].contains(event.languageCode)) {
        emit(LocalizationError('لغة غير مدعومة: ${event.languageCode}'));
        return;
      }

      await _localizationRepository.saveLanguage(event.languageCode);
      emit(LanguageChanged(event.languageCode));

      if (event.languageCode == 'ar') {
        emit(const LanguageArabicState());
      } else {
        emit(const LanguageEnglishState());
      }
    } catch (e) {
      emit(LocalizationError('فشل حفظ اختيار اللغة: ${e.toString()}'));
    }
  }

  /// Handle load language
  Future<void> _onLoadLanguage(
    LoadLanguageEvent event,
    Emitter<LocalizationState> emit,
  ) async {
    emit(const LocalizationLoading());
    try {
      final savedLanguage = await _localizationRepository.loadLanguage();
      emit(LanguageChanged(savedLanguage));

      if (savedLanguage == 'ar') {
        emit(const LanguageArabicState());
      } else {
        emit(const LanguageEnglishState());
      }
    } catch (e) {
      emit(LocalizationError('فشل تحميل اللغة: ${e.toString()}'));
    }
  }
}
