// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_time_proposal_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AddTimeProposalDto _$AddTimeProposalDtoFromJson(Map<String, dynamic> json) =>
    _AddTimeProposalDto(
      tempChatId: json['tempChatId'] as String,
      fromUserId: json['fromUserId'] as String,
      additionalMinutes: (json['additionalMinutes'] as num).toInt(),
    );

Map<String, dynamic> _$AddTimeProposalDtoToJson(_AddTimeProposalDto instance) =>
    <String, dynamic>{
      'tempChatId': instance.tempChatId,
      'fromUserId': instance.fromUserId,
      'additionalMinutes': instance.additionalMinutes,
    };
