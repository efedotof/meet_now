// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Chat _$ChatFromJson(Map<String, dynamic> json) => _Chat(
  chatId: json['chatId'] as String,
  user1: User.fromJson(json['user1'] as Map<String, dynamic>),
  user2: User.fromJson(json['user2'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
  isOpened: json['isOpened'] as bool,
  lastMessage: json['lastMessage'] as String,
);

Map<String, dynamic> _$ChatToJson(_Chat instance) => <String, dynamic>{
  'chatId': instance.chatId,
  'user1': instance.user1,
  'user2': instance.user2,
  'createdAt': instance.createdAt.toIso8601String(),
  'isOpened': instance.isOpened,
  'lastMessage': instance.lastMessage,
};
