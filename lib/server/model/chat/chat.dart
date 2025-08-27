import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:meet_now_app/server/model/user/user.dart';

part 'chat.freezed.dart';
part 'chat.g.dart';

@HiveType(typeId: 4)
@freezed
abstract class Chat with _$Chat {
  const factory Chat({
   @HiveField(0) required String chatId,
   @HiveField(1) required User user1,
   @HiveField(2) required User user2,
   @HiveField(3) required DateTime createdAt,
   @HiveField(4) required bool isOpened,
   @HiveField(5) required String lastMessage,
  }) = _Chat;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
}
