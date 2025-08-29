// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'] as String,
  reporterId: json['reporterId'] as String,
  reportedId: json['reportedId'] as String,
  reason: json['reason'] as String,
  status: $enumDecode(_$ReportStatusEnumMap, json['status']),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'reporterId': instance.reporterId,
  'reportedId': instance.reportedId,
  'reason': instance.reason,
  'status': _$ReportStatusEnumMap[instance.status]!,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$ReportStatusEnumMap = {
  ReportStatus.SENT: 'SENT',
  ReportStatus.IN_PROCESS: 'IN_PROCESS',
  ReportStatus.COMPLETED: 'COMPLETED',
};
