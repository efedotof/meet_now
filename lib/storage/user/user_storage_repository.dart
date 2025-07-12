import 'dart:convert';

import 'package:meet_now_app/server/model/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user_storage_interface.dart';

class UserStorageRepository implements UserStorageInterface {
  static const _userKey = 'user_data';
  final SharedPreferences preferences;

  UserStorageRepository({required this.preferences});

  @override
  Future<void> saveUser(User user) async {
    final jsonString = jsonEncode(user.toJson());
    await preferences.setString(_userKey, jsonString);
  }

  @override
  Future<User?> getUser() async {
    final jsonString = preferences.getString(_userKey);
    if (jsonString == null) return null;
    final jsonMap = jsonDecode(jsonString);
    return User.fromJson(jsonMap);
  }

  @override
  Future<void> clearUser() async {
    await preferences.remove(_userKey);
  }
}
