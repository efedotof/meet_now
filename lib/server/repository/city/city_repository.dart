import 'package:dio/dio.dart';
import 'package:meet_now_app/config.dart';
import 'package:meet_now_app/server/model/city/city.dart';

import 'city_interface.dart';

class CityRepository implements CityInterface {
  final Dio _dio = Dio(BaseOptions(baseUrl: cityAddress));

  @override
  Future<List<City>> searchCities(String query, {int limit = 10}) async {
    try {
      final response = await _dio.get(
        '/search',
        queryParameters: {'query': query, 'limit': limit},
      );

      return (response.data as List)
          .map((cityJson) => City.fromJson(cityJson))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to search cities: ${e.message}');
    }
  }

  @override
  Future<List<City>> searchCitiesByPrefix(
    String prefix, {
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        '/search/prefix',
        queryParameters: {'prefix': prefix, 'limit': limit},
      );

      return (response.data as List)
          .map((cityJson) => City.fromJson(cityJson))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to search cities by prefix: ${e.message}');
    }
  }
}
