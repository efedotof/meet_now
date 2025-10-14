import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:meet_now_app/config.dart';
import 'package:meet_now_app/server/model/report/report.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';
import 'package:meet_now_app/storage/token/token_interface.dart';
import 'report_interface.dart';

class ReportRepository implements ReportInterface {
  final Dio _dio = Dio(BaseOptions(baseUrl: reportAddress));
  final UserModelAppInterface _userModelAppInterface;
  final TokenInterface _tokenInterface;
  ReportRepository({
    required UserModelAppInterface userModelAppInterface,
    required TokenInterface tokenInterface,
  }) : _tokenInterface = tokenInterface,
       _userModelAppInterface = userModelAppInterface;

  void _setAuthHeader() {
    final token = _tokenInterface.getToken();
    if (token == "" || token.isEmpty) {
      log('❌ Отсутствует токен авторизации', name: 'ReportRepository');
      throw Exception('Отсутствует токен авторизации');
    }
    _dio.options.headers['Authorization'] = 'Bearer $token';
    log('🔑 Токен авторизации установлен', name: 'ReportRepository');
  }

  @override
  Future<List<Report>> getUserReports() async {
    try {
      _setAuthHeader();
      final userId = _userModelAppInterface.user!.id;
      final res = await _dio.get("/user/$userId");

      if (res.statusCode == 200) {
        final reports =
            (res.data as List)
                .map((e) => Report.fromJson(e as Map<String, dynamic>))
                .toList();
        log(
          '✅ Получено ${reports.length} жалоб пользователя',
          name: 'ReportRepository',
        );
        return reports;
      } else {
        log('⚠️ Ошибка сервера: ${res.statusCode}', name: 'ReportRepository');
        throw Exception('Ошибка сервера: ${res.statusCode}');
      }
    } on DioException catch (e, s) {
      log(
        '❌ Ошибка сети при получении жалоб: $e',
        name: 'ReportRepository',
        error: e,
        stackTrace: s,
      );
      throw Exception('Не удалось загрузить жалобы');
    } catch (e, s) {
      log(
        '❌ Неизвестная ошибка при получении жалоб: $e',
        name: 'ReportRepository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  @override
  Future<void> withdrawReport({required String reportId}) async {
    try {
      _setAuthHeader();
      final userId = _userModelAppInterface.user!.id;

      await _dio.delete("/$reportId", queryParameters: {"userId": userId});
      log('✅ Жалоба $reportId отозвана', name: 'ReportRepository');
    } on DioException catch (e, s) {
      log(
        '❌ Ошибка сети при отзыве жалобы: $e',
        name: 'ReportRepository',
        error: e,
        stackTrace: s,
      );
      throw Exception('Не удалось отозвать жалобу');
    } catch (e, s) {
      log(
        '❌ Неизвестная ошибка при отзыве жалобы: $e',
        name: 'ReportRepository',
        error: e,
        stackTrace: s,
      );
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
      log(
        '✅ Создана жалоба на пользователя $reportedId',
        name: 'ReportRepository',
      );
    } on DioException catch (e, s) {
      log(
        '❌ Ошибка сети при создании жалобы: $e',
        name: 'ReportRepository',
        error: e,
        stackTrace: s,
      );
      throw Exception('Не удалось создать жалобу');
    } catch (e, s) {
      log(
        '❌ Неизвестная ошибка при создании жалобы: $e',
        name: 'ReportRepository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }
}
