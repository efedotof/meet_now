// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sticker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Sticker _$StickerFromJson(Map<String, dynamic> json) => _Sticker(
  id: json['id'] as String,
  emoji: json['emoji'] as String,
  imageUrl: json['imageUrl'] as String,
  packId: json['packId'] as String,
  packTitle: json['packTitle'] as String,
);

Map<String, dynamic> _$StickerToJson(_Sticker instance) => <String, dynamic>{
  'id': instance.id,
  'emoji': instance.emoji,
  'imageUrl': instance.imageUrl,
  'packId': instance.packId,
  'packTitle': instance.packTitle,
};
