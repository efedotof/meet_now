part of 'language_cubit.dart';

@freezed
class LanguageState with _$LanguageState {
  const factory LanguageState.initial() = _Initial;
  const factory LanguageState.loaded({
    required Locale currentLocale,
    required List<Locale> supportedLocales,
  }) = _Loaded;
  const factory LanguageState.error(String message) = _Error;
}
