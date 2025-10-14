import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'language_storage_interface.dart';

class LanguageStorageRepository implements LanguageStorageInterface {
  final SharedPreferences _preferences;

  LanguageStorageRepository({required SharedPreferences preferences})
    : _preferences = preferences;

  static const _isLocale = 'locale';

  @override
  String isLocale() {
    final locale = _preferences.getString(_isLocale) ?? 'ru';
    log('🌐 Текущая локаль: $locale', name: 'LanguageStorageRepository');
    return locale;
  }

  @override
  Future<void> setLocale(String local) async {
    await _preferences.setString(_isLocale, local);
    log('✅ Локаль установлена: $local', name: 'LanguageStorageRepository');
  }
}
