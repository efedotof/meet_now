import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/features/gift/cubit/gift_cubit.dart';
import 'package:meet_now_app_server/model/gifts/gift/gift.dart';
import 'package:meet_now_app_server/model/gifts/gift_rarity/gift_rarity.dart';
import 'package:meet_now_app_server/model/gifts/gift_stats/gift_stats.dart';
import 'package:meet_now_app_server/model/social/user_inventory/user_inventory.dart';

class RarityFilterWidget extends StatelessWidget {
  final bool isMobile;

  const RarityFilterWidget({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.brightnessOf(context) == Brightness.dark;
    return BlocBuilder<GiftCubit, GiftState>(
      builder: (context, state) {
        return state.maybeWhen(
          loaded: (
            List<Gift> gifts,
            List<UserInventory> inventory,
            bool isDailyGiftAvailable,
            int currentStreak,
            GiftStats giftStats,
            List<GiftRarity> rarities,
            Gift? lastClaimedGift,
            GiftRarity? selectedRarity,
            @Default(false) bool isBuyingGift,
            @Default(GiftView.shop) GiftView currentView,
          ) {
            if (rarities.isEmpty) return const SizedBox();

            return SizedBox(
              height: isMobile ? 50 : 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
                itemCount: rarities.length,
                itemBuilder: (context, index) {
                  final rarity = rarities[index];
                  final isSelected = selectedRarity?.id == rarity.id;

                  return Padding(
                    padding: EdgeInsets.only(
                      right:
                          index < rarities.length - 1 ? (isMobile ? 8 : 12) : 0,
                      left: index == 0 ? 0 : 0,
                    ),
                    child: ChoiceChip(
                      iconTheme: IconThemeData(
                        color: isDark ? Colors.black : Colors.white,
                      ),

                      disabledColor: isDark ? Colors.white : Colors.black,
                      label: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 12 : 16,
                          vertical: isMobile ? 4 : 6,
                        ),
                        child: Text(
                          rarity.displayName,
                          style: TextStyle(
                            fontSize: isMobile ? 14 : 16,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.white,
                          ),
                        ),
                      ),
                      backgroundColor: isDark ? Colors.white70 : Colors.black87,
                      selectedColor: _parseColor(rarity.color),
                      selected: isSelected,

                      onSelected: (selected) {
                        if (isSelected) {
                          context.read<GiftCubit>().selectRarity(null);
                        } else {
                          context.read<GiftCubit>().selectRarity(rarity.id);
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color:
                              isSelected
                                  ? _parseColor(rarity.color)
                                  : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      elevation: isSelected ? 2 : 0,
                      pressElevation: 0,
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      avatar:
                          isSelected
                              ? Icon(
                                Icons.check,
                                size: isMobile ? 16 : 18,
                                color: Colors.white,
                              )
                              : null,
                    ),
                  );
                },
              ),
            );
          },
          orElse: () => const SizedBox(),
        );
      },
    );
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceAll('#', '0xFF')));
    } catch (e) {
      return Colors.grey;
    }
  }
}
