import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/search/cubit/user_stats_cubit.dart';

class StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final String countKey;
  const StatItem({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.countKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userStats = context.read<UserStatsCubit>().state.maybeWhen(
      loaded: (stats) => stats,
      orElse: () => null,
    );
    final count =
        countKey == 'onlineCount'
            ? userStats?.onlineCount ?? 0
            : userStats?.searchingCount ?? 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          '$count',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(width: 2),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withAlpha(7),
          ),
        ),
      ],
    );
  }
}
