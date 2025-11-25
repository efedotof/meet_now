import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/gift/cubit/gift_cubit.dart';
import 'package:meet_now_app_server/model/gifts/gift/gift.dart';

class DailyGiftCard extends StatelessWidget {
  final bool isAvailable;
  final int streak;
  final Gift? lastClaimedGift;

  const DailyGiftCard({
    super.key,
    required this.isAvailable,
    required this.streak,
    this.lastClaimedGift,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.card_giftcard, size: 40, color: Colors.amber),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ежедневный подарок',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('Серия: $streak дней'),
                      if (!isAvailable)
                        const Text(
                          'Вы уже получили подарок сегодня',
                          style: TextStyle(color: Colors.grey),
                        ),
                    ],
                  ),
                ),
                if (isAvailable)
                  FilledButton(
                    onPressed: () => context.read<GiftCubit>().claimDailyGift(),
                    child: const Text('Получить'),
                  ),
              ],
            ),
            if (lastClaimedGift != null)
              Column(
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Последний подарок: ${lastClaimedGift!.name}',
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
