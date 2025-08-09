import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/storage/language/language_storage_interface.dart';

part 'language_state.dart';
part 'language_cubit.freezed.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit({required LanguageStorageInterface languageStorageInterface})
    : _languageStorageInterface = languageStorageInterface,
      super(LanguageState.initial()) {
    _loadCurrentLanguage();
  }

  final LanguageStorageInterface _languageStorageInterface;

  Future<void> _loadCurrentLanguage() async {
    try {
      final localeCode = _languageStorageInterface.isLocale();
      final supportedLocales = S.delegate.supportedLocales;
      Locale currentLocale;

      if (localeCode.isNotEmpty) {
        currentLocale = Locale(localeCode);
      } else {
        currentLocale = supportedLocales.first;
        await _languageStorageInterface.setLocale(currentLocale.languageCode);
      }

      emit(
        LanguageState.loaded(
          currentLocale: currentLocale,
          supportedLocales: supportedLocales,
        ),
      );
    } catch (e) {
      emit(LanguageState.error('Failed to load language: $e'));
    }
  }

  Future<void> changeLanguage(Locale newLocale) async {
    final state = this.state;
    if (state is! _Loaded) return;

    try {
      await _languageStorageInterface.setLocale(newLocale.languageCode);
      emit(state.copyWith(currentLocale: newLocale));
    } catch (e) {
      emit(LanguageState.error('Failed to change language: $e'));
    }
  }

  String checkLocale() {
    final locale = _languageStorageInterface.isLocale();
    return locale;
  }
}
