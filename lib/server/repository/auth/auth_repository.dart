import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:meet_now_app/config.dart';
import 'package:meet_now_app/server/model/login/login.dart';
import 'package:meet_now_app/server/model/registration/registration.dart';
import 'package:meet_now_app/server/model/user/user.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';
import 'package:meet_now_app/storage/password/password_storage_interface.dart';
import 'package:meet_now_app/storage/token/token_interface.dart';
import 'package:meet_now_app/storage/user/user_storage_interface.dart';
import 'auth_interface.dart';

class AuthRepository implements AuthInterface {
  final Dio _dio = Dio(BaseOptions(baseUrl: authAddress));
  final PasswordStorageInterface _passwordStorageInterface;
  final UserModelAppInterface _userModelAppInterface;
  final UserStorageInterface _userStorageInterface;
  final TokenInterface _tokenInterface;
  AuthRepository({
    required TokenInterface tokenInterface,
    required PasswordStorageInterface passwordStorageInterface,
    required UserModelAppInterface userModelAppInterface,
    required UserStorageInterface userStorageInterface,
  }) : _tokenInterface = tokenInterface,
       _userStorageInterface = userStorageInterface,
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
        if (user.token == null) {
          throw Exception("Данные о токене пустые");
        }
        await _tokenInterface.saveToken(user.token!);
        log('✅ Пользователь вошёл: ${user.username}', name: 'AuthRepository');
        return user;
      } else {
        throw Exception('Unexpected response: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log(
        '❌ Ошибка Dio при входе: ${e.message}',
        name: 'AuthRepository',
        error: e,
      );
      throw Exception('Login failed: ${e.response?.data ?? e.message}');
    } catch (e, s) {
      log(
        '❌ Неизвестная ошибка при входе: $e',
        name: 'AuthRepository',
        error: e,
        stackTrace: s,
      );
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
        log(
          '✅ Пользователь зарегистрирован: ${user.username}',
          name: 'AuthRepository',
        );

        if (user.token == null) {
          throw Exception("Данные о токене пустые");
        }
        await _tokenInterface.saveToken(user.token!);

        return user;
      } else {
        throw Exception('Unexpected response: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log(
        '❌ Ошибка Dio при регистрации: ${e.message}',
        name: 'AuthRepository',
        error: e,
      );
      throw Exception('Registration failed: ${e.response?.data ?? e.message}');
    } catch (e, s) {
      log(
        '❌ Неизвестная ошибка при регистрации: $e',
        name: 'AuthRepository',
        error: e,
        stackTrace: s,
      );
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<User?> autoLogin() async {
    User? user;
    String password = '';

    try {
      user = await _userStorageInterface.getUser();
      password = _passwordStorageInterface.getPassword();
      final token = _tokenInterface.getToken();
      log("token:$token", name: "Auto Login");
      log("User: $user", name: "Auto Login");

      if (user == null ||
          user.id.isEmpty ||
          password.isEmpty ||
          token == "" ||
          token.isEmpty) {
        throw Exception('Отсутствует токен, пароль, пользователь или его ID');
      }

      try {
        final response = await _dio.get(
          tokenValidation,
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

        if (response.statusCode == 200) {
          _userModelAppInterface.user = user;
          log(
            '✅ AutoLogin успешен для пользователя: ${user.username}',
            name: 'AuthRepository',
          );
          return user;
        }
      } on DioException catch (dioError) {
        if (dioError.response?.statusCode == 401) {
          final loginData = Login(username: user.username, password: password);
          return await login(login: loginData);
        } else {
          rethrow;
        }
      }

      throw Exception('Unexpected status code');
    } catch (e, s) {
      log(
        '❌ AutoLogin ошибка: $e',
        name: 'AuthRepository',
        error: e,
        stackTrace: s,
      );
      return null;
    }
  }
}
