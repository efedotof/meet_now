import 'package:flutter/material.dart';
import 'package:meet_now_app_server/model/social/user_stats/user_stats.dart';
import 'stat_item.dart';

class StatsBar extends StatelessWidget {
  final UserStats userStats;
  const StatsBar({super.key, required this.userStats});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(
            color: colors.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StatItem(
            icon: Icons.circle,
            count: userStats.onlineCount,
            label: "Online",
          ),
          StatItem(
            icon: Icons.circle_outlined,
            count: userStats.searchingCount,
            label: "Searching",
          ),
        ],
      ),
    );
  }
}
