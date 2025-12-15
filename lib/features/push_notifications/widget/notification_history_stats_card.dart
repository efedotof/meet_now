import 'package:flutter/material.dart';
import 'package:meet_now_app_server/model/notification/notification_history_stats_dto/notification_history_stats_dto.dart';

class NotificationHistoryStatsCard extends StatelessWidget {
  final NotificationHistoryStatsDto stats;
  final Function(int) onCleanup;

  const NotificationHistoryStatsCard({
    super.key,
    required this.stats,
    required this.onCleanup,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Notification History Statistics',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
                const Spacer(),
                PopupMenuButton<int>(
                  icon: Icon(Icons.clean_hands),
                  tooltip: 'Cleanup old notifications',
                  onSelected: onCleanup,
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 30,
                      child: Text('Cleanup older than 30 days'),
                    ),
                    const PopupMenuItem(
                      value: 90,
                      child: Text('Cleanup older than 90 days'),
                    ),
                    const PopupMenuItem(
                      value: 180,
                      child: Text('Cleanup older than 180 days'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                _buildStatItem(
                  'Total',
                  stats.totalNotifications.toString(),
                  Icons.history,
                  Colors.blue,
                ),
                const VerticalDivider(),
                _buildStatItem(
                  'Successful',
                  stats.successfulNotifications.toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
                const VerticalDivider(),
                _buildStatItem(
                  'Failed',
                  stats.failedNotifications.toString(),
                  Icons.error,
                  Colors.red,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Success Rate
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  const Icon(Icons.trending_up, color: Colors.green),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Success Rate',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '${stats.successRate.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CircularProgressIndicator(
                    value: stats.successRate / 100,
                    backgroundColor: Colors.green[100],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Type Statistics
            if (stats.typeStatistics.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'By Type',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: stats.typeStatistics.map((typeStat) {
                      return Chip(
                        label: Text(
                          '${typeStat.notificationType}: ${typeStat.count}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: Colors.blue[50],
                      );
                    }).toList(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.grey[900],
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
