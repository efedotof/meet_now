import 'package:flutter/material.dart';
import 'package:meet_now_admin_panel/features/analytics/cubit/analytics_cubit.dart';

class AnalyticsOverview extends StatelessWidget {
  final AnalyticsData data;

  const AnalyticsOverview({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        _buildStatCard(
          title: 'Total Users',
          value: data.totalUsers.toString(),
          subtitle: 'Registered accounts',
          icon: Icons.people_outline,
          color: Colors.blue,
        ),
        _buildStatCard(
          title: 'Active Users',
          value: data.activeUsers.toString(),
          subtitle: 'Currently online',
          icon: Icons.online_prediction,
          color: Colors.green,
        ),
        _buildStatCard(
          title: 'New Users',
          value: data.newUsers.toString(),
          subtitle: 'Last 24 hours',
          icon: Icons.person_add,
          color: Colors.orange,
        ),
        _buildStatCard(
          title: 'Retention Rate',
          value: '${data.userRetentionRate.toStringAsFixed(1)}%',
          subtitle: 'Active/Total users',
          icon: Icons.trending_up,
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                Icon(Icons.more_vert, color: Colors.grey[400], size: 18),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(fontSize: 10, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}