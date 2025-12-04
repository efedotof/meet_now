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
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Покупка успешна!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Вы приобрели подарок: ${response.inventoryItem.gift.name}',
                ),
                const SizedBox(height: 8),
                Text('Потрачено поинтов: ${response.spentPoints}'),
                Text('Новый баланс: ${response.newBalance}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
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
            'Недостаточно очков для покупки. Нужно: ${gift.costPoints}',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final shouldBuy = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Подтверждение покупки'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Вы хотите купить "${gift.name}"?'),
                const SizedBox(height: 8),
                Text('Стоимость: ${gift.costPoints} поинтов'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Отмена'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Купить'),
              ),
            ],
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
              content: Text('Ошибка при покупке: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showGiftDetails(BuildContext context, Gift gift) {
    showModalBottomSheet(
      context: context,
      builder: (context) => GiftDetailsSheet(gift: gift),
      isScrollControlled: true,
    );
  }

  void _showInventoryItemDetails(
    BuildContext context,
    UserInventory inventoryItem,
  ) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => InventoryItemDetailsSheet(inventoryItem: inventoryItem),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<GamePointsCubit>().loadPoints();
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
                                const RarityFilterWidget(),
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
                            (message) =>
                                Center(child: Text('Ошибка: $message')),
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
    );
  }
}
