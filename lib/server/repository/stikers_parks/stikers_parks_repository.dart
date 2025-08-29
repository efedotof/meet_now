import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meet_now_app/config.dart';
import 'package:meet_now_app/server/model/sticker/sticker.dart';
import 'package:meet_now_app/server/model/sticker_pack/sticker_pack.dart';
import 'stikers_parks_interface.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';

class StikersParksRepository implements StikersParksInterface {
  final Dio _dio = Dio(BaseOptions(baseUrl: stickersAddress));
  final UserModelAppInterface _userModelAppInterface;

  StikersParksRepository({required UserModelAppInterface userModelAppInterface})
    : _userModelAppInterface = userModelAppInterface;

  void _setAuthHeader() {
    final token = _userModelAppInterface.user?.token;
    if (token == null || token.isEmpty) {
      throw Exception('Отсутствует токен авторизации');
    }
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  @override
  Future<List<StickerPack>> getAllStickerPacks() async {
    try {
      _setAuthHeader();
      final response = await _dio.get('/packs');

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((e) => StickerPack.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Ошибка сервера: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint("Ошибка сети: $e");
      throw Exception('Не удалось загрузить стикерпаки');
    } catch (e) {
      debugPrint("Произошла ошибка: $e");
      rethrow;
    }
  }

  @override
  Future<StickerPack> getStickerPack(String packId) async {
    try {
      _setAuthHeader();
      final response = await _dio.get('/packs/$packId');

      if (response.statusCode == 200) {
        return StickerPack.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Ошибка сервера: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint("Ошибка сети: $e");
      throw Exception('Не удалось загрузить стикерпак');
    } catch (e) {
      debugPrint("Произошла ошибка: $e");
      rethrow;
    }
  }

  @override
  Future<List<Sticker>> getStickersByPack(String packId) async {
    try {
      _setAuthHeader();
      final response = await _dio.get('/packs/$packId/stickers');

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((e) => Sticker.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Ошибка сервера: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint("Ошибка сети: $e");
      throw Exception('Не удалось загрузить стикеры');
    } catch (e) {
      debugPrint("Произошла ошибка: $e");
      rethrow;
    }
  }

  @override
  Future<Sticker> getSticker(String stickerId) async {
    try {
      _setAuthHeader();
      final response = await _dio.get('/$stickerId');

      if (response.statusCode == 200) {
        return Sticker.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Ошибка сервера: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint("Ошибка сети: $e");
      throw Exception('Не удалось загрузить стикер');
    } catch (e) {
      debugPrint("Произошла ошибка: $e");
      rethrow;
    }
  }
}
