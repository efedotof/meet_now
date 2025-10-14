import 'dart:developer';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:meet_now_app/config.dart';
import 'package:meet_now_app/server/model/chat_constraint/chat_constraint.dart';
import 'package:meet_now_app/server/model/temporary/temporary_chat.dart';
import 'package:meet_now_app/server/model/user/user.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';
import 'package:meet_now_app/storage/token/token_interface.dart';
import 'chat_interface.dart';

class ChatRepository implements ChatInterface {
  final TokenInterface _tokenInterface;
  final UserModelAppInterface _userModelAppInterface;
  final Dio _dio;

  ChatRepository({
    required TokenInterface tokenInterface,
    required UserModelAppInterface userModelAppInterface,
  }) : _tokenInterface = tokenInterface,
       _userModelAppInterface = userModelAppInterface,
       _dio = Dio(
         BaseOptions(baseUrl: chatAddress, contentType: 'application/json'),
       );

  void _setAuthHeader() {
    final token = _tokenInterface.getToken();
    if (token == "" || token.isEmpty) {
      log('❌ Отсутствует токен авторизации', name: 'ChatRepository');
      throw Exception('Отсутствует токен авторизации');
    }
    _dio.options.headers['Authorization'] = 'Bearer $token';
    log('🔑 Токен авторизации установлен', name: 'ChatRepository');
  }

  @override
  Future<void> agreeTemporary({required TemporaryChat tempChat}) async {
    try {
      _setAuthHeader();
      final tempChatId = await _getTempChatId(chat: tempChat);
      final userId = _userModelAppInterface.user?.id;
      if (userId == null) throw Exception('Пользователь не авторизован');

      final response = await _dio.post(
        '/temporary/$tempChatId/agree',
        queryParameters: {'userId': userId},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log(
          '✅ Согласие на временный чат отправлено: $tempChatId',
          name: 'ChatRepository',
        );
      } else {
        throw Exception('Ошибка подтверждения согласия');
      }
    } catch (e, s) {
      log(
        '❌ Ошибка agreeTemporary: $e',
        name: 'ChatRepository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  @override
  Future<void> createTemporary({required User recipient}) async {
    try {
      _setAuthHeader();
      final senderId = _userModelAppInterface.user?.id;
      final recipientId = recipient.id;
      final durationMinutes = 10;
      if (senderId == null) throw Exception('Пользователь не авторизован');

      final response = await _dio.post(
        '/temporary',
        queryParameters: {
          'senderId': senderId,
          'recipientId': recipientId,
          'durationMinutes': durationMinutes,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log(
          '✅ Временный чат создан между $senderId и $recipientId',
          name: 'ChatRepository',
        );
      } else {
        throw Exception('Ошибка создания временного чата');
      }
    } catch (e, s) {
      log(
        '❌ Ошибка createTemporary: $e',
        name: 'ChatRepository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  @override
  Future<void> finistTemporaryChat({required TemporaryChat tempChat}) async {
    try {
      _setAuthHeader();
      final tempChatId = await _getTempChatId(chat: tempChat);

      final response = await _dio.post('/temporary/$tempChatId/finish');

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('✅ Временный чат завершён: $tempChatId', name: 'ChatRepository');
      } else {
        throw Exception('Ошибка завершения временного чата');
      }
    } catch (e, s) {
      log(
        '❌ Ошибка finistTemporaryChat: $e',
        name: 'ChatRepository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  @override
  Future<ChatConstraint> getConstraint({
    required TemporaryChat tempChat,
  }) async {
    try {
      _setAuthHeader();
      final tempChatId = await _getTempChatId(chat: tempChat);

      final response = await _dio.get('/temporary/$tempChatId/constraint');
      if (response.statusCode == 200) {
        log(
          '✅ Ограничения временного чата получены: $tempChatId',
          name: 'ChatRepository',
        );
        return ChatConstraint.fromJson(response.data);
      } else {
        throw Exception(
          'Ошибка получения ограничений временного чата: ${response.statusCode}',
        );
      }
    } catch (e, s) {
      log(
        '❌ Ошибка getConstraint: $e',
        name: 'ChatRepository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  @override
  Future<void> updateConstraint({required TemporaryChat tempChat}) async {
    try {
      _setAuthHeader();
      final tempChatId = await _getTempChatId(chat: tempChat);
      final canStart = true;
      final waitSeconds = 10;

      final response = await _dio.put(
        '/temporary/$tempChatId/constraint',
        queryParameters: {'canStart': canStart, 'waitSeconds': waitSeconds},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        log(
          '✅ Ограничения временного чата обновлены: $tempChatId',
          name: 'ChatRepository',
        );
      } else {
        throw Exception('Ошибка обновления ограничений временного чата');
      }
    } catch (e, s) {
      log(
        '❌ Ошибка updateConstraint: $e',
        name: 'ChatRepository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  Future<String> _getTempChatId({required TemporaryChat chat}) async {
    final user = _userModelAppInterface.user;
    if (user == null) {
      log(
        '❌ Пользователь не авторизован при получении tempChatId',
        name: 'ChatRepository',
      );
      throw Exception('Пользователь не авторизован');
    }
    return chat.tempChatId;
  }
}
