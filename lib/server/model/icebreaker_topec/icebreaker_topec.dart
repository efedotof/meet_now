import 'package:freezed_annotation/freezed_annotation.dart';

part 'icebreaker_topec.freezed.dart';
part 'icebreaker_topec.g.dart';

@freezed
abstract class IcebreakerTopec with _$IcebreakerTopec {
  const factory IcebreakerTopec({required int id, required String text}) =
      _IcebreakerTopec;

  factory IcebreakerTopec.fromJson(Map<String, dynamic> json) =>
      _$IcebreakerTopecFromJson(json);
}
