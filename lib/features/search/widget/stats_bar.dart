import 'package:flutter/material.dart';
import 'package:meet_now_app_server/model/social/user_stats/user_stats.dart';
import 'stat_item.dart';

class StatsBar extends StatelessWidget {
  final UserStats userStats;
  const StatsBar({super.key, required this.userStats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.outline, width: 1)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
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
