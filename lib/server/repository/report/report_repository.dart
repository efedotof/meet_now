import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meet_now_app/config.dart';
import 'package:meet_now_app/server/model/report/report.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';
import 'report_interface.dart';

class ReportRepository implements ReportInterface {
  final Dio _dio = Dio(BaseOptions(baseUrl: reportAddress));
  final UserModelAppInterface _userModelAppInterface;

  ReportRepository({required UserModelAppInterface userModelAppInterface})
    : _userModelAppInterface = userModelAppInterface;

  void _setAuthHeader() {
    final token = _userModelAppInterface.user?.token;
    if (token == null || token.isEmpty) {
      throw Exception('Отсутствует токен авторизации');
    }
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  @override
  Future<List<Report>> getUserReports() async {
    try {
      _setAuthHeader();
      final userId = _userModelAppInterface.user!.id;
      
      final res = await _dio.get("/user/$userId");

      if (res.statusCode == 200) {
        return (res.data as List)
            .map((e) => Report.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Ошибка сервера: ${res.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint("Ошибка сети: $e");
      throw Exception('Не удалось загрузить жалобы');
    } catch (e) {
      debugPrint("Произошла ошибка: $e");
      rethrow;
    }
  }

  @override
  Future<void> withdrawReport({required String reportId}) async {
    try {
      _setAuthHeader();
      final userId = _userModelAppInterface.user!.id;

      await _dio.delete(
        "/$reportId",
        queryParameters: {"userId": userId},
      );
    } on DioException catch (e) {
      debugPrint("Ошибка сети: $e");
      throw Exception('Не удалось отозвать жалобу');
    } catch (e) {
      debugPrint("Произошла ошибка: $e");
      rethrow;
    }
  }

  @override
  Future<void> createReport({
    required String reportedId,
    required String reason,
  }) async {
    try {
      _setAuthHeader();
      final userId = _userModelAppInterface.user!.id;

      final data = {
        "reporterId": userId,
        "reportedId": reportedId,
        "reason": reason,
      };

      await _dio.post("", data: data);
    } on DioException catch (e) {
      debugPrint("Ошибка сети: $e");
      throw Exception('Не удалось создать жалобу');
    } catch (e) {
      debugPrint("Произошла ошибка: $e");
      rethrow;
    }
  }
}