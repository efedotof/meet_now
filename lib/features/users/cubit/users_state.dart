part of 'users_cubit.dart';

@freezed
abstract class UsersState with _$UsersState {
  const factory UsersState({
    required bool isLoading,
    required List<User> users,
    required String searchQuery,
    required int currentPage,
    required bool hasMore,
    required List<FriendConnectionDto> friendConnections,
    required List<FriendRequestDto> friendRequests,
    required List<UserWithFriendCountDto> usersWithFriendCount,
    required List<UserWithFriendCountDto> popularUsers,
    required bool isLoadingFriends,
  }) = _UsersState;

  factory UsersState.initial() => UsersState(
    isLoading: true,
    users: [],
    searchQuery: '',
    currentPage: 1,
    hasMore: true,
    friendConnections: [],
    friendRequests: [],
    usersWithFriendCount: [],
    popularUsers: [],
    isLoadingFriends: false,
  );
}
