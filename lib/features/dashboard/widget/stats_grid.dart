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
      crossAxisCount: 4,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 0.9,
      children: [
        _buildStatCard(
          title: 'Total Users',
          value: state.totalUsers.toString(),
          subtitle: 'Registered',
          icon: Icons.people_outline,
          color: Colors.blue,
        ),
        _buildStatCard(
          title: 'Active Sessions',
          value: state.activeSessions.toString(),
          subtitle: 'Current',
          icon: Icons.videocam_outlined,
          color: Colors.green,
        ),
        _buildStatCard(
          title: 'Total Meetings',
          value: state.totalMeetings.toString(),
          subtitle: 'All time',
          icon: Icons.chat_outlined,
          color: Colors.orange,
        ),
        _buildStatCard(
          title: 'System Health',
          value: '${state.systemHealth.toStringAsFixed(1)}%',
          subtitle: 'Performance',
          icon: Icons.health_and_safety_outlined,
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
      elevation: 1,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 9, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
