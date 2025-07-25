import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
      throw Exception('Отсутствует токен авторизации');
    }
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  @override
  Future<List<IcebreakerTopec>> textSearch({required String text}) async {
    try {
      _setAuthHeader();
      if (text.trim().isEmpty) {
        debugPrint("Search text is empty");
        return [];
      }

      final response = await _dio.get(
        '/search',
        queryParameters: {'text': text},
      );
      if (response.statusCode == 200) {
        final data = response.data as List;
        return data
            .map((e) => IcebreakerTopec.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        debugPrint("Request failed with status: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      debugPrint("Unknown error: $e");
      return [];
    }
  }

  @override
  Future<List<IcebreakerTopec>> getAllIce() async {
    try {
      _setAuthHeader();
      final response = await _dio.get('/get_all_ice');
      if (response.statusCode == 200) {
        final data = response.data as List;
        return data
            .map((e) => IcebreakerTopec.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        debugPrint("Request failed with status: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      debugPrint("Unknown error: $e");
      return [];
    }
  }

  @override
  Future<IcebreakerTopec?> getRandomIce() async {
    try {
      _setAuthHeader();
      final response = await _dio.get('/random');
      if (response.statusCode == 200) {
        final data = response.data as IcebreakerTopec;
        return data;
      } else {
        debugPrint(
          "Request getRandomIce failed with status: ${response.statusCode}",
        );
        return null;
      }
    } catch (e) {
      debugPrint("Unknown error: $e");
      return null;
    }
  }
}
