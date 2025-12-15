import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/model/notification/notification_history_dto/notification_history_dto.dart';
import 'package:meet_now_app_server/model/notification/notification_history_stats_dto/notification_history_stats_dto.dart';
import 'package:meet_now_app_server/model/notification/notification_log_request/notification_log_request.dart';
import 'package:meet_now_app_server/model/notification/notification_statistics_dto/notification_statistics_dto.dart';
import 'package:meet_now_app_server/model/notification/token_coverage_dto/token_coverage_dto.dart';
import 'package:meet_now_app_server/model/notification/user_token_status_dto/user_token_status_dto.dart';
import 'package:meet_now_app_server/model/notification/user_with_token_dto/user_with_token_dto.dart';
import 'package:meet_now_app_server/model/social/notification/notification_request/notification_request.dart';
import 'package:meet_now_app_server/repository/admin/admin_interface.dart';

part 'push_notifications_state.dart';
part 'push_notifications_cubit.freezed.dart';

class PushNotificationsCubit extends Cubit<PushNotificationsState> {
  PushNotificationsCubit({required AdminInterface adminInterface})
    : _adminInterface = adminInterface,
      super(PushNotificationsState.initial()) {
    loadAllData();
  }

  final AdminInterface _adminInterface;

  Future<void> loadAllData() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      // Загружаем все данные параллельно
      await Future.wait([
        _loadNotificationStatistics(),
        _loadTokenCoverage(),
        _loadNotificationHistoryStats(),
        _loadNotificationHistory(),
        _loadUsersWithTokens(),
      ]);

      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _loadNotificationStatistics() async {
    try {
      final stats = await _adminInterface.getNotificationStatistics();
      emit(state.copyWith(notificationStatistics: stats));
    } catch (e) {
      // Логируем ошибку, но не останавливаем загрузку других данных
      print('Error loading notification statistics: $e');
    }
  }

  Future<void> _loadTokenCoverage() async {
    try {
      final coverage = await _adminInterface.getTokenCoverageStatistics();
      emit(state.copyWith(tokenCoverage: coverage));
    } catch (e) {
      print('Error loading token coverage: $e');
    }
  }

  Future<void> _loadNotificationHistoryStats() async {
    try {
      final historyStats = await _adminInterface
          .getNotificationHistoryStatistics();
      emit(state.copyWith(notificationHistoryStats: historyStats));
    } catch (e) {
      print('Error loading notification history stats: $e');
    }
  }

  Future<void> _loadNotificationHistory() async {
    try {
      final historyPage = await _adminInterface.getNotificationHistory(
        page: state.currentPage,
        size: state.pageSize,
      );
      emit(
        state.copyWith(
          notificationHistory: historyPage.content,
          totalPages: historyPage.totalPages,
          currentPage: historyPage.number,
        ),
      );
    } catch (e) {
      print('Error loading notification history: $e');
    }
  }

  Future<void> _loadUsersWithTokens() async {
    try {
      final users = await _adminInterface.getUsersWithPushTokens();
      emit(state.copyWith(usersWithTokens: users));
    } catch (e) {
      print('Error loading users with tokens: $e');
    }
  }

