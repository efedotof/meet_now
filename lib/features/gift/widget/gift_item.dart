import 'package:flutter/material.dart';
import 'package:meet_now_app_server/model/gifts/gift/gift.dart';

class GiftItem extends StatelessWidget {
  final Gift gift;
  final int? count;
  final bool isInShop;

  const GiftItem({
    super.key,
    required this.gift,
    this.count,
    this.isInShop = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: _getRarityColor(gift.rarity.name),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const Text('🎁', style: TextStyle(fontSize: 40)),
            ),

            const SizedBox(height: 8),

            Text(
              gift.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            Text(
              gift.description,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isInShop) ...[
                  Text('${gift.costPoints} ₽'),
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () => _showSendGiftDialog(context, gift),
                  ),
                ] else
                  Text('×$count'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getRarityColor(String rarity) {
    switch (rarity.toLowerCase()) {
      case 'common':
        return Colors.grey[300]!;
      case 'rare':
        return Colors.blue[100]!;
      case 'epic':
        return Colors.purple[100]!;
      case 'legendary':
        return Colors.orange[100]!;
      default:
        return Colors.grey[300]!;
    }
  }

  void _showSendGiftDialog(BuildContext context, Gift gift) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Отправить ${gift.name}'),
            content: const Text(
              'Функция отправки подарка будет реализована позже',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ОК'),
              ),
            ],
          ),
    );
  }
}
