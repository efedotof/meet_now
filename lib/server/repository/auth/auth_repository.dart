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
  final PasswordStorageInterface passwordStorageInterface;
  final UserModelAppInterface userModelAppInterface;
  final UserStorageInterface userStorageInterface;
  AuthRepository({
    required this.passwordStorageInterface,
    required this.userModelAppInterface,
    required this.userStorageInterface,
  });

  @override
  Future<User> login({required Login login}) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {"username": login.username, "password": login.password},
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final user = User.fromJson(response.data);

        passwordStorageInterface.setPassword(password: login.password);
        userModelAppInterface.user = user;
        await userStorageInterface.saveUser(user);
        debugPrint("userToken: ${user.token}");
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

        passwordStorageInterface.setPassword(password: registration.password);
        userModelAppInterface.user = user;
        await userStorageInterface.saveUser(user);
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
}
