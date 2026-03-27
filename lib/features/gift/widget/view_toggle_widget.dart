import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/gift/cubit/gift_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/features/gift/widget/price_filter_dropdown.dart';
import 'package:meet_now_app/features/gift/widget/rarity_dropdown.dart';
import 'package:meet_now_app_server/model/gifts/buy_gift_response/buy_gift_response.dart';
import 'package:meet_now_app_server/model/gifts/gift/gift.dart';
import 'package:meet_now_app_server/model/gifts/gift_rarity/gift_rarity.dart';
import 'package:meet_now_app_server/model/gifts/gift_stats/gift_stats.dart';
import 'package:meet_now_app_server/model/gifts/gift_type/gift_type.dart';
import 'package:meet_now_app_server/model/social/user_inventory/user_inventory.dart';

enum ViewType { grid, list }

class ViewToggleWidget extends StatelessWidget {
  final ViewType currentView;
  final ValueChanged<ViewType> onViewChanged;

  const ViewToggleWidget({
    super.key,
    required this.currentView,
    required this.onViewChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.brightnessOf(context) == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Text(
              S.of(context).gifts,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            const SizedBox(width: 10),
            const RarityDropdown(),
            const SizedBox(width: 8),
            BlocBuilder<GiftCubit, GiftState>(
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
                    return PriceFilterDropdown(
                      currentRange: selectedPriceRange,
                      onChanged: (range) {
                        context.read<GiftCubit>().selectPriceRange(range);
                      },
                    );
                  },
                  orElse:
                      () => const PriceFilterDropdown(
                        currentRange: null,
                        onChanged: null,
                      ),
                );
              },
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                currentView == ViewType.grid
                    ? Icons.view_list
                    : Icons.grid_view,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              onPressed: () {
                onViewChanged(
                  currentView == ViewType.grid ? ViewType.list : ViewType.grid,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
