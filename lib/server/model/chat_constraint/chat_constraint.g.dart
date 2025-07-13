// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_constraint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatConstraint _$ChatConstraintFromJson(Map<String, dynamic> json) =>
    _ChatConstraint(
      id: json['id'] as String,
      temporaryChat: Chat.fromJson(
        json['temporaryChat'] as Map<String, dynamic>,
      ),
      waitSeconds: (json['waitSeconds'] as num?)?.toInt() ?? 30,
      canStart: json['canStart'] as bool? ?? false,
    );

Map<String, dynamic> _$ChatConstraintToJson(_ChatConstraint instance) =>
    <String, dynamic>{
      'id': instance.id,
      'temporaryChat': instance.temporaryChat,
      'waitSeconds': instance.waitSeconds,
      'canStart': instance.canStart,
    };
