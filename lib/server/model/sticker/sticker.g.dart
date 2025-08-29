// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sticker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Sticker _$StickerFromJson(Map<String, dynamic> json) => _Sticker(
  id: json['id'] as String,
  pack: StickerPack.fromJson(json['pack'] as Map<String, dynamic>),
  emoji: json['emoji'] as String,
  imageUrl: json['imageUrl'] as String,
);

Map<String, dynamic> _$StickerToJson(_Sticker instance) => <String, dynamic>{
  'id': instance.id,
  'pack': instance.pack,
  'emoji': instance.emoji,
  'imageUrl': instance.imageUrl,
};
