import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'permanent_chat_response_dto.freezed.dart';
part 'permanent_chat_response_dto.g.dart';

@HiveType(typeId: 4)
@freezed
abstract class PermanentChatResponseDto with _$PermanentChatResponseDto {
  const factory PermanentChatResponseDto({
    @HiveField(0) required String chatId,
    @HiveField(1) required String user1Id,
    @HiveField(2) required String user1Username,
    @HiveField(3) required String user1Firstname,
    @HiveField(4) required String user1Subname,
    @HiveField(5) required String? user1Avatar,
    @HiveField(6) required String user2Id,
    @HiveField(7) required String user2Username,
    @HiveField(8) required String user2Firstname,
    @HiveField(9) required String user2Subname,
    @HiveField(10) required String? user2Avatar,
    @HiveField(11) required DateTime createdAt,
    @HiveField(12) required bool isOpened,
    String? lastMessage,
  }) = _PermanentChatResponseDto;

  factory PermanentChatResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PermanentChatResponseDtoFromJson(json);
}
