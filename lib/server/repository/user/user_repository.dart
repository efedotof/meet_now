import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:meet_now_app/config.dart';
import 'package:meet_now_app/server/model/user/user.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';
import 'package:meet_now_app/storage/password/password_storage_interface.dart';
import 'package:meet_now_app/storage/token/token_interface.dart';
import 'package:meet_now_app/storage/user/user_storage_interface.dart';
import 'user_interface.dart';

class UserRepository implements UserInterface {
  final UserModelAppInterface userModelAppInterface;
  final Dio _dio;
  final PasswordStorageInterface passwordStorageInterface;
  final UserStorageInterface userStorageInterface;
  final TokenInterface tokenInterface;

  UserRepository({
    required this.tokenInterface,
    required this.userModelAppInterface,
    required this.passwordStorageInterface,
    required this.userStorageInterface,
  }) : _dio = Dio(
         BaseOptions(baseUrl: userAddress, contentType: 'application/json'),
       );

  void _setAuthHeader() {
    final token = tokenInterface.getToken();
    if (token == "" || token.isEmpty) {
      throw Exception('Отсутствует токен авторизации');
    }
    _dio.options.headers['Authorization'] = 'Bearer $token';
    log('Authorization header set', name: 'UserRepository');
  }

  String _getUserId() {
    final uuid = userModelAppInterface.user?.id;
    if (uuid == null || uuid.isEmpty) {
      throw Exception('Отсутствует id пользователя');
    }
    log('User ID: $uuid', name: 'UserRepository');
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
      log('Fetched user: $user', name: 'UserRepository');
      return user;
    } else {
      log(
        'Unexpected response status: ${response.statusCode}',
        name: 'UserRepository',
      );
      throw Exception('Unexpected response: ${response.statusCode}');
    }
  }

  @override
  Future<void> patchUserAge({required int age}) async {
    _setAuthHeader();
    final uuid = _getUserId();
    await _dio.patch('/$uuid/age', data: {'age': age});
    log('Updated user age: $age', name: 'UserRepository');
  }

  @override
  Future<void> patchUserAvatar({required String avatar}) async {
    _setAuthHeader();
    final uuid = _getUserId();
    await _dio.patch('/$uuid/avatar', data: {'avatar': avatar});
    log('Updated user avatar: $avatar', name: 'UserRepository');
  }

  @override
  Future<void> patchUserCity({required String city}) async {
    _setAuthHeader();
    final uuid = _getUserId();
    await _dio.patch('/$uuid/city', data: {'city': city});
    log('Updated user city: $city', name: 'UserRepository');
  }

  @override
  Future<void> patchUserDescripton({required String description}) async {
    _setAuthHeader();
    final uuid = _getUserId();
    await _dio.patch('/$uuid/description', data: {'description': description});
    log('Updated user description: $description', name: 'UserRepository');
  }

  @override
  Future<void> patchUserEmail({required String email}) async {
    _setAuthHeader();
    final uuid = _getUserId();
    await _dio.patch('/$uuid/email', data: {'email': email});
    log('Updated user email: $email', name: 'UserRepository');
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
    log('Updated user online: $isOnline', name: 'UserRepository');
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
    log('Updated user password', name: 'UserRepository');
  }

  @override
  Future<void> patchUserPurposes({required User dto}) async {
    _setAuthHeader();
    final uuid = _getUserId();
    await _dio.patch('/$uuid/purposes', data: {'purposes': dto.purposes});
    log('Updated user purposes: ${dto.purposes}', name: 'UserRepository');
  }

  @override
  Future<void> patchUserSearchable({required bool isSearchable}) async {
    _setAuthHeader();
    final uuid = _getUserId();
    await _dio.patch('/$uuid/searchable', data: {'isSearchable': isSearchable});
    log('Updated user searchable: $isSearchable', name: 'UserRepository');
  }

  @override
  Future<void> patchUserUsername({required String username}) async {
    _setAuthHeader();
    final uuid = _getUserId();
    await _dio.patch('/$uuid/username', data: {'username': username});
    log('Updated user username: $username', name: 'UserRepository');
  }

  @override
  Future<void> putUserProfile({required User user}) async {
    _setAuthHeader();
    final uuid = _getUserId();
    await _dio.put('/$uuid/profile', data: user.toJson());
    log('Updated full user profile: $user', name: 'UserRepository');
  }

  @override
  Future<void> startSearch() async {
    try {
      _setAuthHeader();
      await _dio.post("/start-search");
      log('Started search', name: 'UserRepository');
    } catch (e) {
      log('Error starting search: $e', name: 'UserRepository');
    }
  }

  @override
  Future<void> stopSearch() async {
    try {
      _setAuthHeader();
      await _dio.post("/stop-search");
      log('Stopped search', name: 'UserRepository');
    } catch (e) {
      log('Error stopping search: $e', name: 'UserRepository');
    }
  }
}
