import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meet_now_app/config.dart';
import 'package:meet_now_app/server/model/chat_game/chat_game.dart';
import 'package:meet_now_app/server/model/game_response/game_response.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';

import 'games_interface.dart';

class GamesRepository implements GamesInterface {
  final UserModelAppInterface userModelAppInterface;
  final Dio _dio;

  GamesRepository({required this.userModelAppInterface})
    : _dio = Dio(
        BaseOptions(baseUrl: gamesAddress, contentType: 'application/json'),
      );

  void _setAuthHeader() {
    final token = userModelAppInterface.user?.token;
    if (token == null || token.isEmpty) {
      throw Exception('Отсутствует токен авторизации');
    }
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  @override
  Future<void> addGame({
    required String gameType,
    required String? chatId,
  }) async {
    try {
      _setAuthHeader();

      final data = {
        "chatId": gameType,
        "gameType": gameType,
        "initialState": "string",
      };

      final response = await _dio.post('', data: data);

      if (response.statusCode == 200) {
        debugPrint("Игра добавлена!");
      }
    } catch (e) {
      debugPrint("Произошла ошибка: $e");
    }
  }

  @override
  Future<List<GameResponse>> getAllGame() async {
    try {
      _setAuthHeader();

      final response = await _dio.get('/list');

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((e) => GameResponse.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception("Произошла ошибка во время получени игр");
      }
    } catch (e) {
      debugPrint("Произошла ошибка получения всех игр: $e");
      return [];
    }
  }

  @override
  Future<List<ChatGame>> getGamesByChatIdOrAllGames({
    required String? chatId,
  }) async {
    try {
      _setAuthHeader();

      final response = await _dio.get("");
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((e) => ChatGame.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception("Произошла ошибка получения игр в chatID");
      }
    } catch (e) {
      debugPrint("Произошла ошибка: $e");
      return [];
    }
  }

  @override
  Future<String?> getUrlGameByType({required String gameType}) async {
    try {
      _setAuthHeader();

      final response = await _dio.get('/url/$gameType');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Ошибка получения ссылки на игру по типу");
      }
    } catch (e) {
      return null;
    }
  }
}
