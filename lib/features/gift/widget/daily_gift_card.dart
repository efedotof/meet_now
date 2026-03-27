import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/gift/cubit/gift_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/gifts/gift/gift.dart';

class DailyGiftCard extends StatelessWidget {
  final bool isAvailable;
  final int streak;
  final Gift? lastClaimedGift;
  final bool isMobile;

  const DailyGiftCard({
    super.key,
    required this.isAvailable,
    required this.streak,
    required this.isMobile,
    this.lastClaimedGift,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 12,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(12),
                  child: Icon(
                    Icons.card_giftcard,
                    size: isMobile ? 32 : 40,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: isMobile ? 12 : 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).a_daily_gift,
                        style: TextStyle(
                          fontSize: isMobile ? 18 : 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${S.of(context).series} $streak ${S.of(context).days}',
                        style: TextStyle(fontSize: isMobile ? null : 16),
                      ),
                      if (!isAvailable)
                        Text(
                          S.of(context).have_you_already_received_a_gift_today,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: isMobile ? null : 15,
                          ),
                        ),
                    ],
                  ),
                ),
                if (isAvailable)
                  FilledButton(
                    onPressed: () => context.read<GiftCubit>().claimDailyGift(),
                    child: Text(
                      S.of(context).receive,
                      style: TextStyle(fontSize: isMobile ? null : 16),
                    ),
                  ),
              ],
            ),
            if (lastClaimedGift != null)
              Column(
                children: [
                  SizedBox(height: isMobile ? 8 : 12),
                  Text(
                    '${S.of(context).the_last_gift} ${lastClaimedGift!.name}',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: isMobile ? null : 16,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
