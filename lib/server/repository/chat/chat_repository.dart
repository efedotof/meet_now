import 'dart:async';
import 'package:dio/dio.dart';
import 'package:meet_now_app/config.dart';
import 'package:meet_now_app/server/model/chat_constraint/chat_constraint.dart';
import 'package:meet_now_app/server/model/temporary/temporary_chat.dart';
import 'package:meet_now_app/server/model/user/user.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';

import 'chat_interface.dart';

class ChatRepository implements ChatInterface {
  final UserModelAppInterface userModelAppInterface;
  final Dio _dio;

  ChatRepository({required this.userModelAppInterface})
    : _dio = Dio(
        BaseOptions(baseUrl: chatAddress, contentType: 'application/json'),
      );

  void _setAuthHeader() {
    final token = userModelAppInterface.user?.token;
    if (token == null || token.isEmpty) {
      throw Exception('Отсутствует токен авторизации');
    }
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  @override
  Future<void> agreeTemporary({required TemporaryChat tempChat}) async {
    _setAuthHeader();
    final tempChatId = await _getTempChatId(chat: tempChat);
    final userId = userModelAppInterface.user?.id;

    if (userId == null) throw Exception('Пользователь не авторизован');

    final response = await _dio.post(
      '/temporary/$tempChatId/agree',
      queryParameters: {'userId': userId},
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Ошибка подтверждения согласия');
    }
  }

  @override
  Future<void> createTemporary({required User recipient}) async {
    _setAuthHeader();
    final senderId = userModelAppInterface.user?.id;
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

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Ошибка создания временного чата');
    }
  }

  @override
  Future<void> finistTemporaryChat({required TemporaryChat tempChat}) async {
    _setAuthHeader();
    final tempChatId = await _getTempChatId(chat: tempChat);

    final response = await _dio.post('/temporary/$tempChatId/finish');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Ошибка завершения временного чата');
    }
  }

  @override
  Future<ChatConstraint> getConstraint({
    required TemporaryChat tempChat,
  }) async {
    _setAuthHeader();
    final tempChatId = await _getTempChatId(chat: tempChat);

    final response = await _dio.get('/temporary/$tempChatId/constraint');
    if (response.statusCode == 200) {
      return ChatConstraint.fromJson(response.data);
    } else {
      throw Exception(
        'Ошибка получения ограничений временного чата: ${response.statusCode}',
      );
    }
  }

  @override
  Future<void> updateConstraint({required TemporaryChat tempChat}) async {
    _setAuthHeader();
    final tempChatId = await _getTempChatId(chat: tempChat);
    final canStart = true;
    final waitSeconds = 10;
    final response = await _dio.put(
      '/temporary/$tempChatId/constraint',
      queryParameters: {'canStart': canStart, 'waitSeconds': waitSeconds},
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Ошибка обновления ограничений временного чата');
    }
  }

  Future<String> _getTempChatId({required TemporaryChat chat}) async {
    final user = userModelAppInterface.user;
    if (user == null) throw Exception('Пользователь не авторизован');
    return chat.tempChatId;
  }
}
