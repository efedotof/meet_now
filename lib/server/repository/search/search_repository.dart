import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meet_now_app/config.dart';
import 'package:meet_now_app/server/model/temporary/temporary_chat.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';

import 'search_interface.dart';

class SearchRepository implements SearchInterface {
  final UserModelAppInterface userModelAppInterface;
  SearchRepository({required this.userModelAppInterface});

  final Dio _dio = Dio(
    BaseOptions(baseUrl: searchAddress, contentType: 'application/json'),
  );

  @override
  Future<TemporaryChat> randomSearch() async {
    try {
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

      _dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await _dio.get(
        '/random',
        queryParameters: {'requesterId': userId},
      );

      debugPrint('Ответ от /random: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        return TemporaryChat.fromJson(response.data);
      } else {
        throw Exception(
          'Ошибка: неожиданный код ответа ${response.statusCode}, данные: ${response.data}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Ошибка при запросе /random: ${e.response?.statusCode} ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('Неизвестная ошибка: $e');
    }
  }
}
