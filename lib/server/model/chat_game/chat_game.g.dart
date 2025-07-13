// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatGame _$ChatGameFromJson(Map<String, dynamic> json) => _ChatGame(
  id: json['id'] as String,
  chat: Chat.fromJson(json['chat'] as Map<String, dynamic>),
  gameType: json['gameType'] as String,
  state: json['state'] as String,
);

Map<String, dynamic> _$ChatGameToJson(_ChatGame instance) => <String, dynamic>{
  'id': instance.id,
  'chat': instance.chat,
  'gameType': instance.gameType,
  'state': instance.state,
};
