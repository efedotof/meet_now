import 'package:flutter/material.dart';
import 'package:meet_now_app_server/model/gifts/gift/gift.dart';
import 'package:meet_now_app_server/model/gifts/gift_stats/gift_stats.dart';
import 'package:meet_now_app_server/model/social/user_inventory/user_inventory.dart';

import 'daily_gift_card.dart';
import 'gift_shop_grid.dart';
import 'inventory_grid.dart';
import 'stats_card.dart';

class GiftContent extends StatefulWidget {
  final List<Gift> gifts;
  final List<UserInventory> inventory;
  final bool isDailyAvailable;
  final int streak;
  final GiftStats stats;
  final Gift? lastClaimedGift;

  const GiftContent({
    super.key,
    required this.gifts,
    required this.inventory,
    required this.isDailyAvailable,
    required this.streak,
    required this.stats,
    this.lastClaimedGift,
  });

  @override
  State<GiftContent> createState() => _GiftContentState();
}

class _GiftContentState extends State<GiftContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DailyGiftCard(
          isAvailable: widget.isDailyAvailable,
          streak: widget.streak,
          lastClaimedGift: widget.lastClaimedGift,
        ),

        StatsCard(stats: widget.stats),

        TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Магазин'), Tab(text: 'Инвентарь')],
        ),

        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              GiftShopGrid(gifts: widget.gifts),
              InventoryGrid(inventory: widget.inventory),
            ],
          ),
        ),
      ],
    );
  }
}
