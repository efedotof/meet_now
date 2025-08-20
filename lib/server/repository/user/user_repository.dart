import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meet_now_app/config.dart';
import 'package:meet_now_app/server/model/user/user.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';
import 'package:meet_now_app/storage/password/password_storage_interface.dart';
import 'package:meet_now_app/storage/user/user_storage_interface.dart';

import 'user_interface.dart';

class UserRepository implements UserInterface {
  final UserModelAppInterface userModelAppInterface;
  final Dio _dio;
  final PasswordStorageInterface passwordStorageInterface;
  final UserStorageInterface userStorageInterface;

  UserRepository({
    required this.userModelAppInterface,
    required this.passwordStorageInterface,
    required this.userStorageInterface,
  }) : _dio = Dio(
         BaseOptions(baseUrl: userAddress, contentType: 'application/json'),
       );

  void _setAuthHeader() {
    final token = userModelAppInterface.user?.token;
    if (token == null || token.isEmpty) {
      throw Exception('Отсутствует токен авторизации');
    }
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  String _getUserId() {
    final uuid = userModelAppInterface.user?.id;
    if (uuid == null || uuid.isEmpty) {
      throw Exception('Отсутствует id пользователя');
    }
    return uuid;
  }

  @override
  Future<User> getUser() async {
    _setAuthHeader();
    final uuid = _getUserId();
    final response = await _dio.get('/$uuid');

    if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
      final user = User.fromJson(response.data);
      userModelAppInterface.user = user;
      await userStorageInterface.saveUser(user);
      debugPrint("user: $user");
      return user;
    } else {
      throw Exception('Unexpected response: ${response.statusCode}');
    }
  }

  @override
  Future<void> patchUserAge({required int age}) async {
    _setAuthHeader();
    final uuid = _getUserId();
    await _dio.patch('/$uuid/age', data: {'age': age});
  }

  @override
  Future<void> patchUserAvatar({required String avatar}) async {
    _setAuthHeader();
    final uuid = _getUserId();
    await _dio.patch('/$uuid/avatar', data: {'avatar': avatar});
  }

  @override
  Future<void> patchUserCity({required String city}) async {
    _setAuthHeader();
    final uuid = _getUserId();
    await _dio.patch('/$uuid/city', data: {'city': city});
  }

  @override
  Future<void> patchUserDescripton({required String description}) async {
    _setAuthHeader();
    final uuid = _getUserId();
    await _dio.patch('/$uuid/description', data: {'description': description});
  }

  @override
  Future<void> patchUserEmail({required String email}) async {
    _setAuthHeader();
    final uuid = _getUserId();
    await _dio.patch('/$uuid/email', data: {'email': email});
  }

  @override
  Future<void> patchUserOnline({
    required bool isOnline,
    required String token,
    required String uuid,
  }) async {
    final Dio dios = Dio(
      BaseOptions(baseUrl: userAddress, contentType: 'application/json'),
    );
    dios.options.headers['Authorization'] = 'Bearer $token';
    await dios.patch('/$uuid/online', queryParameters: {'isOnline': isOnline});
  }

  @override
  Future<void> patchUserPassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    _setAuthHeader();
    final uuid = _getUserId();
    await _dio.patch(
      '/user/$uuid/password',
      data: {'oldPassword': oldPassword, 'newPassword': newPassword},
    );
  }

  @override
  Future<void> patchUserPurposes({required User dto}) async {
    _setAuthHeader();
    final uuid = _getUserId();
    await _dio.patch('/$uuid/purposes', data: {'purposes': dto.purposes});
  }

  @override
  Future<void> patchUserSearchable({required bool isSearchable}) async {
    _setAuthHeader();
    final uuid = _getUserId();
    await _dio.patch('/$uuid/searchable', data: {'isSearchable': isSearchable});
  }

  @override
  Future<void> patchUserUsername({required String username}) async {
    _setAuthHeader();
    final uuid = _getUserId();
    await _dio.patch('/$uuid/username', data: {'username': username});
  }

  @override
  Future<void> putUserProfile() async {
    _setAuthHeader();
    final uuid = _getUserId();
    final user = userModelAppInterface.user;
    if (user == null) {
      throw Exception('Пользователь не найден для обновления профиля');
    }
    await _dio.put('/$uuid/profile', data: user.toJson());
  }

  @override
  Future<void> startSearch() async {
    try {
      _setAuthHeader();
      await _dio.post("/start-search");
    } catch (e) {
      debugPrint("Произошла ошибка старта поиска: $e");
    }
  }

  @override
  Future<void> stopSearch() async {
    try {
      _setAuthHeader();
      await _dio.post("/stop-search");
    } catch (e) {
      debugPrint("Произошла ошибка остановки поиска: $e");
    }
  }
}
