import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/server/model/user/user.dart';

part 'chat.freezed.dart';
part 'chat.g.dart';

@freezed
abstract class Chat with _$Chat {
  const factory Chat({
    required String chatId,
    required User user1,
    required User user2,
    required DateTime createdAt,
    required bool isOpened,
  }) = _Chat;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
}
