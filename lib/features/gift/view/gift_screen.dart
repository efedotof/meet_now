import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/game_chat/cubit/game_points_cubit.dart';
import 'package:meet_now_app/features/gift/cubit/gift_cubit.dart';
import 'package:meet_now_app/features/gift/widget/widget.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/gifts/buy_gift_response/buy_gift_response.dart';
import 'package:meet_now_app_server/model/gifts/gift/gift.dart';
import 'package:meet_now_app_server/model/gifts/gift_rarity/gift_rarity.dart';
import 'package:meet_now_app_server/model/gifts/gift_stats/gift_stats.dart';
import 'package:meet_now_app_server/model/gifts/gift_type/gift_type.dart';
import 'package:meet_now_app_server/model/social/user_inventory/user_inventory.dart';

@RoutePage()
class GiftScreen extends StatefulWidget {
  const GiftScreen({super.key, this.isInventory});

  final bool? isInventory;

  @override
  State<GiftScreen> createState() => _GiftScreenState();
}

class _GiftScreenState extends State<GiftScreen> {
  bool _initialViewSet = false;
  ViewType _currentViewType = ViewType.grid;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openFilterDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void _showPurchaseSuccess(BuildContext context, BuyGiftResponse response) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 32,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            actionsPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            title: Text(S.of(context).the_purchase_was_successful),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${S.of(context).you_have_purchased_a_gift} ${response.inventoryItem.gift.name}',
                ),
                const SizedBox(height: 8),
                Text('${S.of(context).points_spent} ${response.spentPoints}'),
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

    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 32,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            actionsPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
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
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(S.of(context).cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text(S.of(context).buy),
              ),
            ],
          ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<GiftCubit>().buyGift(giftId: gift.id);
    }
  }

  void _showGiftDetails(BuildContext context, Gift gift) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final giftCubit = context.read<GiftCubit>();

    showModalBottomSheet(
      context: context,
      builder:
          (sheetContext) => GiftDetailsSheet(gift: gift, giftCubit: giftCubit),
      isScrollControlled: true,
      backgroundColor: isMobile ? null : Colors.transparent,
    );
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GamePointsCubit>().loadPoints();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const FilterDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<GamePointsCubit>().refreshPoints();
        },
        child: BlocProvider(
          create:
              (context) =>
                  GiftCubit(giftInterface: context.read())..loadInitialData(),
          child: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor,
                    Theme.of(context).colorScheme.surface,
                  ],
                ),
              ),
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
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 16,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                    child: Column(
                      children: [
                        // Восстановлен AppBarWidget
                        const AppBarWidget(),
                        // Основной контент занимает оставшееся место
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
                                  if (lastPurchaseResponse != null) {
                                    _showPurchaseSuccess(
                                      context,
                                      lastPurchaseResponse,
                                    );
                                    context
                                        .read<GiftCubit>()
                                        .clearLastPurchaseResponse();
                                    context
                                        .read<GamePointsCubit>()
                                        .refreshPoints();
                                  }
                                },
                                orElse: () {},
                              );

                              if (!_initialViewSet) {
                                state.maybeWhen(
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
                                    if (widget.isInventory == true &&
                                        currentView != GiftView.purchased) {
                                      context.read<GiftCubit>().changeView(
                                        GiftView.purchased,
                                      );
                                    }
                                    _initialViewSet = true;
                                  },
                                  orElse: () {},
                                );
                              }
                            },
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
                                  GiftView currentViewState,
                                  BuyGiftResponse? lastPurchaseResponse,
                                ) {
                                  final searchController =
                                      TextEditingController(text: searchQuery);

                                  if (currentViewState == GiftView.shop) {
                                    return Column(
                                      children: [
                                        SearchBarWidget(
                                          controller: searchController,
                                          onSearch: () {
                                            context
                                                .read<GiftCubit>()
                                                .setSearchQuery(
                                                  searchController.text,
                                                );
                                          },
                                          onFilter: _openFilterDrawer,
                                        ),
                                        const SizedBox(height: 8),
                                        ViewToggleWidget(
                                          currentView: _currentViewType,
                                          onViewChanged: (view) {
                                            setState(() {
                                              _currentViewType = view;
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        Expanded(
                                          child:
                                              _currentViewType == ViewType.grid
                                                  ? GiftShopGrid(
                                                    gifts: gifts,
                                                    onGiftTap:
                                                        (gift) =>
                                                            _showGiftDetails(
                                                              context,
                                                              gift,
                                                            ),
                                                    onBuyGift:
                                                        (gift) =>
                                                            _buyGiftWithCheck(
                                                              context,
                                                              gift,
                                                            ),
                                                    isMobile: isMobile,
                                                  )
                                                  : GiftShopList(
                                                    gifts: gifts,
                                                    onGiftTap:
                                                        (gift) =>
                                                            _showGiftDetails(
                                                              context,
                                                              gift,
                                                            ),
                                                    onBuyGift:
                                                        (gift) =>
                                                            _buyGiftWithCheck(
                                                              context,
                                                              gift,
                                                            ),
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
                                            onGiftTap:
                                                (inventoryItem) =>
                                                    _showInventoryItemDetails(
                                                      context,
                                                      inventoryItem,
                                                    ),
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
      ),
    );
  }
}
