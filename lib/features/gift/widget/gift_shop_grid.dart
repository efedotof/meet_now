import 'package:flutter/material.dart';
import 'package:meet_now_app_server/model/gifts/gift/gift.dart';
import 'gift_item.dart';

class GiftShopGrid extends StatelessWidget {
  final List<Gift> gifts;

  const GiftShopGrid({super.key, required this.gifts});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: gifts.length,
      itemBuilder: (context, index) {
        final gift = gifts[index];
        return GiftItem(gift: gift, isInShop: true);
      },
    );
  }
}
