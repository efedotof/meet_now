// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameResponse _$GameResponseFromJson(Map<String, dynamic> json) =>
    _GameResponse(
      gameType: json['gameType'] as String,
      gameUrl: json['gameUrl'] as String,
      gameName: json['gameName'] as String,
      gameDescription: json['gameDescription'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );

Map<String, dynamic> _$GameResponseToJson(_GameResponse instance) =>
    <String, dynamic>{
      'gameType': instance.gameType,
      'gameUrl': instance.gameUrl,
      'gameName': instance.gameName,
      'gameDescription': instance.gameDescription,
      'thumbnailUrl': instance.thumbnailUrl,
    };
