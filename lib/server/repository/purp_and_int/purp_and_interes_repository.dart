import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:meet_now_app/config.dart';
import 'package:meet_now_app/server/model/interes/interest.dart';
import 'package:meet_now_app/server/model/purpose/purpose.dart';
import 'package:meet_now_app/storage/hive/repository/storage_hive_interface.dart';
import 'purp_and_interes_interface.dart';

class PurpAndInteresRepository implements PurpAndInteresInterface {
  final Dio _dio;
  final StorageHiveInterface _storageHiveInterface;

  PurpAndInteresRepository({required StorageHiveInterface storageHiveInterface})
    : _storageHiveInterface = storageHiveInterface,
      _dio = Dio(
        BaseOptions(
          baseUrl: purpAndInter,
          contentType: 'application/json; charset=utf-8',
          responseType: ResponseType.bytes,
        ),
      );

  @override
  Future<List<Interest>> getAllInterest() async {
    try {
      final res = await _dio.get("/getInterest");
      if (res.statusCode == 200) {
        String responseBody = utf8.decode(res.data);
        final data = jsonDecode(responseBody) as List;
        final interests =
            data
                .map((e) => Interest.fromJson(e as Map<String, dynamic>))
                .toList();

        _storageHiveInterface.addAllInterestBox(items: interests);
        log(
          '✅ Получено ${interests.length} интересов',
          name: 'PurpAndInteresRepository',
        );
        return interests;
      } else {
        log(
          '⚠️ Не удалось получить интересы, статус: ${res.statusCode}',
          name: 'PurpAndInteresRepository',
        );
        return [];
      }
    } catch (e, s) {
      log(
        '❌ Ошибка getAllInterest: $e',
        name: 'PurpAndInteresRepository',
        error: e,
        stackTrace: s,
      );
      throw Exception("Пришли пустые данные... Ошибка: $e");
    }
  }

  @override
  Future<List<Purpose>> getAllPurpose() async {
    try {
      final res = await _dio.get("/getPurpose");
      if (res.statusCode == 200) {
        String responseBody = utf8.decode(res.data);
        final data = jsonDecode(responseBody) as List;
        final purposes =
            data
                .map((e) => Purpose.fromJson(e as Map<String, dynamic>))
                .toList();

        _storageHiveInterface.addAllPurposeBox(items: purposes);
        log(
          '✅ Получено ${purposes.length} целей',
          name: 'PurpAndInteresRepository',
        );
        return purposes;
      } else {
        log(
          '⚠️ Не удалось получить цели, статус: ${res.statusCode}',
          name: 'PurpAndInteresRepository',
        );
        return [];
      }
    } catch (e, s) {
      log(
        '❌ Ошибка getAllPurpose: $e',
        name: 'PurpAndInteresRepository',
        error: e,
        stackTrace: s,
      );
      throw Exception("Пришли пустые данные... Ошибка: $e");
    }
  }
}
