part of 'friends_cubit.dart';

@freezed
class FriendsState with _$FriendsState {
  const factory FriendsState.initial() = _Initial;
  const factory FriendsState.friendsList({required List<FriendDto> friends}) =
      _FriendsList;
}
