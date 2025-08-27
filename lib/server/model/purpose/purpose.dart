import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part "purpose.freezed.dart";
part "purpose.g.dart";

@HiveType(typeId: 0)
@freezed
abstract class Purpose with _$Purpose {
  factory Purpose({
    @HiveField(0) required String id,
    @HiveField(1) required String? text,
  }) = _Purpose;

  factory Purpose.fromJson(Map<String, dynamic> json) =>
      _$PurposeFromJson(json);
}
