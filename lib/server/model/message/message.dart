import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/server/model/message_media/message_media.dart';
import 'package:meet_now_app/server/model/message_content_type/message_content_type.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
abstract class Message with _$Message {
  const factory Message({ 
    String? id,
    String? chatId,
    String? tempChatId,
    required String senderId,
    required String recipientId,
    required String text,
    DateTime? createdAt,
    required bool read,
    required String contentType,
    required List<MessageMedia> media,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}

extension MessageExtensions on Message {
  ContentType get contentTypeEnum => ContentType.fromString(contentType);

  bool get isText => contentType == 'text';
  bool get isImage => contentType == 'image';
  bool get isVideo => contentType == 'video';
  bool get isSticker => contentType == 'sticker';
  bool get isFile => contentType == 'file';

  bool get hasMedia => media.isNotEmpty;

  MessageMedia? get firstMedia => media.isNotEmpty ? media.first : null;
}
