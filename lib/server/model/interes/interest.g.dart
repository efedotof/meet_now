// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interest.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InterestAdapter extends TypeAdapter<Interest> {
  @override
  final typeId = 1;

  @override
  Interest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Interest(id: fields[0] as String, text: fields[1] as String?);
  }

  @override
  void write(BinaryWriter writer, Interest obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InterestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Interest _$InterestFromJson(Map<String, dynamic> json) =>
    _Interest(id: json['id'] as String, text: json['text'] as String?);

Map<String, dynamic> _$InterestToJson(_Interest instance) => <String, dynamic>{
  'id': instance.id,
  'text': instance.text,
};
