import 'package:flutter/material.dart';

import 'loading_stat_item.dart';

class LoadingStatsBar extends StatelessWidget {
  const LoadingStatsBar({super.key});

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
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          LoadingStatItem(label: 'Online'),
          LoadingStatItem(label: 'Searching'),
        ],
      ),
    );
  }
}
