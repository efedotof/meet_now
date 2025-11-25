import 'package:flutter/material.dart';
import 'package:meet_now_app_server/model/gifts/gift_stats/gift_stats.dart';

import 'stat_item.dart';

class StatsCard extends StatelessWidget {
  final GiftStats stats;

  const StatsCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StatItem('Отправлено', stats.sentCount.toString()),
            StatItem('Получено', stats.receivedCount.toString()),
            StatItem('В инвентаре', stats.inventoryCount.toString()),
          ],
        ),
      ),
    );
  }
}
