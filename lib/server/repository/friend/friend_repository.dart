import 'package:dio/dio.dart';
import 'package:meet_now_app/config.dart';
import 'package:meet_now_app/server/model/user/user.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';

import 'friend_interface.dart';

class FriendRepository implements FriendInterface {
  final UserModelAppInterface userModelAppInterface;
  final Dio _dio;

  FriendRepository({required this.userModelAppInterface})
    : _dio = Dio(
        BaseOptions(baseUrl: friendAddress, contentType: 'application/json'),
      );

  void _setAuthHeader() {
    final token = userModelAppInterface.user?.token;
    if (token == null || token.isEmpty) {
      throw Exception('Отсутствует токен авторизации');
    }
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  String getUserId() {
    final uuid = userModelAppInterface.user?.id;
    if (uuid == null || uuid.isEmpty) {
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
        return (response.data as List)
            .map((e) => User.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw Exception('Ошибка получения друзей: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<User>> getIncomingRequests() async {
    try {
      _setAuthHeader();
      final uuid = getUserId();
      final response = await _dio.get(
        '/requests/incoming',
        queryParameters: {"userId": uuid},
      );
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((e) => User.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw Exception(
        'Ошибка получения запросов в друзья: ${response.statusCode}',
      );
    } catch (e) {
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
        return response.data.toString();
      }
      throw Exception('Ошибка удаления друга: ${response.statusCode}');
    } catch (e) {
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
        return response.data.toString();
      }
      throw Exception('Ошибка принятия запроса: ${response.statusCode}');
    } catch (e) {
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
        return response.data.toString();
      }
      throw Exception('Ошибка отклонения запроса: ${response.statusCode}');
    } catch (e) {
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
        return response.data.toString();
      }
      throw Exception(
        'Ошибка отправки запроса в друзья: ${response.statusCode}',
      );
    } catch (e) {
      rethrow;
    }
  }
}
