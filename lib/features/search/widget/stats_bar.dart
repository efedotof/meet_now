import 'package:flutter/material.dart';
import 'package:meet_now_app_server/model/social/user_stats/user_stats.dart';

import 'stat_item.dart';

class StatsBar extends StatelessWidget {
  final UserStats userStats;
  const StatsBar({super.key, required this.userStats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.primaryColor.withAlpha(1),
        border: Border(
          top: BorderSide(color: theme.dividerColor.withAlpha(1), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          StatItem(
            icon: Icons.person,
            countKey: 'onlineCount',
            label: 'Online',
            color: Colors.green,
          ),
          StatItem(
            icon: Icons.search,
            countKey: 'searchingCount',
            label: 'Searching',
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
