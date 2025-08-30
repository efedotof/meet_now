import 'package:meet_now_app/server/model/city/city.dart';

abstract interface class CityInterface {
  Future<List<City>> searchCities(String query, {int limit = 10});
  Future<List<City>> searchCitiesByPrefix(String prefix, {int limit = 10});
}
