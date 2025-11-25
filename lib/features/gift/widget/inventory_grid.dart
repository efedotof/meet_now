import 'package:flutter/material.dart';
import 'package:meet_now_app_server/model/social/user_inventory/user_inventory.dart';

import 'gift_item.dart';

class InventoryGrid extends StatelessWidget {
  final List<UserInventory> inventory;

  const InventoryGrid({super.key, required this.inventory});

  @override
  Widget build(BuildContext context) {
    if (inventory.isEmpty) {
      return const Center(child: Text('Инвентарь пуст'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: inventory.length,
      itemBuilder: (context, index) {
        final item = inventory[index];
        return GiftItem(gift: item.gift, count: item.quantity);
      },
    );
  }
}
