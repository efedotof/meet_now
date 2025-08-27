// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temporary_chat.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TemporaryChatAdapter extends TypeAdapter<TemporaryChat> {
  @override
  final typeId = 3;

  @override
  TemporaryChat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TemporaryChat(
      tempChatId: fields[0] as String,
      senderId: fields[1] as String,
      recipientId: fields[2] as String,
      createdAt: fields[3] as DateTime,
      durationMinutes: (fields[4] as num).toInt(),
      isFinished: fields[5] as bool,
      bothAgreed: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TemporaryChat obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.tempChatId)
      ..writeByte(1)
      ..write(obj.senderId)
      ..writeByte(2)
      ..write(obj.recipientId)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.durationMinutes)
      ..writeByte(5)
      ..write(obj.isFinished)
      ..writeByte(6)
      ..write(obj.bothAgreed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TemporaryChatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
