import 'dart:convert';
import 'dart:developer';

import 'package:meet_now_app/server/model/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user_storage_interface.dart';

class UserStorageRepository implements UserStorageInterface {
  static const _userKey = 'user_data';
  final SharedPreferences preferences;

  UserStorageRepository({required this.preferences});

  @override
  Future<void> saveUser(User user) async {
    try {
      final jsonString = jsonEncode(user.toJson());
      await preferences.setString(_userKey, jsonString);
      log(
        '✅ User saved successfully: ${user.username}',
        name: 'UserStorageRepository',
      );
    } catch (e, s) {
      log(
        '❌ Failed to save user: $e',
        name: 'UserStorageRepository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  @override
  Future<User?> getUser() async {
    try {
      final jsonString = preferences.getString(_userKey);
      if (jsonString == null) {
        log('ℹ️ No saved user found', name: 'UserStorageRepository');
        return null;
      }

      final jsonMap = jsonDecode(jsonString);
      final user = User.fromJson(jsonMap);
      log(
        '✅ User loaded successfully: ${user.username}',
        name: 'UserStorageRepository',
      );
      return user;
    } catch (e, s) {
      log(
        '❌ Failed to load user: $e',
        name: 'UserStorageRepository',
        error: e,
        stackTrace: s,
      );
      return null;
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      await preferences.remove(_userKey);
      log('🗑️ User data cleared successfully', name: 'UserStorageRepository');
    } catch (e, s) {
      log(
        '❌ Failed to clear user data: $e',
        name: 'UserStorageRepository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }
}
