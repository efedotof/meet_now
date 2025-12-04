import 'package:flutter/material.dart';
import 'package:meet_now_app_server/model/social/user_inventory/user_inventory.dart';

import 'inventory_item.dart';

class InventoryGrid extends StatelessWidget {
  final List<UserInventory> inventory;
  final Function(UserInventory) onGiftTap;

  const InventoryGrid({
    super.key,
    required this.inventory,
    required this.onGiftTap,
  });

  @override
  Widget build(BuildContext context) {
    if (inventory.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'У вас еще нет купленных подарков',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: inventory.length,
      itemBuilder: (context, index) {
        final item = inventory[index];
        return InventoryItem(inventoryItem: item, onTap: () => onGiftTap(item));
      },
    );
  }
}
