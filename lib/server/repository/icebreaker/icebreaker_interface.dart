import 'package:meet_now_app/server/model/icebreaker_topec/icebreaker_topec.dart';

abstract interface class IcebreakerInterface {
  Future<List<IcebreakerTopec>> textSearch({required String text});
  Future<IcebreakerTopec?> getRandomIce();
  Future<List<IcebreakerTopec>> getAllIce();
}
