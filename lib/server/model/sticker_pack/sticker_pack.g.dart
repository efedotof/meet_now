// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sticker_pack.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StickerPack _$StickerPackFromJson(Map<String, dynamic> json) => _StickerPack(
  id: json['id'] as String,
  title: json['title'] as String,
  stickers:
      (json['stickers'] as List<dynamic>)
          .map((e) => Sticker.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$StickerPackToJson(_StickerPack instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'stickers': instance.stickers,
    };
