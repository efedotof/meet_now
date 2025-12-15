import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/model/auth/user/user.dart';
import 'package:meet_now_app_server/model/social/friends_request/friend_connection_dto/friend_connection_dto.dart';
import 'package:meet_now_app_server/model/social/friends_request/friend_request_dto/friend_request_dto.dart';
import 'package:meet_now_app_server/model/social/user_with_friend_count_dto/user_with_friend_count_dto.dart';
import 'package:meet_now_app_server/repository/admin/admin_interface.dart';

part 'users_state.dart';
part 'users_cubit.freezed.dart';

enum UsersTab {
  all('All Users'),
  blocked('Blocked Users');

  final String label;
  const UsersTab(this.label);
}

class UsersCubit extends Cubit<UsersState> {
  UsersCubit({required AdminInterface adminInterface})
    : _adminInterface = adminInterface,
      super(UsersState.initial()) {
    _loadInitialUsers();
  }

  final AdminInterface _adminInterface;
  List<User> _allUsers = [];

  Future<void> _loadInitialUsers() async {
    emit(state.copyWith(isLoading: true));

    try {
      final usersPage = await _adminInterface.getAllUsers(page: 0, size: 100);
      log(
        '✅ Получено пользователей: ${usersPage.content.length}',
        name: 'UsersCubit',
      );

      _allUsers = usersPage.content;

      log(
        '✅ Первый пользователь: ${_allUsers.firstOrNull?.username}',
        name: 'UsersCubit',
      );

      emit(state.copyWith(isLoading: false, users: _allUsers, error: null));

      // Применяем текущий фильтр после загрузки
      _applyFilters();
    } catch (e) {
      log('❌ Ошибка загрузки: $e', name: 'UsersCubit');
      emit(state.copyWith(isLoading: false, error: 'Failed to load users: $e'));
    }
  }

  void search(String query) {
    if (state.searchQuery == query) return;

    emit(state.copyWith(searchQuery: query));
    _applyFilters();
  }

  void changeTab(UsersTab tab) {
    emit(state.copyWith(activeTab: tab));
    _applyFilters();
  }

  void _applyFilters() {
    List<User> filtered = _allUsers;

    // Фильтр по вкладке
    if (state.activeTab == UsersTab.blocked) {
      filtered = filtered.where((user) => user.isBlocked == true).toList();
    }

    // Фильтр по поисковому запросу
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered.where((user) {
        return user.username.toLowerCase().contains(query) ||
            user.email.toLowerCase().contains(query) ||
            (user.firstname?.toLowerCase() ?? '').contains(query) ||
            (user.subname?.toLowerCase() ?? '').contains(query);
      }).toList();
    }

    emit(state.copyWith(filteredUsers: filtered));
  }

  Future<void> refresh() async {
    emit(state.copyWith(isLoading: true));

    try {
      final usersPage = await _adminInterface.getAllUsers(page: 0, size: 100);
      _allUsers = usersPage.content;

      emit(state.copyWith(isLoading: false, users: _allUsers, error: null));

      _applyFilters();
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, error: 'Failed to refresh users: $e'),
      );
    }
  }

  Future<void> _executeOperation(
    Future<void> Function() operation,
    String errorMessage,
  ) async {
    try {
      await operation();
      await refresh();
    } catch (e) {
      emit(state.copyWith(error: '$errorMessage: $e'));
    }
  }

  Future<void> blockUser(String userId, String reason) async {
    await _executeOperation(
      () => _adminInterface.blockUser(userId: userId, reason: reason),
      'Failed to block user',
    );
  }

  Future<void> unblockUser(String userId) async {
    await _executeOperation(
      () => _adminInterface.unblockUser(userId: userId),
      'Failed to unblock user',
    );
  }

  Future<void> addRoleToUser(String userId, String roleName) async {
    await _executeOperation(
      () => _adminInterface.addRoleToUser(userId: userId, roleName: roleName),
      'Failed to add role',
    );
  }

  Future<void> removeRoleFromUser(String userId, String roleName) async {
    await _executeOperation(
      () => _adminInterface.removeRoleFromUser(
        userId: userId,
        roleName: roleName,
      ),
      'Failed to remove role',
    );
  }

  Future<void> upgradeToPremium(String userId) async {
    await addRoleToUser(userId, 'premium');
  }

  Future<void> deleteUser(String userId) async {
    await _executeOperation(
      () => _adminInterface.deleteUser(userId: userId),
      'Failed to delete user',
    );
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }

  void setBlockReason(String? reason) {
    emit(state.copyWith(blockReason: reason));
  }

  void clearBlockReason() {
    emit(state.copyWith(blockReason: null));
  }
}
