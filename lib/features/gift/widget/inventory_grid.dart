import 'package:flutter/material.dart';
import 'package:meet_now_app_server/model/social/user_inventory/user_inventory.dart';

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
      return const Center(child: Text('У вас еще нет купленных подарков'));
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
        return Card(
          child: InkWell(
            onTap: () => onGiftTap(item),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory, size: 48),
                const SizedBox(height: 8),
                Text(
                  item.gift.name,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'Количество: ${item.quantity}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
