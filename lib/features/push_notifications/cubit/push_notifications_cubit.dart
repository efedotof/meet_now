import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/repository/admin/admin_interface.dart';

part 'push_notifications_state.dart';
part 'push_notifications_cubit.freezed.dart';

class PushNotificationsCubit extends Cubit<PushNotificationsState> {
  PushNotificationsCubit({required AdminInterface adminInterface}) : _adminInterface = adminInterface, super(PushNotificationsState.initial()) {
    _loadNotificationsData();
  }

  final AdminInterface _adminInterface;

  Future<void> _loadNotificationsData() async {
    await Future.delayed(const Duration(seconds: 2));

    final sentNotifications = [
      SentNotification(
        id: '1',
        title: 'New Features Available!',
        message: 'Check out the latest updates in Meet Now',
        target: NotificationTarget.allUsers,
        priority: NotificationPriority.normal,
        sentAt: DateTime.now().subtract(const Duration(hours: 2)),
        totalRecipients: 15420,
        delivered: 14210,
        opened: 8920,
        status: NotificationStatus.sent,
      ),
      SentNotification(
        id: '2',
        title: 'Premium Subscription Expiring',
        message: 'Your premium subscription will expire in 3 days',
        target: NotificationTarget.premiumUsers,
        priority: NotificationPriority.high,
        sentAt: DateTime.now().subtract(const Duration(days: 1)),
        totalRecipients: 2450,
        delivered: 2310,
        opened: 1560,
        status: NotificationStatus.sent,
      ),
      SentNotification(
        id: '3',
        title: 'Welcome to Meet Now!',
        message: 'Get started with your first meeting',
        target: NotificationTarget.newUsers,
        priority: NotificationPriority.normal,
        sentAt: DateTime.now().subtract(const Duration(days: 3)),
        totalRecipients: 450,
        delivered: 420,
        opened: 380,
        status: NotificationStatus.sent,
      ),
      SentNotification(
        id: '4',
        title: 'System Maintenance',
        message: 'Scheduled maintenance this weekend',
        target: NotificationTarget.allUsers,
        priority: NotificationPriority.high,
        sentAt: DateTime.now().subtract(const Duration(days: 5)),
        totalRecipients: 15420,
        delivered: 14890,
        opened: 11230,
        status: NotificationStatus.sent,
      ),
      SentNotification(
        id: '5',
        title: 'Meeting Reminder',
        message: 'Your team meeting starts in 30 minutes',
        target: NotificationTarget.customSegment,
        priority: NotificationPriority.urgent,
        sentAt: DateTime.now().subtract(const Duration(days: 7)),
        totalRecipients: 25,
        delivered: 24,
        opened: 22,
        status: NotificationStatus.sent,
      ),
    ];

    final dailyStats = [
      DailyStats(
        date: DateTime.now().subtract(const Duration(days: 6)),
        sent: 3,
        delivered: 2,
        opened: 1,
      ),
      DailyStats(
        date: DateTime.now().subtract(const Duration(days: 5)),
        sent: 5,
        delivered: 4,
        opened: 3,
      ),
      DailyStats(
        date: DateTime.now().subtract(const Duration(days: 4)),
        sent: 2,
        delivered: 2,
        opened: 1,
      ),
      DailyStats(
        date: DateTime.now().subtract(const Duration(days: 3)),
        sent: 8,
        delivered: 7,
        opened: 5,
      ),
      DailyStats(
        date: DateTime.now().subtract(const Duration(days: 2)),
        sent: 6,
        delivered: 5,
        opened: 4,
      ),
      DailyStats(
        date: DateTime.now().subtract(const Duration(days: 1)),
        sent: 4,
        delivered: 4,
        opened: 3,
      ),
      DailyStats(date: DateTime.now(), sent: 2, delivered: 2, opened: 1),
    ];

    final totalSent = sentNotifications.fold(
      0,
      (sum, notification) => sum + notification.totalRecipients,
    );
    final totalDelivered = sentNotifications.fold(
      0,
      (sum, notification) => sum + notification.delivered,
    );
    final totalOpened = sentNotifications.fold(
      0,
      (sum, notification) => sum + notification.opened,
    );

    final stats = NotificationStats(
      totalSent: totalSent,
      totalDelivered: totalDelivered,
      totalOpened: totalOpened,
      deliveryRate: totalSent > 0 ? (totalDelivered / totalSent) * 100 : 0.0,
      openRate: totalDelivered > 0 ? (totalOpened / totalDelivered) * 100 : 0.0,
      dailyStats: dailyStats,
    );

    emit(
      state.copyWith(
        isLoading: false,
        sentNotifications: sentNotifications,
        stats: stats,
      ),
    );
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

  Future<void> sendNotification() async {
    emit(state.copyWith(isSending: true));

    // Simulate API call
    await Future.delayed(const Duration(seconds: 3));

    final newNotification = SentNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: state.composeData.title,
      message: state.composeData.message,
      target: state.composeData.target,
      priority: state.composeData.priority,
      sentAt: DateTime.now(),
      totalRecipients: _calculateRecipientsCount(state.composeData.target),
      delivered: 0,
      opened: 0,
      status: NotificationStatus.sent,
    );

    final updatedNotifications = [newNotification, ...state.sentNotifications];

    emit(
      state.copyWith(
        isSending: false,
        sentNotifications: updatedNotifications,
        composeData: NotificationCompose.empty(),
      ),
    );
  }

  int _calculateRecipientsCount(NotificationTarget target) {
    switch (target) {
      case NotificationTarget.allUsers:
        return 15420;
      case NotificationTarget.activeUsers:
        return 8920;
      case NotificationTarget.inactiveUsers:
        return 3200;
      case NotificationTarget.premiumUsers:
        return 2450;
      case NotificationTarget.newUsers:
        return 450;
      case NotificationTarget.customSegment:
        return 120;
    }
  }

  Future<void> refresh() async {
    emit(state.copyWith(isLoading: true));
    await _loadNotificationsData();
  }
}
