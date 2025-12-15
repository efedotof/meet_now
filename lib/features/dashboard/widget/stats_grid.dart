import 'package:flutter/material.dart';
import 'package:meet_now_admin_panel/features/dashboard/cubit/dashboard_cubit.dart';

class StatsGrid extends StatelessWidget {
  final DashboardState state;

  const StatsGrid({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
          title: 'Total Users',
          value: state.totalUsers.toString(),
          subtitle: 'Registered accounts',
          icon: Icons.people_outline,
          color: Colors.blue,
          trend: _calculateUserTrend(state),
        ),
        _buildStatCard(
          title: 'Active Sessions',
          value: state.activeSessions.toString(),
          subtitle: 'Current meetings',
          icon: Icons.videocam_outlined,
          color: Colors.green,
          trend: _calculateSessionTrend(state),
        ),
        _buildStatCard(
          title: 'Total Meetings',
          value: state.totalMeetings.toString(),
          subtitle: 'Active chats',
          icon: Icons.chat_outlined,
          color: Colors.orange,
          trend: _calculateMeetingTrend(state),
        ),
        _buildStatCard(
          title: 'System Health',
          value: '${state.systemHealth.toStringAsFixed(1)}%',
          subtitle: 'Performance score',
          icon: Icons.health_and_safety_outlined,
          color: Colors.purple,
          trend: state.systemHealth > 90
              ? 1
              : state.systemHealth > 70
              ? 0
              : -1,
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
    required int trend,
  }) {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withAlpha(1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                _buildTrendIndicator(trend, color),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendIndicator(int trend, Color color) {
    IconData icon;
    Color trendColor;

    switch (trend) {
      case 1:
        icon = Icons.trending_up;
        trendColor = Colors.green;
        break;
      case -1:
        icon = Icons.trending_down;
        trendColor = Colors.red;
        break;
      default:
        icon = Icons.trending_flat;
        trendColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: trendColor.withAlpha(1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: 16, color: trendColor),
    );
  }

  int _calculateUserTrend(DashboardState state) {
    return state.newUsers > 100
        ? 1
        : state.newUsers > 50
        ? 0
        : -1;
  }

  int _calculateSessionTrend(DashboardState state) {
    return state.activeSessions > state.totalUsers * 0.1 ? 1 : 0;
  }

  int _calculateMeetingTrend(DashboardState state) {
    return state.totalMeetings > state.activeSessions * 2 ? 1 : 0;
  }
}
