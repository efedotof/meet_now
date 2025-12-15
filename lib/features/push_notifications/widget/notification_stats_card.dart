import 'package:flutter/material.dart';
import 'package:meet_now_admin_panel/features/push_notifications/cubit/push_notifications_cubit.dart';

class NotificationStatsCard extends StatelessWidget {
  final NotificationStats stats;

  const NotificationStatsCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Notification Performance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildStatItem(
                  'Total Sent',
                  stats.totalSent.toString(),
                  Icons.send,
                  Colors.blue,
                ),
                const VerticalDivider(),
                _buildStatItem(
                  'Delivered',
                  stats.totalDelivered.toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
                const VerticalDivider(),
                _buildStatItem(
                  'Opened',
                  stats.totalOpened.toString(),
                  Icons.visibility,
                  Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildRateItem(
                  'Delivery Rate',
                  '${stats.deliveryRate.toStringAsFixed(1)}%',
                  Colors.green,
                ),
                const SizedBox(width: 20),
                _buildRateItem(
                  'Open Rate',
                  '${stats.openRate.toStringAsFixed(1)}%',
                  Colors.orange,
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
              color: color.withAlpha(1),
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

  Widget _buildRateItem(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withAlpha(1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
