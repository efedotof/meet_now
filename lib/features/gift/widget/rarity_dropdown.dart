import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/gift/cubit/gift_cubit.dart';
import 'package:meet_now_app_server/model/gifts/buy_gift_response/buy_gift_response.dart';
import 'package:meet_now_app_server/model/gifts/gift/gift.dart';
import 'package:meet_now_app_server/model/gifts/gift_rarity/gift_rarity.dart';
import 'package:meet_now_app_server/model/gifts/gift_stats/gift_stats.dart';
import 'package:meet_now_app_server/model/gifts/gift_type/gift_type.dart';
import 'package:meet_now_app_server/model/social/user_inventory/user_inventory.dart';

class RarityDropdown extends StatelessWidget {
  const RarityDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.brightnessOf(context) == Brightness.dark;

    return BlocBuilder<GiftCubit, GiftState>(
      builder: (context, state) {
        return state.maybeWhen(
          loaded: (
            List<Gift> gifts,
            List<Gift> allGifts,
            List<UserInventory> inventory,
            bool isDailyGiftAvailable,
            int currentStreak,
            GiftStats giftStats,
            List<GiftRarity> rarities,
            List<GiftType> allTypes,
            Set<String> selectedTypeIds,
            String searchQuery,
            Gift? lastClaimedGift,
            GiftRarity? selectedRarity,
            PriceRange? selectedPriceRange,
            bool isBuyingGift,
            GiftView currentView,
            BuyGiftResponse? lastPurchaseResponse,
          ) {
            if (rarities.isEmpty) return const SizedBox();

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? Colors.white12 : Colors.black12,
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(16),
              ),
              child: DropdownButton<String>(
                value: selectedRarity?.id,
                isDense: true,
                underline: Container(),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  size: 16,
                  color: Colors.grey,
                ),
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Все', style: TextStyle(fontSize: 14)),
                  ),
                  ...rarities.map(
                    (rarity) => DropdownMenuItem(
                      value: rarity.id,
                      child: Text(
                        rarity.displayName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
                onChanged: (String? value) {
                  context.read<GiftCubit>().selectRarity(value);
                },
              ),
            );
          },
          orElse:
              () => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white12 : Colors.black12,
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Загрузка...',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(width: 4),
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
        );
      },
    );
  }
}
