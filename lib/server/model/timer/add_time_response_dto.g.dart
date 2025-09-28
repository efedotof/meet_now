// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_time_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AddTimeResponseDto _$AddTimeResponseDtoFromJson(Map<String, dynamic> json) =>
    _AddTimeResponseDto(
      tempChatId: json['tempChatId'] as String,
      userId: json['userId'] as String,
      accepted: json['accepted'] as bool,
      additionalMinutes: (json['additionalMinutes'] as num).toInt(),
    );

Map<String, dynamic> _$AddTimeResponseDtoToJson(_AddTimeResponseDto instance) =>
    <String, dynamic>{
      'tempChatId': instance.tempChatId,
      'userId': instance.userId,
      'accepted': instance.accepted,
      'additionalMinutes': instance.additionalMinutes,
    };
