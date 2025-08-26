import 'package:shared_preferences/shared_preferences.dart';

import 'first_open_app_interface.dart';

class FirstOpenAppRepository implements FirstOpenAppInterface {
  final SharedPreferences _preferences;

  static const _isFirstOpenApp = 'first_open_app';

  FirstOpenAppRepository({required SharedPreferences preferences})
    : _preferences = preferences;

  @override
  bool isFirstOpenApp() {
    return _preferences.getBool(_isFirstOpenApp) ?? true;
  }

  @override
  Future<void> setValue({required bool value}) async {
    await _preferences.setBool(_isFirstOpenApp, value);
  }
}
