// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Message _$MessageFromJson(Map<String, dynamic> json) => _Message(
  id: json['id'] as String?,
  chatId: json['chatId'] as String?,
  tempChatId: json['tempChatId'] as String?,
  senderId: json['senderId'] as String,
  recipientId: json['recipientId'] as String,
  text: json['text'] as String,
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  read: json['read'] as bool,
  contentType: json['contentType'] as String,
  media:
      (json['media'] as List<dynamic>)
          .map((e) => MessageMedia.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$MessageToJson(_Message instance) => <String, dynamic>{
  'id': instance.id,
  'chatId': instance.chatId,
  'tempChatId': instance.tempChatId,
  'senderId': instance.senderId,
  'recipientId': instance.recipientId,
  'text': instance.text,
  'createdAt': instance.createdAt?.toIso8601String(),
  'read': instance.read,
  'contentType': instance.contentType,
  'media': instance.media,
};
