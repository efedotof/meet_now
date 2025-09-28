// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_update_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TimerUpdateDto _$TimerUpdateDtoFromJson(Map<String, dynamic> json) =>
    _TimerUpdateDto(
      tempChatId: json['tempChatId'] as String,
      remainingTime: (json['remainingTime'] as num).toInt(),
      finished: json['finished'] as bool,
    );

Map<String, dynamic> _$TimerUpdateDtoToJson(_TimerUpdateDto instance) =>
    <String, dynamic>{
      'tempChatId': instance.tempChatId,
      'remainingTime': instance.remainingTime,
      'finished': instance.finished,
    };
