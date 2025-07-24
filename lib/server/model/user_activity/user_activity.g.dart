// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserActivity _$UserActivityFromJson(Map<String, dynamic> json) =>
    _UserActivity(
      userId: json['userId'] as String,
      username: json['username'] as String,
      chatId: json['chatId'] as String,
      activityType: $enumDecode(_$ActivityTypeEnumMap, json['activityType']),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$UserActivityToJson(_UserActivity instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'chatId': instance.chatId,
      'activityType': _$ActivityTypeEnumMap[instance.activityType]!,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$ActivityTypeEnumMap = {
  ActivityType.TYPING: 'TYPING',
  ActivityType.SENDING_IMAGE: 'SENDING_IMAGE',
  ActivityType.SENDING_FILE: 'SENDING_FILE',
  ActivityType.ONLINE: 'ONLINE',
  ActivityType.OFFLINE: 'OFFLINE',
};
