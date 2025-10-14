import 'dart:developer';
import 'package:dio/dio.dart';
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
      log('❌ Отсутствует токен авторизации', name: 'StikersParksRepository');
      throw Exception('Отсутствует токен авторизации');
    }
    _dio.options.headers['Authorization'] = 'Bearer $token';
    log('✅ Заголовок авторизации установлен', name: 'StikersParksRepository');
  }

  @override
  Future<List<StickerPack>> getAllStickerPacks() async {
    try {
      _setAuthHeader();
      final response = await _dio.get('/packs');
      log(
        '🔹 Получен ответ на запрос всех стикерпаков: ${response.statusCode}',
        name: 'StikersParksRepository',
      );

      if (response.statusCode == 200) {
        final packs =
            (response.data as List)
                .map((e) => StickerPack.fromJson(e as Map<String, dynamic>))
                .toList();
        log(
          '✅ Загружено стикерпаков: ${packs.length}',
          name: 'StikersParksRepository',
        );
        return packs;
      } else {
        throw Exception('Ошибка сервера: ${response.statusCode}');
      }
    } catch (e) {
      log('❌ Ошибка getAllStickerPacks: $e', name: 'StikersParksRepository');
      rethrow;
    }
  }

  @override
  Future<StickerPack> getStickerPack(String packId) async {
    try {
      _setAuthHeader();
      final response = await _dio.get('/packs/$packId');
      log(
        '🔹 Получен ответ на запрос стикерпак $packId: ${response.statusCode}',
        name: 'StikersParksRepository',
      );

      if (response.statusCode == 200) {
        log('✅ Стикерпак $packId загружен', name: 'StikersParksRepository');
        return StickerPack.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Ошибка сервера: ${response.statusCode}');
      }
    } catch (e) {
      log('❌ Ошибка getStickerPack: $e', name: 'StikersParksRepository');
      rethrow;
    }
  }

  @override
  Future<List<Sticker>> getStickersByPack(String packId) async {
    try {
      _setAuthHeader();
      final response = await _dio.get('/packs/$packId/stickers');
      log(
        '🔹 Получен ответ на запрос стикеров пакета $packId: ${response.statusCode}',
        name: 'StikersParksRepository',
      );

      if (response.statusCode == 200) {
        final stickers =
            (response.data as List)
                .map((e) => Sticker.fromJson(e as Map<String, dynamic>))
                .toList();
        log(
          '✅ Загружено стикеров: ${stickers.length} для пакета $packId',
          name: 'StikersParksRepository',
        );
        return stickers;
      } else {
        throw Exception('Ошибка сервера: ${response.statusCode}');
      }
    } catch (e) {
      log('❌ Ошибка getStickersByPack: $e', name: 'StikersParksRepository');
      rethrow;
    }
  }

  @override
  Future<Sticker> getSticker(String stickerId) async {
    try {
      _setAuthHeader();
      final response = await _dio.get('/$stickerId');
      log(
        '🔹 Получен ответ на запрос стикера $stickerId: ${response.statusCode}',
        name: 'StikersParksRepository',
      );

      if (response.statusCode == 200) {
        log('✅ Стикер $stickerId загружен', name: 'StikersParksRepository');
        return Sticker.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Ошибка сервера: ${response.statusCode}');
      }
    } catch (e) {
      log('❌ Ошибка getSticker: $e', name: 'StikersParksRepository');
      rethrow;
    }
  }
}
