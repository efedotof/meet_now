import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:meet_now_app/config.dart';
import 'package:meet_now_app/server/model/icebreaker_topec/icebreaker_topec.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';
import 'icebreaker_interface.dart';

class IcebreakerRepository implements IcebreakerInterface {
  final UserModelAppInterface userModelAppInterface;
  final Dio _dio;

  IcebreakerRepository({required this.userModelAppInterface})
    : _dio = Dio(
        BaseOptions(
          baseUrl: iceBreakerAddress,
          contentType: 'application/json',
        ),
      );

  void _setAuthHeader() {
    final token = userModelAppInterface.user?.token;
    if (token == null || token.isEmpty) {
      log('❌ Отсутствует токен авторизации', name: 'IcebreakerRepository');
      throw Exception('Отсутствует токен авторизации');
    }
    _dio.options.headers['Authorization'] = 'Bearer $token';
    log('🔑 Токен авторизации установлен', name: 'IcebreakerRepository');
  }

  @override
  Future<List<IcebreakerTopec>> textSearch({required String text}) async {
    try {
      _setAuthHeader();
      if (text.trim().isEmpty) {
        log('⚠️ Пустой текст для поиска', name: 'IcebreakerRepository');
        return [];
      }
      final response = await _dio.get(
        '/search',
        queryParameters: {'text': text},
      );
      if (response.statusCode == 200) {
        final list =
            (response.data as List)
                .map((e) => IcebreakerTopec.fromJson(e as Map<String, dynamic>))
                .toList();
        log(
          '✅ Найдено ${list.length} топиков по тексту: "$text"',
          name: 'IcebreakerRepository',
        );
        return list;
      } else {
        log(
          '❌ Ошибка поиска топиков, статус: ${response.statusCode}',
          name: 'IcebreakerRepository',
        );
        return [];
      }
    } catch (e, s) {
      log(
        '❌ Ошибка textSearch: $e',
        name: 'IcebreakerRepository',
        error: e,
        stackTrace: s,
      );
      return [];
    }
  }

  @override
  Future<List<IcebreakerTopec>> getAllIce() async {
    try {
      _setAuthHeader();
      final response = await _dio.get('/get_all_ice');
      if (response.statusCode == 200) {
        final list =
            (response.data as List)
                .map((e) => IcebreakerTopec.fromJson(e as Map<String, dynamic>))
                .toList();
        log(
          '✅ Получено ${list.length} всех топиков',
          name: 'IcebreakerRepository',
        );
        return list;
      } else {
        log(
          '❌ Ошибка получения всех топиков, статус: ${response.statusCode}',
          name: 'IcebreakerRepository',
        );
        return [];
      }
    } catch (e, s) {
      log(
        '❌ Ошибка getAllIce: $e',
        name: 'IcebreakerRepository',
        error: e,
        stackTrace: s,
      );
      return [];
    }
  }

  @override
  Future<IcebreakerTopec?> getRandomIce() async {
    try {
      _setAuthHeader();
      final response = await _dio.get('/random');
      if (response.statusCode == 200) {
        final data = IcebreakerTopec.fromJson(
          response.data as Map<String, dynamic>,
        );
        log('✅ Получен случайный топик', name: 'IcebreakerRepository');
        return data;
      } else {
        log(
          '❌ Ошибка получения случайного топика, статус: ${response.statusCode}',
          name: 'IcebreakerRepository',
        );
        return null;
      }
    } catch (e, s) {
      log(
        '❌ Ошибка getRandomIce: $e',
        name: 'IcebreakerRepository',
        error: e,
        stackTrace: s,
      );
      return null;
    }
  }
}
