import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/server/model/chat/chat.dart';

part 'chat_constraint.freezed.dart';
part 'chat_constraint.g.dart';

@freezed
abstract class ChatConstraint with _$ChatConstraint {
  const factory ChatConstraint({
    required String id,
    required Chat temporaryChat,
    @Default(30) int waitSeconds,
    @Default(false) bool canStart,
  }) = _ChatConstraint;

  factory ChatConstraint.fromJson(Map<String, dynamic> json) =>
      _$ChatConstraintFromJson(json);
}
