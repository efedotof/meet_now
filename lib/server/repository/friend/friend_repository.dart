import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:meet_now_app/config.dart';
import 'package:meet_now_app/server/model/friends_request/friend_request.dart';
import 'package:meet_now_app/server/model/user/user.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';
import 'package:meet_now_app/storage/token/token_interface.dart';
import 'friend_interface.dart';

class FriendRepository implements FriendInterface {
  final UserModelAppInterface userModelAppInterface;
  final TokenInterface tokenInterface;
  final Dio _dio;

  FriendRepository({
    required this.userModelAppInterface,
    required this.tokenInterface,
  }) : _dio = Dio(
         BaseOptions(baseUrl: friendAddress, contentType: 'application/json'),
       );

  void _setAuthHeader() {
    final token = tokenInterface.getToken();
    if (token == "" || token.isEmpty) {
      log('❌ Отсутствует токен авторизации', name: 'FriendRepository');
      throw Exception('Отсутствует токен авторизации');
    }
    _dio.options.headers['Authorization'] = 'Bearer $token';
    log('🔑 Токен авторизации установлен', name: 'FriendRepository');
  }

  String getUserId() {
    final uuid = userModelAppInterface.user?.id;
    if (uuid == null || uuid.isEmpty) {
      log('❌ Отсутствует id пользователя', name: 'FriendRepository');
      throw Exception('Отсутствует id пользователя');
    }
    return uuid;
  }

  @override
  Future<List<User>> getFriends() async {
    try {
      _setAuthHeader();
      final uuid = getUserId();
      final response = await _dio.get(
        '/list',
        queryParameters: {"userId": uuid},
      );
      if (response.statusCode == 200) {
        final friends =
            (response.data as List)
                .map((e) => User.fromJson(e as Map<String, dynamic>))
                .toList();
        log(
          '✅ Получено ${friends.length} друзей для пользователя $uuid',
          name: 'FriendRepository',
        );
        return friends;
      }
      throw Exception('Ошибка получения друзей: ${response.statusCode}');
    } catch (e, s) {
      log(
        '❌ Ошибка getFriends: $e',
        name: 'FriendRepository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  @override
  Future<List<FriendRequest>> getIncomingRequests() async {
    try {
      _setAuthHeader();
      final uuid = getUserId();
      final response = await _dio.get(
        '/requests/incoming',
        queryParameters: {"userId": uuid},
      );
      if (response.statusCode == 200) {
        final requests =
            (response.data as List)
                .map((e) => FriendRequest.fromJson(e as Map<String, dynamic>))
                .toList();
        log(
          '✅ Получено ${requests.length} входящих запросов для пользователя $uuid',
          name: 'FriendRepository',
        );
        return requests;
      }
      throw Exception(
        'Ошибка получения запросов в друзья: ${response.statusCode}',
      );
    } catch (e, s) {
      log(
        '❌ Ошибка getIncomingRequests: $e',
        name: 'FriendRepository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  @override
  Future<String> removeFriend({required String friendId}) async {
    try {
      _setAuthHeader();
      final uuid = getUserId();
      final response = await _dio.post(
        '/remove',
        data: {'userId': uuid, 'friendId': friendId},
      );
      if (response.statusCode == 200) {
        log(
          '✅ Друг $friendId удалён пользователем $uuid',
          name: 'FriendRepository',
        );
        return response.data.toString();
      }
      throw Exception('Ошибка удаления друга: ${response.statusCode}');
    } catch (e, s) {
      log(
        '❌ Ошибка removeFriend: $e',
        name: 'FriendRepository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  @override
  Future<String> requestAccept({required String requesterId}) async {
    try {
      _setAuthHeader();
      final uuid = getUserId();
      final response = await _dio.post(
        '/request/accept',
        data: {'currentUserId': uuid, 'requesterId': requesterId},
      );
      if (response.statusCode == 200) {
        log(
          '✅ Запрос от $requesterId принят пользователем $uuid',
          name: 'FriendRepository',
        );
        return response.data.toString();
      }
      throw Exception('Ошибка принятия запроса: ${response.statusCode}');
    } catch (e, s) {
      log(
        '❌ Ошибка requestAccept: $e',
        name: 'FriendRepository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  @override
  Future<String> requestReject({required String requesterId}) async {
    try {
      _setAuthHeader();
      final uuid = getUserId();
      final response = await _dio.post(
        '/request/reject',
        data: {'currentUserId': uuid, 'requesterId': requesterId},
      );
      if (response.statusCode == 200) {
        log(
          '✅ Запрос от $requesterId отклонён пользователем $uuid',
          name: 'FriendRepository',
        );
        return response.data.toString();
      }
      throw Exception('Ошибка отклонения запроса: ${response.statusCode}');
    } catch (e, s) {
      log(
        '❌ Ошибка requestReject: $e',
        name: 'FriendRepository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  @override
  Future<String> sendFriendRequest({required String toUserId}) async {
    try {
      _setAuthHeader();
      final uuid = getUserId();
      final response = await _dio.post(
        '/request/send',
        data: {'fromUserId': uuid, 'toUserId': toUserId},
      );
      if (response.statusCode == 200) {
        log(
          '✅ Пользователь $uuid отправил запрос в друзья пользователю $toUserId',
          name: 'FriendRepository',
        );
        return response.data.toString();
      }
      throw Exception(
        'Ошибка отправки запроса в друзья: ${response.statusCode}',
      );
    } catch (e, s) {
      log(
        '❌ Ошибка sendFriendRequest: $e',
        name: 'FriendRepository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }
}
