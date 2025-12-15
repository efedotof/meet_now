part of 'push_notifications_cubit.dart';

@freezed
abstract class PushNotificationsState with _$PushNotificationsState {
  const factory PushNotificationsState({
    required bool isLoading,
    required bool isSending,
    required NotificationCompose composeData,
    required List<SentNotification> sentNotifications,
    required NotificationStats stats,
    required String searchQuery,
  }) = _PushNotificationsState;

  factory PushNotificationsState.initial() => PushNotificationsState(
    isLoading: true,
    isSending: false,
    composeData: NotificationCompose.empty(),
    sentNotifications: [],
    stats: NotificationStats.empty(),
    searchQuery: '',
  );
}

class NotificationCompose {
  final String title;
  final String message;
  final NotificationTarget target;
  final NotificationPriority priority;
  final DateTime? scheduledTime;
  final String? deepLink;
  final String? imageUrl;

  const NotificationCompose({
    required this.title,
    required this.message,
    required this.target,
    required this.priority,
    this.scheduledTime,
    this.deepLink,
    this.imageUrl,
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
    String? imageUrl,
  }) {
    return NotificationCompose(
      title: title ?? this.title,
      message: message ?? this.message,
      target: target ?? this.target,
      priority: priority ?? this.priority,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      deepLink: deepLink ?? this.deepLink,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

class SentNotification {
  final String id;
  final String title;
  final String message;
  final NotificationTarget target;
  final NotificationPriority priority;
  final DateTime sentAt;
  final int totalRecipients;
  final int delivered;
  final int opened;
  final NotificationStatus status;

  const SentNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.target,
    required this.priority,
    required this.sentAt,
    required this.totalRecipients,
    required this.delivered,
    required this.opened,
    required this.status,
  });
}

class NotificationStats {
  final int totalSent;
  final int totalDelivered;
  final int totalOpened;
  final double deliveryRate;
  final double openRate;
  final List<DailyStats> dailyStats;

  const NotificationStats({
    required this.totalSent,
    required this.totalDelivered,
    required this.totalOpened,
    required this.deliveryRate,
    required this.openRate,
    required this.dailyStats,
  });

  factory NotificationStats.empty() => const NotificationStats(
    totalSent: 0,
    totalDelivered: 0,
    totalOpened: 0,
    deliveryRate: 0.0,
    openRate: 0.0,
    dailyStats: [],
  );
}

class DailyStats {
  final DateTime date;
  final int sent;
  final int delivered;
  final int opened;

  const DailyStats({
    required this.date,
    required this.sent,
    required this.delivered,
    required this.opened,
  });
}

enum NotificationTarget {
  allUsers,
  activeUsers,
  inactiveUsers,
  premiumUsers,
  newUsers,
  customSegment,
}

enum NotificationPriority { low, normal, high, urgent }

enum NotificationStatus { scheduled, sending, sent, failed, cancelled }
