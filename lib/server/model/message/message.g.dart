// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Message _$MessageFromJson(Map<String, dynamic> json) => _Message(
  chatId: json['chatId'] as String,
  senderId: json['senderId'] as String,
  recipientId: json['recipientId'] as String,
  text: json['text'] as String,
);

Map<String, dynamic> _$MessageToJson(_Message instance) => <String, dynamic>{
  'chatId': instance.chatId,
  'senderId': instance.senderId,
  'recipientId': instance.recipientId,
  'text': instance.text,
};
