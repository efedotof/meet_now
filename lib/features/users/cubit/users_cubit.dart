import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/model/auth/user/user.dart';
import 'package:meet_now_app_server/model/social/friends_request/friend_connection_dto/friend_connection_dto.dart';
import 'package:meet_now_app_server/model/social/friends_request/friend_request_dto/friend_request_dto.dart';
import 'package:meet_now_app_server/model/social/user_with_friend_count_dto/user_with_friend_count_dto.dart';
import 'package:meet_now_app_server/repository/admin/admin_interface.dart';

part 'users_state.dart';
part 'users_cubit.freezed.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit({required AdminInterface adminInterface})
    : _adminInterface = adminInterface,
      super(UsersState.initial()) {
    _loadUsersData();
  }

  final AdminInterface _adminInterface;

 Future<void> _loadUsersData() async {
  emit(state.copyWith(isLoading: true));

  try {
    final usersPage = await _adminInterface.getAllUsers(
      page: state.currentPage - 1, 
      size: 20,
    );

    emit(
      state.copyWith(
        isLoading: false,
        users: usersPage.content,
        hasMore: !usersPage.last,
      ),
    );
  } catch (e) {
    _handleError('Failed to load users: $e');
  }
}

  // Основные методы управления пользователями
  void search(String query) {
    emit(state.copyWith(searchQuery: query, isLoading: true));
    _loadUsersData();
  }

  // Блокировка/разблокировка пользователей
  Future<void> blockUser(String userId) async {
    try {
      await _adminInterface.blockUser(userId: userId);
      // После блокировки перезагружаем данные
      await _loadUsersData();
    } catch (e) {
      _handleError('Failed to block user: $e');
    }
  }

  Future<void> unblockUser(String userId) async {
    try {
      await _adminInterface.unblockUser(userId: userId);
      // После разблокировки перезагружаем данные
      await _loadUsersData();
    } catch (e) {
      _handleError('Failed to unblock user: $e');
    }
  }

  // Управление ролями
  Future<void> addRoleToUser(String userId, String roleName) async {
    try {
      await _adminInterface.addRoleToUser(userId: userId, roleName: roleName);
      // После добавления роли перезагружаем данные
      await _loadUsersData();
    } catch (e) {
      _handleError('Failed to add role: $e');
    }
  }

  Future<void> removeRoleFromUser(String userId, String roleName) async {
    try {
      await _adminInterface.removeRoleFromUser(
        userId: userId,
        roleName: roleName,
      );
      // После удаления роли перезагружаем данные
      await _loadUsersData();
    } catch (e) {
      _handleError('Failed to remove role: $e');
    }
  }

  // Поиск пользователей
  Future<void> findUsersByEmail(String email) async {
    emit(state.copyWith(isLoading: true));
    try {
      final usersPage = await _adminInterface.findUsersByEmail(
        email: email,
        page: 0,
        size: 20,
      );
      emit(
        state.copyWith(
          isLoading: false,
          users: usersPage.content,
          searchQuery: email,
        ),
      );
    } catch (e) {
      _handleError('Failed to search users by email: $e');
    }
  }

  Future<void> findUsersByUsername(String username) async {
    emit(state.copyWith(isLoading: true));
    try {
      final usersPage = await _adminInterface.findUsersByUsername(
        username: username,
        page: 0,
        size: 20,
      );
      emit(
        state.copyWith(
          isLoading: false,
          users: usersPage.content,
          searchQuery: username,
        ),
      );
    } catch (e) {
      _handleError('Failed to search users by username: $e');
    }
  }

  // Управление дружескими связями
  Future<void> loadAllFriendConnections() async {
    emit(state.copyWith(isLoadingFriends: true));
    try {
      final connectionsPage = await _adminInterface.getAllFriendConnections(
        page: 0,
        size: 50,
      );
      emit(
        state.copyWith(
          friendConnections: connectionsPage.content,
          isLoadingFriends: false,
        ),
      );
    } catch (e) {
      _handleError('Failed to load friend connections: $e');
    }
  }

  Future<void> loadUsersWithFriendCount() async {
    emit(state.copyWith(isLoadingFriends: true));
    try {
      final usersPage = await _adminInterface.getUsersWithFriendCount(
        page: 0,
        size: 50,
      );
      emit(
        state.copyWith(
          usersWithFriendCount: usersPage.content,
          isLoadingFriends: false,
        ),
      );
    } catch (e) {
      _handleError('Failed to load users with friend count: $e');
    }
  }

  Future<void> loadPopularUsers() async {
    emit(state.copyWith(isLoadingFriends: true));
    try {
      final popularUsers = await _adminInterface.getPopularUsers(limit: 10);
      emit(state.copyWith(popularUsers: popularUsers, isLoadingFriends: false));
    } catch (e) {
      _handleError('Failed to load popular users: $e');
    }
  }

  Future<void> removeFriendConnection(String user1Id, String user2Id) async {
    try {
      await _adminInterface.removeFriendConnection(
        user1Id: user1Id,
        user2Id: user2Id,
      );
      await loadAllFriendConnections();
    } catch (e) {
      _handleError('Failed to remove friend connection: $e');
    }
  }

  // Управление запросами в друзья
  Future<void> loadAllActiveFriendRequests() async {
    emit(state.copyWith(isLoadingFriends: true));
    try {
      final requests = await _adminInterface.getAllActiveFriendRequests();
      emit(state.copyWith(friendRequests: requests, isLoadingFriends: false));
    } catch (e) {
      _handleError('Failed to load friend requests: $e');
    }
  }

  Future<void> removeFriendRequest(String fromUserId, String toUserId) async {
    try {
      await _adminInterface.removeFriendRequest(
        fromUserId: fromUserId,
        toUserId: toUserId,
      );
      await loadAllActiveFriendRequests();
    } catch (e) {
      _handleError('Failed to remove friend request: $e');
    }
  }

  Future<void> clearUserFriendRequests(String userId) async {
    try {
      await _adminInterface.clearUserFriendRequests(userId: userId);
      await loadAllActiveFriendRequests();
    } catch (e) {
      _handleError('Failed to clear user friend requests: $e');
    }
  }

  // Дополнительные методы
  Future<void> upgradeToPremium(String userId) async {
    try {
      await _adminInterface.addRoleToUser(userId: userId, roleName: 'premium');
      await _loadUsersData();
    } catch (e) {
      _handleError('Failed to upgrade user to premium: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _adminInterface.deleteUser(userId: userId);
      // После удаления пользователя перезагружаем данные
      await _loadUsersData();
    } catch (e) {
      _handleError('Failed to delete user: $e');
    }
  }

  Future<void> refresh() async {
    emit(state.copyWith(isLoading: true));
    await _loadUsersData();
  }

  Future<void> loadActiveUsers() async {
    emit(state.copyWith(isLoading: true));
    try {
      final activeUsersPage = await _adminInterface.getActiveUsers(
        page: 0,
        size: 20,
      );
      emit(state.copyWith(isLoading: false, users: activeUsersPage.content));
    } catch (e) {
      _handleError('Failed to load active users: $e');
    }
  }

  void _handleError(String message) {
    // В реальном приложении здесь можно добавить обработку ошибок
    // например, показать snackbar или обновить состояние ошибки
    debugPrint(message);
    emit(state.copyWith(isLoading: false, isLoadingFriends: false));
  }

  // Метод для загрузки следующей страницы пользователей
  Future<void> loadMoreUsers() async {
    if (state.isLoading || !state.hasMore) return;

    emit(state.copyWith(isLoading: true));
    try {
      final nextPage = state.currentPage;
      final usersPage = await _adminInterface.getAllUsers(
        page: nextPage,
        size: 20,
      );

      emit(
        state.copyWith(
          isLoading: false,
          users: [...state.users, ...usersPage.content],
          currentPage: nextPage + 1,
          hasMore: !usersPage.last,
        ),
      );
    } catch (e) {
      _handleError('Failed to load more users: $e');
    }
  }
}