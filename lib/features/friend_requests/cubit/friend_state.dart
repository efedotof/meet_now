part of 'friend_cubit.dart';

@freezed
class FriendState with _$FriendState {
  const factory FriendState.initial() = _Initial;
  const factory FriendState.myFriendRequest({required List<FriendRequest> friendRequest}) = _MyFriendRequest;
  const factory FriendState.emptyFriendRequest() = _EmptyFriendRequest;
}
