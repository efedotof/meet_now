import 'package:freezed_annotation/freezed_annotation.dart';

part "game_response.freezed.dart";
part "game_response.g.dart";

@freezed
abstract class GameResponse with _$GameResponse {
  const factory GameResponse({
    required String gameType,
    required String gameUrl,
    required String gameName,
    required String gameDescription,
    required String thumbnailUrl,
  }) = _GameResponse;

  factory GameResponse.fromJson(Map<String, dynamic> json) =>
      _$GameResponseFromJson(json);
}
