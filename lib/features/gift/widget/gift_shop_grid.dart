import 'package:flutter/material.dart';
import 'package:meet_now_app_server/model/gifts/gift/gift.dart';

class GiftShopGrid extends StatelessWidget {
  final List<Gift> gifts;
  final Function(Gift) onGiftTap;

  const GiftShopGrid({super.key, required this.gifts, required this.onGiftTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: gifts.length,
      itemBuilder: (context, index) {
        final gift = gifts[index];
        return Card(
          child: InkWell(
            onTap: () => onGiftTap(gift),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.card_giftcard, size: 48),
                const SizedBox(height: 8),
                Text(
                  gift.name,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  '${gift.costPoints} points',
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
