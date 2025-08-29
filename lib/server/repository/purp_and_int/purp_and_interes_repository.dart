import 'package:dio/dio.dart';
import 'package:meet_now_app/config.dart';
import 'package:meet_now_app/server/model/interes/interest.dart';
import 'package:meet_now_app/server/model/purpose/purpose.dart';
import 'package:meet_now_app/storage/hive/repository/storage_hive_interface.dart';
import 'dart:convert'; 

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
        final interests = data
            .map((e) => Interest.fromJson(e as Map<String, dynamic>))
            .toList();
            
        _storageHiveInterface.addAllInterestBox(items: interests);
        return interests;
      } else {
        return [];
      }
    } catch (e) {
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
        final purpose = data
            .map((e) => Purpose.fromJson(e as Map<String, dynamic>)) 
            .toList();
            
        _storageHiveInterface.addAllPurposeBox(items: purpose);
        return purpose;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception("Пришли пустые данные... Ошибка: $e");
    }
  }
}