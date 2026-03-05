import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/social/user_inventory/user_inventory.dart';

import 'inventory_item.dart';

class InventoryGrid extends StatelessWidget {
  final List<UserInventory> inventory;
  final Function(UserInventory) onGiftTap;
  final bool isMobile;

  const InventoryGrid({
    super.key,
    required this.inventory,
    required this.onGiftTap,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    if (inventory.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
          child: Text(
            S.of(context).you_havent_bought_any_gifts_yet,
            style: TextStyle(fontSize: isMobile ? 16 : 18, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 2 : 3,
        crossAxisSpacing: isMobile ? 16 : 20,
        mainAxisSpacing: isMobile ? 16 : 20,
        childAspectRatio: isMobile ? 0.8 : 0.85,
      ),
      itemCount: inventory.length,
      itemBuilder: (context, index) {
        final item = inventory[index];
        return InventoryItem(inventoryItem: item, onTap: () => onGiftTap(item));
      },
    );
  }
}
