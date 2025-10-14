// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessageMedia _$MessageMediaFromJson(Map<String, dynamic> json) =>
    _MessageMedia(
      id: json['id'] as String?,
      contentType: json['contentType'] as String,
      mediaUrl: json['mediaUrl'] as String?,
      fileSize: (json['fileSize'] as num?)?.toInt(),
      mimeType: json['mimeType'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      stickerId: json['stickerId'] as String?,
      sticker:
          json['sticker'] == null
              ? null
              : Sticker.fromJson(json['sticker'] as Map<String, dynamic>),
      sortOrder: (json['sortOrder'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MessageMediaToJson(_MessageMedia instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contentType': instance.contentType,
      'mediaUrl': instance.mediaUrl,
      'fileSize': instance.fileSize,
      'mimeType': instance.mimeType,
      'thumbnailUrl': instance.thumbnailUrl,
      'stickerId': instance.stickerId,
      'sticker': instance.sticker,
      'sortOrder': instance.sortOrder,
    };