  Future<void> loadUserTokenStatus(String userId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final status = await _adminInterface.getUserTokenStatus(userId: userId);
      emit(state.copyWith(isLoading: false, selectedUserTokenStatus: status));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load user token status: $e',
        ),
      );
    }
  }

  Future<void> loadOnlineUsersWithTokens() async {
    emit(state.copyWith(isLoading: true));
    try {
      final onlineUsers = await _adminInterface.getOnlineUsersWithPushTokens();
      emit(
        state.copyWith(isLoading: false, onlineUsersWithTokens: onlineUsers),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load online users: $e',
        ),
      );
    }
  }

  Future<void> loadNotificationHistoryByType(String notificationType) async {
    emit(state.copyWith(isLoading: true));
    try {
      final history = await _adminInterface.getNotificationHistoryByType(
        notificationType: notificationType,
        page: 0,
        size: state.pageSize,
      );
      emit(
        state.copyWith(
          isLoading: false,
          filteredHistory: history.content,
          currentFilter: NotificationFilter.byType,
          filterValue: notificationType,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load history by type: $e',
        ),
      );
    }
  }

  Future<void> loadNotificationHistoryByStatus(bool success) async {
    emit(state.copyWith(isLoading: true));
    try {
      final history = await _adminInterface.getNotificationHistoryByStatus(
        status: success,
        page: 0,
        size: state.pageSize,
      );
      emit(
        state.copyWith(
          isLoading: false,
          filteredHistory: history.content,
          currentFilter: NotificationFilter.byStatus,
          filterValue: success.toString(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load history by status: $e',
        ),
      );
    }
  }

  Future<void> loadUserNotificationHistory(String userId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final history = await _adminInterface.getUserNotificationHistory(
        userId: userId,
        page: 0,
        size: state.pageSize,
      );
      emit(
        state.copyWith(
          isLoading: false,
          filteredHistory: history.content,
          currentFilter: NotificationFilter.byUser,
          filterValue: userId,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load user history: $e',
        ),
      );
    }
  }

  Future<void> sendNotification() async {
    if (state.composeData.title.isEmpty || state.composeData.message.isEmpty) {
      emit(state.copyWith(errorMessage: 'Title and message are required'));
      return;
    }

    emit(state.copyWith(isSending: true, errorMessage: null));

    try {
      final request = NotificationRequest(
        message: state.composeData.message,
        title: state.composeData.title,
        action: state.composeData.deepLink,
      );

      switch (state.composeData.target) {
        case NotificationTarget.allUsers:
          await _adminInterface.sendAllUserNotification(request: request);
          break;
        case NotificationTarget.specificUser:
          if (state.composeData.targetUserId != null) {
            await _adminInterface.sendUserNotification(
              userId: state.composeData.targetUserId!,
              request: request,
            );
          }
          break;
        case NotificationTarget.specificToken:
          if (state.composeData.targetPushToken != null) {
            await _adminInterface.sendTokenNotification(
              pushToken: state.composeData.targetPushToken!,
              request: request,
            );
          }
          break;
        case NotificationTarget.dataNotification:
          if (state.composeData.targetPushToken != null) {
            await _adminInterface.sendDataNotification(
              pushToken: state.composeData.targetPushToken!,
              request: request,
            );
          }
          break;
      }

      // Логируем отправку
      await _adminInterface.logNotification(
        request: NotificationLogRequest(
          userId: state.composeData.targetUserId ?? 'system',
          title: state.composeData.title,
          message: state.composeData.message,
          notificationType: state.composeData.target.toString(),
          success: true,
        ),
      );

      // Обновляем данные
      await loadAllData();

      emit(
        state.copyWith(
          isSending: false,
          composeData: NotificationCompose.empty(),
          successMessage: 'Notification sent successfully',
        ),
      );

      // Очищаем сообщение об успехе через 3 секунды
      await Future.delayed(const Duration(seconds: 3));
      emit(state.copyWith(successMessage: null));
    } catch (e) {
      // Логируем ошибку
      await _adminInterface.logNotification(
        request: NotificationLogRequest(
          userId: state.composeData.targetUserId ?? 'system',
          title: state.composeData.title,
          message: state.composeData.message,
          notificationType: state.composeData.target.toString(),
          success: false,
          errorMessage: e.toString(),
        ),
      );

      emit(
        state.copyWith(
          isSending: false,
          errorMessage: 'Failed to send notification: $e',
        ),
      );
    }
  }

  Future<void> cleanupOldNotifications(int days) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _adminInterface.cleanupOldNotifications(days: days);
      emit(state.copyWith(isLoading: false, successMessage: result));

      // Обновляем историю
      await _loadNotificationHistory();

      await Future.delayed(const Duration(seconds: 3));
      emit(state.copyWith(successMessage: null));
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, errorMessage: 'Cleanup failed: $e'),
      );
    }
  }

  void updateComposeTitle(String title) {
    emit(state.copyWith(composeData: state.composeData.copyWith(title: title)));
  }

  void updateComposeMessage(String message) {
    emit(
      state.copyWith(composeData: state.composeData.copyWith(message: message)),
    );
  }

  void updateComposeTarget(NotificationTarget target) {
    emit(
      state.copyWith(composeData: state.composeData.copyWith(target: target)),
    );
  }

  void updateComposeTargetUserId(String? userId) {
    emit(
      state.copyWith(
        composeData: state.composeData.copyWith(targetUserId: userId),
      ),
    );
  }

  void updateComposeTargetPushToken(String? pushToken) {
    emit(
      state.copyWith(
        composeData: state.composeData.copyWith(targetPushToken: pushToken),
      ),
    );
  }

  void updateComposePriority(NotificationPriority priority) {
    emit(
      state.copyWith(
        composeData: state.composeData.copyWith(priority: priority),
      ),
    );
  }

  void updateComposeSchedule(DateTime? scheduledTime) {
    emit(
      state.copyWith(
        composeData: state.composeData.copyWith(scheduledTime: scheduledTime),
      ),
    );
  }

  void updateComposeDeepLink(String deepLink) {
    emit(
      state.copyWith(
        composeData: state.composeData.copyWith(deepLink: deepLink),
      ),
    );
  }

  void search(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void clearFilters() {
    emit(
      state.copyWith(
        currentFilter: null,
        filterValue: null,
        filteredHistory: null,
        searchQuery: '',
      ),
    );
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  void clearSuccessMessage() {
    emit(state.copyWith(successMessage: null));
  }

  void changePage(int page) {
    if (page >= 0 && page < state.totalPages) {
      emit(state.copyWith(currentPage: page));
      _loadNotificationHistory();
    }
  }

  Future<void> refresh() async {
    await loadAllData();
  }
}
