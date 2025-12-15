part of 'push_notifications_cubit.dart';

@freezed
abstract class PushNotificationsState with _$PushNotificationsState {
  const factory PushNotificationsState({
    required bool isLoading,
    required bool isSending,
    required NotificationCompose composeData,
    required List<NotificationHistoryDto> notificationHistory,
    required List<UserWithTokenDto> usersWithTokens,
    NotificationStatisticsDto? notificationStatistics,
    TokenCoverageDto? tokenCoverage,
    NotificationHistoryStatsDto? notificationHistoryStats,
    List<UserWithTokenDto>? onlineUsersWithTokens,
    UserTokenStatusDto? selectedUserTokenStatus,
    List<NotificationHistoryDto>? filteredHistory,
    NotificationFilter? currentFilter,
    String? filterValue,
    required String searchQuery,
    required int currentPage,
    required int totalPages,
    required int pageSize,
    String? errorMessage,
    String? successMessage,
  }) = _PushNotificationsState;

  factory PushNotificationsState.initial() => PushNotificationsState(
    isLoading: true,
    isSending: false,
    composeData: NotificationCompose.empty(),
    notificationHistory: [],
    usersWithTokens: [],
    searchQuery: '',
    currentPage: 0,
    totalPages: 0,
    pageSize: 10,
  );
}

enum NotificationTarget {
  allUsers,
  specificUser,
  specificToken,
  dataNotification,
}

enum NotificationPriority { low, normal, high, urgent }

enum NotificationFilter { byType, byStatus, byUser }

class NotificationCompose {
  final String title;
  final String message;
  final NotificationTarget target;
  final NotificationPriority priority;
  final DateTime? scheduledTime;
  final String? deepLink;
  final String? targetUserId;
  final String? targetPushToken;

  const NotificationCompose({
    required this.title,
    required this.message,
    required this.target,
    required this.priority,
    this.scheduledTime,
    this.deepLink,
    this.targetUserId,
    this.targetPushToken,
  });

  factory NotificationCompose.empty() => const NotificationCompose(
    title: '',
    message: '',
    target: NotificationTarget.allUsers,
    priority: NotificationPriority.normal,
  );

  NotificationCompose copyWith({
    String? title,
    String? message,
    NotificationTarget? target,
    NotificationPriority? priority,
    DateTime? scheduledTime,
    String? deepLink,
    String? targetUserId,
    String? targetPushToken,
  }) {
    return NotificationCompose(
      title: title ?? this.title,
      message: message ?? this.message,
      target: target ?? this.target,
      priority: priority ?? this.priority,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      deepLink: deepLink ?? this.deepLink,
      targetUserId: targetUserId ?? this.targetUserId,
      targetPushToken: targetPushToken ?? this.targetPushToken,
    );
  }
}
