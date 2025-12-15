import 'package:flutter/material.dart';
import 'package:meet_now_app_server/model/notification/notification_statistics_dto/notification_statistics_dto.dart';
import 'package:meet_now_app_server/model/notification/token_coverage_dto/token_coverage_dto.dart';

class TokenCoverageCard extends StatelessWidget {
  final NotificationStatisticsDto statistics;
  final TokenCoverageDto coverage;

  const TokenCoverageCard({
    super.key,
    required this.statistics,
    required this.coverage,
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
            Text(
              'Token Coverage & Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 20),

            // Основная статистика
            Row(
              children: [
                _buildStatItem(
                  'Total Users',
                  statistics.totalUsers.toString(),
                  Icons.people,
                  Colors.blue,
                ),
                const VerticalDivider(),
                _buildStatItem(
                  'Users with Tokens',
                  statistics.totalUsersWithPushTokens.toString(),
                  Icons.notifications_active,
                  Colors.green,
                ),
                const VerticalDivider(),
                _buildStatItem(
                  'Online with Tokens',
                  statistics.onlineUsersWithPushTokens.toString(),
                  Icons.wifi,
                  Colors.orange,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Проценты покрытия
            Row(
              children: [
                _buildCoverageItem(
                  'Overall Coverage',
                  '${coverage.overallCoveragePercentage.toStringAsFixed(1)}%',
                  Colors.blue,
                  coverage.overallCoveragePercentage,
                ),
                const SizedBox(width: 12),
                _buildCoverageItem(
                  'Online Coverage',
                  '${coverage.onlineCoveragePercentage.toStringAsFixed(1)}%',
                  Colors.green,
                  coverage.onlineCoveragePercentage,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Детальная статистика
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 3,
              children: [
                _buildDetailItem(
                  'Offline with Tokens',
                  coverage.offlineUsersWithTokens.toString(),
                  Colors.grey[600]!,
                ),
                _buildDetailItem(
                  'Users without Tokens',
                  coverage.usersWithoutTokens.toString(),
                  Colors.red,
                ),
                _buildDetailItem(
                  'Registered Tokens',
                  statistics.totalRegisteredPushTokens.toString(),
                  Colors.purple,
                ),
                _buildDetailItem(
                  'Token Percentage',
                  '${statistics.percentageUsersWithTokens.toStringAsFixed(1)}%',
                  Colors.teal,
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
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCoverageItem(
    String label,
    String value,
    Color color,
    double percentage,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withAlpha(10),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: color.withAlpha(20),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(20)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: color.withAlpha(20),
            child: Text(
              value.substring(0, 1),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
