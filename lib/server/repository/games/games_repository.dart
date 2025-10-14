import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:meet_now_app/config.dart';
import 'package:meet_now_app/server/model/chat_game/chat_game.dart';
import 'package:meet_now_app/server/model/game_response/game_response.dart';
import 'package:meet_now_app/storage/token/token_interface.dart';
import 'games_interface.dart';

class GamesRepository implements GamesInterface {
  final TokenInterface _tokenInterface;
  final Dio _dio;

  GamesRepository({required TokenInterface tokenInterface})
    : _tokenInterface = tokenInterface,
      _dio = Dio(
        BaseOptions(
          baseUrl: gamesAddress,
          contentType: 'application/json',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

  void _setAuthHeader() {
    final token = _tokenInterface.getToken();
    if (token == "" || token.isEmpty) {
      log('❌ Отсутствует токен авторизации', name: 'GamesRepository');
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
        "chatId": chatId ?? "",
        "gameType": gameType,
        "initialState": "string",
      };
      final response = await _dio.post('', data: data);
      if (response.statusCode == 200) {
        log('✅ Игра добавлена: $gameType', name: 'GamesRepository');
      }
    } catch (e, s) {
      log(
        '❌ Ошибка addGame: $e',
        name: 'GamesRepository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  @override
  Future<List<GameResponse>> getAllGame() async {
    try {
      _setAuthHeader();
      final response = await _dio.get('/list');
      if (response.statusCode == 200) {
        final games =
            (response.data as List)
                .map((e) => GameResponse.fromJson(e as Map<String, dynamic>))
                .toList();
        log('✅ Получено ${games.length} игр', name: 'GamesRepository');
        return games;
      } else {
        throw Exception('Произошла ошибка во время получения игр');
      }
    } catch (e, s) {
      log(
        '❌ Ошибка getAllGame: $e',
        name: 'GamesRepository',
        error: e,
        stackTrace: s,
      );
      rethrow;
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
        final games =
            (response.data as List)
                .map((e) => ChatGame.fromJson(e as Map<String, dynamic>))
                .toList();
        log(
          '✅ Получено ${games.length} игр для chatId: $chatId',
          name: 'GamesRepository',
        );
        return games;
      } else {
        throw Exception('Произошла ошибка получения игр в chatID');
      }
    } catch (e, s) {
      log(
        '❌ Ошибка getGamesByChatIdOrAllGames: $e',
        name: 'GamesRepository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  @override
  Future<String?> getUrlGameByType({required String gameType}) async {
    try {
      _setAuthHeader();
      final response = await _dio.get('/url/$gameType');
      if (response.statusCode == 200) {
        log('✅ Получена ссылка на игру: $gameType', name: 'GamesRepository');
        return response.data as String?;
      } else {
        throw Exception('Ошибка получения ссылки на игру по типу');
      }
    } catch (e, s) {
      log(
        '❌ Ошибка getUrlGameByType: $e',
        name: 'GamesRepository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }
}
