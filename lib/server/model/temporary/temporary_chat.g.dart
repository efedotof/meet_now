// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temporary_chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TemporaryChat _$TemporaryChatFromJson(Map<String, dynamic> json) =>
    _TemporaryChat(
      tempChatId: json['tempChatId'] as String,
      senderId: json['senderId'] as String,
      recipientId: json['recipientId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      isFinished: json['isFinished'] as bool,
      bothAgreed: json['bothAgreed'] as bool,
    );

Map<String, dynamic> _$TemporaryChatToJson(_TemporaryChat instance) =>
    <String, dynamic>{
      'tempChatId': instance.tempChatId,
      'senderId': instance.senderId,
      'recipientId': instance.recipientId,
      'createdAt': instance.createdAt.toIso8601String(),
      'durationMinutes': instance.durationMinutes,
      'isFinished': instance.isFinished,
      'bothAgreed': instance.bothAgreed,
    };
