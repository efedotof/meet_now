import 'package:flutter/material.dart';
import 'package:meet_now_admin_panel/features/push_notifications/cubit/push_notifications_cubit.dart';
import 'package:meet_now_app_server/model/notification/notification_history_dto/notification_history_dto.dart';

import 'empty_notifications.dart';

class NotificationHistoryList extends StatefulWidget {
  final List<NotificationHistoryDto> notifications;
  final String searchQuery;
  final int currentPage;
  final int totalPages;
  final NotificationFilter? currentFilter;
  final String? filterValue;
  final ValueChanged<String> onSearch;
  final VoidCallback onClearFilters;
  final ValueChanged<String> onFilterByType;
  final ValueChanged<bool> onFilterByStatus;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<String> onUserHistory;
  final ValueChanged<String> onUserTokenStatus;

  const NotificationHistoryList({
    super.key,
    required this.notifications,
    required this.searchQuery,
    required this.currentPage,
    required this.totalPages,
    this.currentFilter,
    this.filterValue,
    required this.onSearch,
    required this.onClearFilters,
    required this.onFilterByType,
    required this.onFilterByStatus,
    required this.onPageChanged,
    required this.onUserHistory,
    required this.onUserTokenStatus,
  });

  @override
  State<NotificationHistoryList> createState() =>
      _NotificationHistoryListState();
}

class _NotificationHistoryListState extends State<NotificationHistoryList> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
  }

  @override
  void didUpdateWidget(NotificationHistoryList oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Обновляем контроллер только если значение изменилось извне
    if (widget.searchQuery != _searchController.text) {
      _searchController.text = widget.searchQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок и фильтры
        Row(
          children: [
            Text(
              'Notification History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
            const Spacer(),
            if (widget.currentFilter != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Chip(
                  label: Text(
                    _getFilterLabel(widget.currentFilter!, widget.filterValue),
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: Colors.blue[50],
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: widget.onClearFilters,
                ),
              ),
            _buildSearchField(),
          ],
        ),
        const SizedBox(height: 16),

        // Фильтры
        _buildFilters(),
        const SizedBox(height: 16),

        // Список
        if (widget.notifications.isEmpty)
          const EmptyNotifications()
        else
          ...widget.notifications.map(
            (notification) => NotificationHistoryCard(
              notification: notification,
              onUserHistory: widget.onUserHistory,
              onUserTokenStatus: widget.onUserTokenStatus,
            ),
          ),

        // Пагинация
        if (widget.totalPages > 1) _buildPagination(),

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSearchField() {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: _searchController,
        onChanged: widget.onSearch,
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

  Widget _buildFilters() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        FilterChip(
          label: const Text('Successful'),
          selected:
              widget.currentFilter == NotificationFilter.byStatus &&
              widget.filterValue == 'true',
          onSelected: (selected) => widget.onFilterByStatus(true),
        ),
        FilterChip(
          label: const Text('Failed'),
          selected:
              widget.currentFilter == NotificationFilter.byStatus &&
              widget.filterValue == 'false',
          onSelected: (selected) => widget.onFilterByStatus(false),
        ),
        FilterChip(
          label: const Text('Type: System'),
          selected:
              widget.currentFilter == NotificationFilter.byType &&
              widget.filterValue == 'system',
          onSelected: (selected) => widget.onFilterByType('system'),
        ),
        FilterChip(
          label: const Text('Type: User'),
          selected:
              widget.currentFilter == NotificationFilter.byType &&
              widget.filterValue == 'user',
          onSelected: (selected) => widget.onFilterByType('user'),
        ),
        FilterChip(
          label: const Text('Clear Filters'),
          selected: false,
          onSelected: (selected) => widget.onClearFilters(),
          backgroundColor: Colors.grey[200],
        ),
      ],
    );
  }

  Widget _buildPagination() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: widget.currentPage > 0
                  ? () => widget.onPageChanged(widget.currentPage - 1)
                  : null,
            ),
            Text('Page ${widget.currentPage + 1} of ${widget.totalPages}'),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: widget.currentPage < widget.totalPages - 1
                  ? () => widget.onPageChanged(widget.currentPage + 1)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  String _getFilterLabel(NotificationFilter filter, String? value) {
    switch (filter) {
      case NotificationFilter.byType:
        return 'Type: $value';
      case NotificationFilter.byStatus:
        return 'Status: ${value == 'true' ? 'Successful' : 'Failed'}';
      case NotificationFilter.byUser:
        return 'User: $value';
    }
  }
}

class NotificationHistoryCard extends StatelessWidget {
  final NotificationHistoryDto notification;
  final ValueChanged<String> onUserHistory;
  final ValueChanged<String> onUserTokenStatus;

  const NotificationHistoryCard({
    super.key,
    required this.notification,
    required this.onUserHistory,
    required this.onUserTokenStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок и статус
            Row(
              children: [
                _buildStatusIcon(),
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
                      ),
                    ],
                  ),
                ),
                _buildSuccessBadge(),
              ],
            ),
            const SizedBox(height: 12),

            // Детали
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildDetailItem(
                  Icons.person,
                  notification.targetUsername ?? 'Unknown User',
                  onTap: () {
                    if (notification.targetUserId.isNotEmpty) {
                      onUserHistory(notification.targetUserId);
                    }
                  },
                ),
                _buildDetailItem(Icons.category, notification.notificationType),
                _buildDetailItem(
                  Icons.calendar_today,
                  _formatDate(notification.sentAt),
                ),
                if (notification.errorMessage != null)
                  _buildErrorItem(notification.errorMessage!),
              ],
            ),

            // Действия
            if (notification.targetUserId.isNotEmpty)
              const SizedBox(height: 12),
            Row(
              children: [
                TextButton(
                  onPressed: () => onUserHistory(notification.targetUserId),
                  child: const Text('View User History'),
                ),
                TextButton(
                  onPressed: () => onUserTokenStatus(notification.targetUserId),
                  child: const Text('Check Token Status'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    Color color = notification.success ? Colors.green : Colors.red;
    IconData icon = notification.success ? Icons.check_circle : Icons.error;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildSuccessBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: notification.success ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        notification.success ? 'Success' : 'Failed',
        style: TextStyle(
          fontSize: 10,
          color: notification.success ? Colors.green[700] : Colors.red[700],
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[500]),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildErrorItem(String error) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.error_outline, size: 14, color: Colors.red),
        const SizedBox(width: 4),
        SizedBox(
          width: 200,
          child: Text(
            error,
            style: const TextStyle(fontSize: 12, color: Colors.red),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}
