import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:meet_now_app/config.dart';
import 'package:meet_now_app/storage/token/token_interface.dart';
import 'upload_image_interface.dart';

class UploadImageRepository implements UploadImageInterface {
  final Dio _dio = Dio(BaseOptions(baseUrl: uploadsAddress));
  final TokenInterface _tokenInterface;
  UploadImageRepository({
    required TokenInterface tokenInterface,
  }) : _tokenInterface = tokenInterface;

  void _setAuthHeader() {
    final token = _tokenInterface.getToken();
    if (token == "" || token.isEmpty) {
      throw Exception('Отсутствует токен авторизации');
    }
    _dio.options.headers['Authorization'] = 'Bearer $token';
    log('Authorization header set', name: 'UploadImageRepository');
  }

  @override
  Future<String> uploadAvatar(String filePath) async {
    try {
      _setAuthHeader();
      final fileName = filePath.split('/').last;
      log('Uploading avatar: $fileName', name: 'UploadImageRepository');

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath, filename: fileName),
      });

      final response = await _dio.post(
        '/upload-avatar',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 200) {
        log('Avatar uploaded: ${response.data}', name: 'UploadImageRepository');
        return response.data;
      } else {
        log(
          'Upload avatar failed: ${response.statusCode}',
          name: 'UploadImageRepository',
        );
        throw Exception("Ошибка загрузки: ${response.statusCode}");
      }
    } catch (e) {
      log('Error uploading avatar: $e', name: 'UploadImageRepository');
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
        log(
          'Prepared file for upload: $fileName',
          name: 'UploadImageRepository',
        );
      }

      FormData formData = FormData.fromMap({"files": files});
      final response = await _dio.post(
        "/upload-images",
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 200) {
        List<dynamic> urls = response.data;
        log(
          'Images uploaded: ${urls.toString()}',
          name: 'UploadImageRepository',
        );
        return urls.map((e) => e.toString()).toList();
      } else {
        log(
          'Upload images failed: ${response.statusCode}',
          name: 'UploadImageRepository',
        );
        return [];
      }
    } catch (e) {
      log('Error uploading images: $e', name: 'UploadImageRepository');
      return [];
    }
  }

  @override
  Future<String> getPresignedUrl(String fileUrl) async {
    _setAuthHeader();
    log('Getting presigned URL for: $fileUrl', name: 'UploadImageRepository');
    final response = await _dio.get(
      '/presigned-url',
      queryParameters: {'fileUrl': fileUrl},
    );
    log(
      'Received presigned URL: ${response.data}',
      name: 'UploadImageRepository',
    );
    return response.data;
  }
}
