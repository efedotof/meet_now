import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part "interest.freezed.dart";
part "interest.g.dart";

@HiveType(typeId: 1)
@freezed
abstract class Interest with _$Interest {
  factory Interest({
    @HiveField(0) required String id,
    @HiveField(1) required String? text,
  }) = _Interest;

  factory Interest.fromJson(Map<String, dynamic> json) =>
      _$InterestFromJson(json);
}
