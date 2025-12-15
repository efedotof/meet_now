import 'package:flutter/material.dart';
import 'package:meet_now_admin_panel/features/dashboard/cubit/dashboard_cubit.dart';

class SystemAlerts extends StatelessWidget {
  final List<SystemAlert> alerts;

  const SystemAlerts({super.key, required this.alerts});

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return Card(
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'System Alerts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[900],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[100]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.green[600],
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'All systems are operating normally',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'System Alerts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 16),
            ...alerts.map((alert) => _buildAlertItem(alert)),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertItem(SystemAlert alert) {
    Color backgroundColor;
    Color iconColor;
    IconData icon;

    switch (alert.type) {
      case AlertType.info:
        backgroundColor = Colors.blue[50]!;
        iconColor = Colors.blue[600]!;
        icon = Icons.info_outline;
        break;
      case AlertType.warning:
        backgroundColor = Colors.orange[50]!;
        iconColor = Colors.orange[600]!;
        icon = Icons.warning_amber_outlined;
        break;
      case AlertType.error:
        backgroundColor = Colors.red[50]!;
        iconColor = Colors.red[600]!;
        icon = Icons.error_outline;
        break;
      case AlertType.success:
        backgroundColor = Colors.green[50]!;
        iconColor = Colors.green[600]!;
        icon = Icons.check_circle_outline;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: iconColor.withAlpha(3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alert.message,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(alert.timestamp),
                  style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }
}
