import 'package:meet_now_app/config.dart';
import 'package:meet_now_app/server/model/login/login.dart';
import 'package:meet_now_app/server/model/registration/registration.dart';
import 'package:meet_now_app/server/model/user/user.dart';
import 'auth_interface.dart';
import "package:dio/dio.dart";

class AuthRepository implements AuthInterface {
  final Dio _dio = Dio(BaseOptions(baseUrl: authAddress));

  @override
  Future<User> login({required Login login}) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {"username": login.username, "password": login.password},
      );

      return User.fromJson(response.data);
    } catch (e) {
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
          "descriptio": registration.descriptio,
          "avatar": registration.avatar,
          "city": registration.city,
          "age": registration.age,
          "purposes": registration.purposes,
          "interests": registration.interests,
          "isSearchable": registration.isSearchable,
          "password": registration.password,
        },
      );

      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }
}
