import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meet_now_app/config.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';
import 'upload_image_interface.dart';

class UploadImageRepository implements UploadImageInterface {
  final Dio _dio = Dio(BaseOptions(baseUrl: uploadsAddress));
  final UserModelAppInterface _userModelAppInterface;

  UploadImageRepository({required UserModelAppInterface userModelAppInterface})
    : _userModelAppInterface = userModelAppInterface;

  void _setAuthHeader() {
    final token = _userModelAppInterface.user?.token;
    if (token == null || token.isEmpty) {
      throw Exception('Отсутствует токен авторизации');
    }
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  @override
  Future<String> uploadAvatar(String filePath) async {
    try {
      _setAuthHeader();
      final fileName = filePath.split('/').last;

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath, filename: fileName),
      });

      final response = await _dio.post(
        '/upload-avatar',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 200) {
        debugPrint(response.data.toString());
        return response.data;
      } else {
        throw Exception("Ошибка загрузки: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Ошибка при загрузке: $e");
    }
  }

  @override
  Future<List<String>> uploadsImages(List<String> filesPath) async {
    try {
      _setAuthHeader();

      List<MultipartFile> files = [];
      for (var path in filesPath) {
        final fileName = path.split('/').last;
        files.add(await MultipartFile.fromFile(path, filename: fileName));
      }

      FormData formData = FormData.fromMap({"files": files});

      final response = await _dio.post("/upload-images", data: formData);

      if (response.statusCode == 200) {
        List<dynamic> urls = response.data;
        return urls.map((e) => e.toString()).toList();
      } else {
        debugPrint("Ошибка сервера: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      debugPrint("Произошла ошибка загрузки изображений: $e");
      return [];
    }
  }
}
