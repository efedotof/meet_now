import 'package:flutter/material.dart';
import 'package:meet_now_admin_panel/features/system/cubit/system_cubit.dart';

class SystemPerformanceCard extends StatelessWidget {
  final SystemPerformance performance;

  const SystemPerformanceCard({super.key, required this.performance});

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
            Text(
              'Performance Metrics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildMetricItem(
                  'Response Time',
                  '${performance.averageResponseTime}ms',
                  Icons.speed,
                  Colors.blue,
                ),
                const SizedBox(width: 20),
                _buildMetricItem(
                  'Requests/Min',
                  performance.requestsPerMinute.toString(),
                  Icons.timeline,
                  Colors.green,
                ),
                const SizedBox(width: 20),
                _buildMetricItem(
                  'Error Rate',
                  '${performance.errorRate}%',
                  Icons.warning,
                  Colors.orange,
                ),
                const SizedBox(width: 20),
                _buildMetricItem(
                  'Active Users',
                  performance.activeUsers.toString(),
                  Icons.people,
                  Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 100,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: performance.history.map((point) {
                  final maxRequests = performance.history
                      .map((p) => p.requests)
                      .reduce((a, b) => a > b ? a : b);
                  final height = (point.requests / maxRequests) * 80;

                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${point.responseTime.toInt()}',
                          style: TextStyle(
                            fontSize: 8,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: height,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue[400]!, Colors.blue[600]!],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${point.requests}',
                          style: TextStyle(
                            fontSize: 8,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
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
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
