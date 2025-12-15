// users_stats_card.dart
import 'package:flutter/material.dart';

import 'user_ui_models.dart';

class UsersStatsCard extends StatelessWidget {
  final UsersStats stats;

  const UsersStatsCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            _buildStatItem(
              'Total Users',
              stats.totalUsers.toString(),
              Icons.people,
              Colors.blue,
            ),
            const VerticalDivider(),
            _buildStatItem(
              'Active',
              stats.activeUsers.toString(),
              Icons.online_prediction,
              Colors.green,
            ),
            const VerticalDivider(),
            _buildStatItem(
              'New Users',
              stats.newUsers.toString(),
              Icons.person_add,
              Colors.orange,
            ),
            const VerticalDivider(),
            _buildStatItem(
              'Premium',
              stats.premiumUsers.toString(),
              Icons.star,
              Colors.purple,
            ),
            const VerticalDivider(),
            _buildStatItem(
              'Blocked',
              stats.blockedUsers.toString(),
              Icons.block,
              Colors.red,
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
}
