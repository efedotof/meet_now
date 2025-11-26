import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'loading_stat_item.dart';

class LoadingStatsBar extends StatelessWidget {
  const LoadingStatsBar({super.key});

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          LoadingStatItem(label: S.of(context).online),
          LoadingStatItem(label: S.of(context).searching),
        ],
      ),
    );
  }
}
