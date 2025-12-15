// users_state.dart
part of 'users_cubit.dart';

@freezed
abstract class UsersState with _$UsersState {
  const factory UsersState({
    required bool isLoading,
    required List<User> users,
    required List<User> filteredUsers,
    required String searchQuery,
    required UsersTab activeTab,
    required List<FriendConnectionDto> friendConnections,
    required List<FriendRequestDto> friendRequests,
    required List<UserWithFriendCountDto> usersWithFriendCount,
    required List<UserWithFriendCountDto> popularUsers,
    required bool isLoadingFriends,
    String? error,
    String? blockReason, // Для хранения причины блокировки
  }) = _UsersState;

  factory UsersState.initial() => UsersState(
    isLoading: true,
    users: [],
    filteredUsers: [],
    searchQuery: '',
    activeTab: UsersTab.all,
    friendConnections: [],
    friendRequests: [],
    usersWithFriendCount: [],
    popularUsers: [],
    isLoadingFriends: false,
    error: null,
    blockReason: null,
  );
}
