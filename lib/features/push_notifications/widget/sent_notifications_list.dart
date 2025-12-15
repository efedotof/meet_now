import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/push_notifications/cubit/push_notifications_cubit.dart';

class SentNotificationsList extends StatelessWidget {
  final List<SentNotification> notifications;
  final String searchQuery;

  const SentNotificationsList({
    super.key,
    required this.notifications,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final filteredNotifications = notifications.where((notification) {
      final query = searchQuery.toLowerCase();
      return notification.title.toLowerCase().contains(query) ||
          notification.message.toLowerCase().contains(query) ||
          notification.target.toString().toLowerCase().contains(query);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Sent Notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
            const Spacer(),
            _buildSearchField(context),
          ],
        ),
        const SizedBox(height: 16),
        if (filteredNotifications.isEmpty)
          const EmptyNotifications()
        else
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: filteredNotifications.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return SentNotificationCard(
                notification: filteredNotifications[index],
              );
            },
          ),
      ],
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return SizedBox(
      width: 200,
      child: TextField(
        onChanged: (query) =>
            context.read<PushNotificationsCubit>().search(query),
        decoration: InputDecoration(
          hintText: 'Search...',
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          prefixIcon: const Icon(Icons.search, size: 20),
        ),
      ),
    );
  }
}

class SentNotificationCard extends StatelessWidget {
  final SentNotification notification;

  const SentNotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildPriorityIcon(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[900],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.people, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  _getTargetText(notification.target),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  _formatDate(notification.sentAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const Spacer(),
                _buildStats(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityIcon() {
    Color color;
    IconData icon;

    switch (notification.priority) {
      case NotificationPriority.low:
        color = Colors.green;
        icon = Icons.low_priority;
        break;
      case NotificationPriority.normal:
        color = Colors.blue;
        icon = Icons.notifications_none;
        break;
      case NotificationPriority.high:
        color = Colors.orange;
        icon = Icons.notifications;
        break;
      case NotificationPriority.urgent:
        color = Colors.red;
        icon = Icons.notification_important;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withAlpha(1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }

  Widget _buildStatusBadge() {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (notification.status) {
      case NotificationStatus.scheduled:
        backgroundColor = Colors.blue[50]!;
        textColor = Colors.blue[700]!;
        text = 'Scheduled';
        break;
      case NotificationStatus.sending:
        backgroundColor = Colors.orange[50]!;
        textColor = Colors.orange[700]!;
        text = 'Sending';
        break;
      case NotificationStatus.sent:
        backgroundColor = Colors.green[50]!;
        textColor = Colors.green[700]!;
        text = 'Sent';
        break;
      case NotificationStatus.failed:
        backgroundColor = Colors.red[50]!;
        textColor = Colors.red[700]!;
        text = 'Failed';
        break;
      case NotificationStatus.cancelled:
        backgroundColor = Colors.grey[200]!;
        textColor = Colors.grey[700]!;
        text = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStats() {
    final deliveryRate =
        (notification.delivered / notification.totalRecipients * 100);
    final openRate = (notification.opened / notification.delivered * 100);

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${deliveryRate.toStringAsFixed(1)}% delivered',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${openRate.toStringAsFixed(1)}% opened',
              style: TextStyle(
                fontSize: 12,
                color: Colors.orange[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getTargetText(NotificationTarget target) {
    switch (target) {
      case NotificationTarget.allUsers:
        return 'All Users';
      case NotificationTarget.activeUsers:
        return 'Active Users';
      case NotificationTarget.inactiveUsers:
        return 'Inactive Users';
      case NotificationTarget.premiumUsers:
        return 'Premium Users';
      case NotificationTarget.newUsers:
        return 'New Users';
      case NotificationTarget.customSegment:
        return 'Custom Segment';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${difference.inDays ~/ 7}w ago';
  }
}

class EmptyNotifications extends StatelessWidget {
  const EmptyNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(Icons.notifications_none, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No Notifications Sent',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Send your first notification to engage with users',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
