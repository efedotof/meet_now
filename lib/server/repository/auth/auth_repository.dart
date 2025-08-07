import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:meet_now_app/config.dart';
import 'package:meet_now_app/server/model/login/login.dart';
import 'package:meet_now_app/server/model/registration/registration.dart';
import 'package:meet_now_app/server/model/user/user.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';
import 'package:meet_now_app/storage/password/password_storage_interface.dart';
import 'package:meet_now_app/storage/user/user_storage_interface.dart';
import 'auth_interface.dart';

class AuthRepository implements AuthInterface {
  final Dio _dio = Dio(BaseOptions(baseUrl: authAddress));
  final PasswordStorageInterface _passwordStorageInterface;
  final UserModelAppInterface _userModelAppInterface;
  final UserStorageInterface _userStorageInterface;
  AuthRepository({
    required PasswordStorageInterface passwordStorageInterface,
    required UserModelAppInterface userModelAppInterface,
    required UserStorageInterface userStorageInterface,
  }) : _userStorageInterface = userStorageInterface,
       _userModelAppInterface = userModelAppInterface,
       _passwordStorageInterface = passwordStorageInterface;

  @override
  Future<User> login({required Login login}) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {"username": login.username, "password": login.password},
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final user = User.fromJson(response.data);

        _passwordStorageInterface.setPassword(password: login.password);
        _userModelAppInterface.user = user;
        await _userStorageInterface.saveUser(user);
        return user;
      } else {
        throw Exception('Unexpected response: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint("Dio error during login: ${e.message}");
      throw Exception('Login failed: ${e.response?.data ?? e.message}');
    } catch (e) {
      debugPrint("Unknown error during login: $e");
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<User> registration({required Registration registration}) async {
    try {
      final response = await _dio.post(
        '/register',
        data: {
          "username": registration.username,
          "email": registration.email,
          "firstname": registration.firstname,
          "subname": registration.subname,
          "description": registration.description,
          "avatar": registration.avatar,
          "city": registration.city,
          "age": registration.age,
          "purposes": registration.purposes,
          "interests": registration.interests,
          "isSearchable": registration.isSearchable,
          "password": registration.password,
          "floor": registration.floor,
        },
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final user = User.fromJson(response.data);

        _passwordStorageInterface.setPassword(password: registration.password);
        _userModelAppInterface.user = user;
        await _userStorageInterface.saveUser(user);
        return user;
      } else {
        throw Exception('Unexpected response: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint("Dio error during registration: ${e.message}");
      throw Exception('Registration failed: ${e.response?.data ?? e.message}');
    } catch (e) {
      debugPrint("Unknown error during registration: $e");
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<User?> autoLogin() async {
    try {
      final user = await _userStorageInterface.getUser();
      final password = _passwordStorageInterface.getPassword();

      if (user == null ||
          user.id.isEmpty ||
          password.isEmpty ||
          user.token == null ||
          user.token!.isEmpty) {
        throw Exception('Отсутствует токен, пароль, пользователь или его ID');
      }

      final token = user.token!;

      final response = await _dio.get(tokenValidation, options: Options(headers: {'Authorization':'Bearer $token'}));

      if (response.statusCode == 200) {
        _userModelAppInterface.user = user;
        return user;
      }

      final loginData = Login(username: user.username, password: password);
      return await login(login: loginData);
    } catch (e, stackTrace) {
      debugPrint('AutoLogin error: $e');
      debugPrint('$stackTrace');
      return null;
    }
  }
}
