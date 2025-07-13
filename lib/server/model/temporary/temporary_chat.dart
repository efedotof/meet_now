import 'package:freezed_annotation/freezed_annotation.dart';

part 'temporary_chat.freezed.dart';
part 'temporary_chat.g.dart';

@freezed
abstract class TemporaryChat with _$TemporaryChat {
  const factory TemporaryChat({
    required String tempChatId,
    required String senderId,
    required String recipientId,
    required DateTime createdAt,
    required int durationMinutes,
    required bool isFinished,
    required bool bothAgreed,
  }) = _TemporaryChat;

  factory TemporaryChat.fromJson(Map<String, dynamic> json) =>
      _$TemporaryChatFromJson(json);
}
