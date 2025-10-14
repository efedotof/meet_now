import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'first_open_app_interface.dart';

class FirstOpenAppRepository implements FirstOpenAppInterface {
  final SharedPreferences _preferences;

  static const _isFirstOpenApp = 'first_open_app';

  FirstOpenAppRepository({required SharedPreferences preferences})
    : _preferences = preferences;

  @override
  bool isFirstOpenApp() {
    final value = _preferences.getBool(_isFirstOpenApp) ?? true;
    log(
      '🚀 Первая установка приложения: $value',
      name: 'FirstOpenAppRepository',
    );
    return value;
  }

  @override
  Future<void> setValue({required bool value}) async {
    await _preferences.setBool(_isFirstOpenApp, value);
    log(
      '✅ Значение first_open_app установлено: $value',
      name: 'FirstOpenAppRepository',
    );
  }
}
