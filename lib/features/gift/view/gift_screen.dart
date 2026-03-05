import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/features/game_chat/cubit/game_points_cubit.dart';
import 'package:meet_now_app/features/gift/cubit/gift_cubit.dart';
import 'package:meet_now_app/features/gift/widget/daily_gift_card.dart';
import 'package:meet_now_app/features/gift/widget/inventory_grid.dart';
import 'package:meet_now_app/features/gift/widget/rarity_filter_widget.dart';
import 'package:meet_now_app/features/gift/widget/widget.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/gifts/buy_gift_response/buy_gift_response.dart';
import 'package:meet_now_app_server/model/gifts/gift/gift.dart';
import 'package:meet_now_app_server/model/gifts/gift_rarity/gift_rarity.dart';
import 'package:meet_now_app_server/model/gifts/gift_stats/gift_stats.dart';
import 'package:meet_now_app_server/model/social/user_inventory/user_inventory.dart';

@RoutePage()
class GiftScreen extends StatefulWidget {
  const GiftScreen({super.key});

  @override
  State<GiftScreen> createState() => _GiftScreenState();
}

class _GiftScreenState extends State<GiftScreen> {
  void _showPurchaseSuccess(BuildContext context, BuyGiftResponse response) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            insetPadding:
                isMobile
                    ? const EdgeInsets.all(20)
                    : EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.1,
                      horizontal: MediaQuery.of(context).size.width * 0.2,
                    ),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: isMobile ? double.infinity : 400,
              ),
              child: AlertDialog(
                title: Text(S.of(context).the_purchase_was_successful),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${S.of(context).you_have_purchased_a_gift} ${response.inventoryItem.gift.name}',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${S.of(context).points_spent} ${response.spentPoints}',
                    ),
                    Text(
                      '${S.of(context).new_balance_sheet} ${response.newBalance}',
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(S.of(context).ok),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  bool _checkIfEnoughPoints(BuildContext context, int requiredPoints) {
    final gamePointsCubit = context.read<GamePointsCubit>();
    return gamePointsCubit.hasEnoughPoints(requiredPoints);
  }

  Future<void> _buyGiftWithCheck(BuildContext context, Gift gift) async {
    if (!_checkIfEnoughPoints(context, gift.costPoints)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${S.of(context).not_enough_points_to_purchase_you_need} ${gift.costPoints}',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final shouldBuy = await showDialog<bool>(
      context: context,
      builder:
          (context) => Dialog(
            insetPadding:
                isMobile
                    ? const EdgeInsets.all(20)
                    : EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.1,
                      horizontal: MediaQuery.of(context).size.width * 0.2,
                    ),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: isMobile ? double.infinity : 400,
              ),
              child: AlertDialog(
                title: Text(S.of(context).purchase_confirmation),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${S.of(context).do_you_want_to_buy}"${gift.name}"?'),
                    const SizedBox(height: 8),
                    Text(
                      '${S.of(context).cost} ${gift.costPoints} ${S.of(context).points}',
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(S.of(context).cancel),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(S.of(context).buy),
                  ),
                ],
              ),
            ),
          ),
    );

    if (shouldBuy == true) {
      try {
        if (context.mounted) {
          final response = await context.read<GiftCubit>().buyGift(
            giftId: gift.id,
          );

          if (response != null && mounted) {
            if (context.mounted) {
              _showPurchaseSuccess(context, response);
            }
          }

          if (context.mounted) {
            context.read<GamePointsCubit>().refreshPoints();
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${S.of(context).purchase_error} $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showGiftDetails(BuildContext context, Gift gift) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    showModalBottomSheet(
      context: context,
      builder: (context) => GiftDetailsSheet(gift: gift),
      isScrollControlled: true,
      backgroundColor: isMobile ? null : Colors.transparent,
    ).then((_) {
      if (isMobile) {
      } else {}
    });
  }

  void _showInventoryItemDetails(
    BuildContext context,
    UserInventory inventoryItem,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    showModalBottomSheet(
      context: context,
      builder:
          (context) => InventoryItemDetailsSheet(inventoryItem: inventoryItem),
      isScrollControlled: true,
      backgroundColor: isMobile ? null : Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<GamePointsCubit>().loadPoints();

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<GamePointsCubit>().refreshPoints();
        },
        child: BlocProvider(
          create:
              (context) =>
                  GiftCubit(giftInterface: context.read())..loadInitialData(),
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isMobile ? double.infinity : 800,
                ),
                child: Container(
                  margin: EdgeInsets.all(isMobile ? 0 : 16),
                  decoration:
                      isMobile
                          ? null
                          : BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                  child: Column(
                    children: [
                      const AppBarWidget(),
                      Expanded(
                        child: BlocConsumer<GiftCubit, GiftState>(
                          listener: (context, state) {
                            state.maybeWhen(
                              error: (message) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(message),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              },
                              orElse: () {},
                            );
                          },
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
                                if (currentView == GiftView.shop) {
                                  return Column(
                                    children: [
                                      RarityFilterWidget(isMobile: isMobile),
                                      const SizedBox(height: 10),
                                      Expanded(
                                        child: GiftShopGrid(
                                          gifts: gifts,
                                          onGiftTap: (gift) {
                                            _showGiftDetails(context, gift);
                                          },
                                          onBuyGift: (gift) {
                                            _buyGiftWithCheck(context, gift);
                                          },
                                          isMobile: isMobile,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      DailyGiftCard(
                                        isAvailable: isDailyGiftAvailable,
                                        streak: currentStreak,
                                        lastClaimedGift: lastClaimedGift,
                                        isMobile: isMobile,
                                      ),
                                      const SizedBox(height: 10),
                                      Expanded(
                                        child: InventoryGrid(
                                          inventory: inventory,
                                          onGiftTap: (inventoryItem) {
                                            _showInventoryItemDetails(
                                              context,
                                              inventoryItem,
                                            );
                                          },
                                          isMobile: isMobile,
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                              loading:
                                  () => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                              error:
                                  (message) => Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Text(
                                        '${S.of(context).error} $message',
                                      ),
                                    ),
                                  ),
                              orElse:
                                  () => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
