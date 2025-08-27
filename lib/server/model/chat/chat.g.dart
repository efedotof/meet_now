// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatAdapter extends TypeAdapter<Chat> {
  @override
  final typeId = 4;

  @override
  Chat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Chat(
      chatId: fields[0] as String,
      user1: fields[1] as User,
      user2: fields[2] as User,
      createdAt: fields[3] as DateTime,
      isOpened: fields[4] as bool,
      lastMessage: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Chat obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.chatId)
      ..writeByte(1)
      ..write(obj.user1)
      ..writeByte(2)
      ..write(obj.user2)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.isOpened)
      ..writeByte(5)
      ..write(obj.lastMessage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Chat _$ChatFromJson(Map<String, dynamic> json) => _Chat(
  chatId: json['chatId'] as String,
  user1: User.fromJson(json['user1'] as Map<String, dynamic>),
  user2: User.fromJson(json['user2'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
  isOpened: json['isOpened'] as bool,
  lastMessage: json['lastMessage'] as String,
);

Map<String, dynamic> _$ChatToJson(_Chat instance) => <String, dynamic>{
  'chatId': instance.chatId,
  'user1': instance.user1,
  'user2': instance.user2,
  'createdAt': instance.createdAt.toIso8601String(),
  'isOpened': instance.isOpened,
  'lastMessage': instance.lastMessage,
};
