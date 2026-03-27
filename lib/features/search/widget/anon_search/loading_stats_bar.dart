import 'package:flutter/material.dart';
import 'loading_stat_item.dart';

class LoadingStatsBar extends StatelessWidget {
  const LoadingStatsBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.outline.withAlpha(150))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [LoadingStatItem(), LoadingStatItem()],
      ),
    );
  }
}
