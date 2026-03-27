part of 'unread_count_cubit.dart';

@freezed
class UnreadCountState with _$UnreadCountState {
  const factory UnreadCountState.initial() = _Initial;
  const factory UnreadCountState.loaded(int totalUnreadCount) = _Loaded;
}
