import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meet_now_app/config.dart';
import 'upload_image_interface.dart';

class UploadImageRepository implements UploadImageInterface {
  final Dio _dio = Dio(BaseOptions(baseUrl: uploadsAddress));
  @override
  Future<String> uploadAvatar(String filePath) async {
    try {
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
}
