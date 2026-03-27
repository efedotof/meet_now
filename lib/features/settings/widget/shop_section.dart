import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/route/app_route.dart';

import 'settings_card.dart';
import 'settings_item.dart';

class ShopSection extends StatelessWidget {
  const ShopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).shop,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        
        const SizedBox(height: 8),

        SettingsCard(
          items: [
            SettingsItem(
              icon: Icons.shopping_bag_rounded,
              title: S.of(context).shop,
              onTap: () => context.pushRoute(GiftRoute()),
            ),
            SettingsItem(
              icon: Icons.card_giftcard,
              title: S.of(context).purchased,
              onTap: () => context.pushRoute(GiftRoute(isInventory: true)),
            ),
          ],
        ),
      ],
    );
  }
}
