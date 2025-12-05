import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/gift/cubit/gift_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
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
                      Text(
                        S.of(context).a_daily_gift,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${S.of(context).series} $streak ${S.of(context).days}',
                      ),
                      if (!isAvailable)
                        Text(
                          S.of(context).have_you_already_received_a_gift_today,
                          style: TextStyle(color: Colors.grey),
                        ),
                    ],
                  ),
                ),
                if (isAvailable)
                  FilledButton(
                    onPressed: () => context.read<GiftCubit>().claimDailyGift(),
                    child: Text(S.of(context).receive),
                  ),
              ],
            ),
            if (lastClaimedGift != null)
              Column(
                children: [
                  const SizedBox(height: 8),
                  Text(
                    '${S.of(context).the_last_gift} ${lastClaimedGift!.name}',
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
