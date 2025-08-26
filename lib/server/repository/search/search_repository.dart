import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meet_now_app/config.dart';
import 'package:meet_now_app/server/exception/users_not_found_exception.dart';
import 'package:meet_now_app/server/model/search/search_random_model.dart';
import 'package:meet_now_app/server/model/temporary/temporary_chat.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';

import 'search_interface.dart';

class SearchRepository implements SearchInterface {
  final UserModelAppInterface userModelAppInterface;
  final Dio _dio;

  SearchRepository({required this.userModelAppInterface})
    : _dio = Dio(
        BaseOptions(
          baseUrl: searchAddress,
          contentType: 'application/json',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

  @override
  Future<TemporaryChat> randomSearch({
    required SearchRandomModel request,
  }) async {
    final user = userModelAppInterface.user;
    if (user == null) {
      throw Exception('Ошибка: пользователь не авторизован');
    }

    final token = user.token;
    final userId = user.id;

    if (token == null || token.isEmpty) {
      throw Exception('Отсутствует токен авторизации');
    }

    if (userId.isEmpty) {
      throw Exception('Отсутствует ID пользователя');
    }

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/filtered',
        queryParameters: _buildQueryParams(request, userId),
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      debugPrint('Ответ от /filtered: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        return TemporaryChat.fromJson(response.data!);
      } else {
        throw _handleUnexpectedResponse(response);
      }
    } on DioException catch (e) {
      throw _handleDioError(e); 
    } catch (e) {
      throw Exception('Неизвестная ошибка: $e');
    }
  }

  Map<String, dynamic> _buildQueryParams(
    SearchRandomModel request,
    String userId,
  ) {
    final params = <String, dynamic>{
      'interests': request.interests,
      'purposes': request.purposes,
      'verified': request.verified,
      'ageStart': request.ageStart,
      'ageStop': request.ageStop,
      'city': request.city,
      'floor': request.floor,
    };

    params.removeWhere(
      (key, value) =>
          value == null ||
          (value is List && value.isEmpty) ||
          (value is String && value.isEmpty),
    );

    return params;
  }

  Exception _handleDioError(DioException e) {
    final response = e.response;
    if (response != null) {
      if (response.statusCode == 404) {
        return UsersNotFoundException();
      }
      return Exception(
        'Ошибка сервера ${response.statusCode}: ${response.data ?? e.message}',
      );
    }
    return Exception('Сетевая ошибка: ${e.message}');
  }

  Exception _handleUnexpectedResponse(Response<Map<String, dynamic>> response) {
    return Exception(
      'Неожиданный ответ ${response.statusCode}: ${response.data}',
    );
  }
}
