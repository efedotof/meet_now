import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/server/model/sticker/sticker.dart';
import 'package:meet_now_app/server/model/message_content_type/message_content_type.dart';

part 'message_media.freezed.dart';
part 'message_media.g.dart';

@freezed
abstract class MessageMedia with _$MessageMedia {
  const factory MessageMedia({
    String? id,
    required String contentType,
    String? mediaUrl,
    int? fileSize,
    String? mimeType,
    String? thumbnailUrl,
    String? stickerId,
    Sticker? sticker,
    int? sortOrder,
  }) = _MessageMedia;

  factory MessageMedia.fromJson(Map<String, dynamic> json) =>
      _$MessageMediaFromJson(json);
}

extension MessageMediaExtensions on MessageMedia {
  ContentType get contentTypeEnum => ContentType.fromString(contentType);

  bool get isImage => contentType == 'image';
  bool get isVideo => contentType == 'video';
  bool get isSticker => contentType == 'sticker';
  bool get isFile => contentType == 'file';

  bool get hasMedia => mediaUrl != null && mediaUrl!.isNotEmpty;
  bool get hasThumbnail => thumbnailUrl != null && thumbnailUrl!.isNotEmpty;
  bool get hasSticker => sticker != null || stickerId != null;
}
