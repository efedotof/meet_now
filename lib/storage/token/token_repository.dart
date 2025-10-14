import 'package:shared_preferences/shared_preferences.dart';

import 'token_interface.dart';

class TokenRepository implements TokenInterface {
  static const _tokenKey = 'token_data';
  final SharedPreferences preferences;
  TokenRepository({required this.preferences});

  @override
  Future<void> clearToken() async {
    await preferences.remove(_tokenKey);
  }

  @override
  String getToken() {
    return preferences.getString(_tokenKey) ?? "";
  }

  @override
  Future<void> saveToken(String token) async {
    await preferences.setString(_tokenKey, token);
  }
}
