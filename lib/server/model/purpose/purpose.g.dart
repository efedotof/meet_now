// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purpose.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PurposeAdapter extends TypeAdapter<Purpose> {
  @override
  final typeId = 0;

  @override
  Purpose read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Purpose(id: fields[0] as String, title: fields[1] as String?);
  }

  @override
  void write(BinaryWriter writer, Purpose obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PurposeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Purpose _$PurposeFromJson(Map<String, dynamic> json) =>
    _Purpose(id: json['id'] as String, title: json['title'] as String?);

Map<String, dynamic> _$PurposeToJson(_Purpose instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
};
