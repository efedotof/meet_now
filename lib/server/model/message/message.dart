import 'package:freezed_annotation/freezed_annotation.dart';

part "message.freezed.dart";
part "message.g.dart";

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
    bool? isRead,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}
