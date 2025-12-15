import 'package:flutter/material.dart';
import 'package:meet_now_admin_panel/features/system/cubit/system_cubit.dart';

class SystemHealthCard extends StatelessWidget {
  final SystemHealth systemHealth;

  const SystemHealthCard({super.key, required this.systemHealth});

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
                  'System Health',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
                const Spacer(),
                Icon(Icons.update, size: 16, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  'Updated ${_formatTime(systemHealth.lastUpdated)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildHealthMetric(
                  'CPU',
                  '${systemHealth.cpuUsage}%',
                  systemHealth.cpuUsage,
                  Colors.blue,
                ),
                const SizedBox(width: 16),
                _buildHealthMetric(
                  'Memory',
                  '${systemHealth.memoryUsage}%',
                  systemHealth.memoryUsage,
                  Colors.green,
                ),
                const SizedBox(width: 16),
                _buildHealthMetric(
                  'Disk',
                  '${systemHealth.diskUsage}%',
                  systemHealth.diskUsage,
                  Colors.orange,
                ),
                const SizedBox(width: 16),
                _buildHealthMetric(
                  'Network',
                  '${systemHealth.networkUsage}%',
                  systemHealth.networkUsage,
                  Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.people, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Active Connections:',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    systemHealth.activeConnections.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
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

  Widget _buildHealthMetric(
    String label,
    String value,
    double usage,
    Color color,
  ) {
    return Expanded(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: usage / 100,
                  strokeWidth: 6,
                  backgroundColor: color.withAlpha(2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) return 'just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    return '${difference.inHours}h ago';
  }
}
