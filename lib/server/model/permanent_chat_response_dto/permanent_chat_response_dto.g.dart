// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permanent_chat_response_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PermanentChatResponseDtoAdapter
    extends TypeAdapter<PermanentChatResponseDto> {
  @override
  final typeId = 4;

  @override
  PermanentChatResponseDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PermanentChatResponseDto(
      chatId: fields[0] as String,
      user1Id: fields[1] as String,
      user1Username: fields[2] as String,
      user1Firstname: fields[3] as String,
      user1Subname: fields[4] as String,
      user1Avatar: fields[5] as String?,
      user2Id: fields[6] as String,
      user2Username: fields[7] as String,
      user2Firstname: fields[8] as String,
      user2Subname: fields[9] as String,
      user2Avatar: fields[10] as String?,
      createdAt: fields[11] as DateTime,
      isOpened: fields[12] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PermanentChatResponseDto obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.chatId)
      ..writeByte(1)
      ..write(obj.user1Id)
      ..writeByte(2)
      ..write(obj.user1Username)
      ..writeByte(3)
      ..write(obj.user1Firstname)
      ..writeByte(4)
      ..write(obj.user1Subname)
      ..writeByte(5)
      ..write(obj.user1Avatar)
      ..writeByte(6)
      ..write(obj.user2Id)
      ..writeByte(7)
      ..write(obj.user2Username)
      ..writeByte(8)
      ..write(obj.user2Firstname)
      ..writeByte(9)
      ..write(obj.user2Subname)
      ..writeByte(10)
      ..write(obj.user2Avatar)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.isOpened);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PermanentChatResponseDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PermanentChatResponseDto _$PermanentChatResponseDtoFromJson(
  Map<String, dynamic> json,
) => _PermanentChatResponseDto(
  chatId: json['chatId'] as String,
  user1Id: json['user1Id'] as String,
  user1Username: json['user1Username'] as String,
  user1Firstname: json['user1Firstname'] as String,
  user1Subname: json['user1Subname'] as String,
  user1Avatar: json['user1Avatar'] as String?,
  user2Id: json['user2Id'] as String,
  user2Username: json['user2Username'] as String,
  user2Firstname: json['user2Firstname'] as String,
  user2Subname: json['user2Subname'] as String,
  user2Avatar: json['user2Avatar'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  isOpened: json['isOpened'] as bool,
  lastMessage: json['lastMessage'] as String?,
);

Map<String, dynamic> _$PermanentChatResponseDtoToJson(
  _PermanentChatResponseDto instance,
) => <String, dynamic>{
  'chatId': instance.chatId,
  'user1Id': instance.user1Id,
  'user1Username': instance.user1Username,
  'user1Firstname': instance.user1Firstname,
  'user1Subname': instance.user1Subname,
  'user1Avatar': instance.user1Avatar,
  'user2Id': instance.user2Id,
  'user2Username': instance.user2Username,
  'user2Firstname': instance.user2Firstname,
  'user2Subname': instance.user2Subname,
  'user2Avatar': instance.user2Avatar,
  'createdAt': instance.createdAt.toIso8601String(),
  'isOpened': instance.isOpened,
  'lastMessage': instance.lastMessage,
};
