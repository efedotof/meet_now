import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'temporary_chat.freezed.dart';
part 'temporary_chat.g.dart';

@HiveType(typeId: 3)
@freezed
abstract class TemporaryChat with _$TemporaryChat {
  const factory TemporaryChat({
   @HiveField(0) required String tempChatId,
   @HiveField(1) required String senderId,
   @HiveField(2) required String recipientId,
   @HiveField(3) required DateTime createdAt,
   @HiveField(4) required int durationMinutes,
   @HiveField(5) required bool isFinished,
   @HiveField(6) required bool bothAgreed,
  }) = _TemporaryChat;

  factory TemporaryChat.fromJson(Map<String, dynamic> json) =>
      _$TemporaryChatFromJson(json);
}
