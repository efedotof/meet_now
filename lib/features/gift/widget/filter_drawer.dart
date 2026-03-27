import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/gift/cubit/gift_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';

class FilterDrawer extends StatelessWidget {
  const FilterDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: BlocBuilder<GiftCubit, GiftState>(
          builder: (context, state) {
            return state.maybeWhen(
              loaded: (
                gifts,
                allGifts,
                inventory,
                isDailyGiftAvailable,
                currentStreak,
                giftStats,
                rarities,
                allTypes,
                selectedTypeIds,
                searchQuery,
                lastClaimedGift,
                selectedRarity,
                selectedPriceRange,
                isBuyingGift,
                currentView,
                lastPurchaseResponse,
              ) {
                return Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                        ),
                        splashRadius: 24,
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.category,
                                    size: 20,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    S.of(context).typeOfGift,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1, thickness: 1),
                            if (allTypes.isEmpty)
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text('Нет доступных типов'),
                              )
                            else
                              ...allTypes.map(
                                (type) => InkWell(
                                  onTap:
                                      () => context
                                          .read<GiftCubit>()
                                          .toggleType(type.id),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          selectedTypeIds.contains(type.id)
                                              ? Icons.check_box
                                              : Icons.check_box_outline_blank,
                                          color:
                                              selectedTypeIds.contains(type.id)
                                                  ? Theme.of(
                                                    context,
                                                  ).primaryColor
                                                  : null,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Text(
                                            type.typeName,
                                            style: TextStyle(
                                              fontWeight:
                                                  selectedTypeIds.contains(
                                                        type.id,
                                                      )
                                                      ? FontWeight.w600
                                                      : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            const SizedBox(height: 16),

                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.diamond,
                                    size: 20,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    S.of(context).rare,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1, thickness: 1),
                            ...rarities.map(
                              (rarity) => InkWell(
                                onTap: () {
                                  if (selectedRarity?.id == rarity.id) {
                                    context
                                        .read<GiftCubit>()
                                        .clearRarityFilter();
                                  } else {
                                    context.read<GiftCubit>().selectRarity(
                                      rarity.id,
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        selectedRarity?.id == rarity.id
                                            ? Icons.radio_button_checked
                                            : Icons.radio_button_off,
                                        color:
                                            selectedRarity?.id == rarity.id
                                                ? Theme.of(context).primaryColor
                                                : null,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          rarity.name,
                                          style: TextStyle(
                                            fontWeight:
                                                selectedRarity?.id == rarity.id
                                                    ? FontWeight.w600
                                                    : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            if (selectedRarity != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: TextButton.icon(
                                  onPressed: () {
                                    context
                                        .read<GiftCubit>()
                                        .clearRarityFilter();
                                  },
                                  icon: const Icon(Icons.clear, size: 18),
                                  label: const Text('Сбросить редкость'),
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ),

                            const SizedBox(height: 16),

                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.attach_money,
                                    size: 20,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    S.of(context).price,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1, thickness: 1),
                            ...PriceRange.values.map(
                              (range) => InkWell(
                                onTap: () {
                                  if (selectedPriceRange == range) {
                                    context.read<GiftCubit>().selectPriceRange(
                                      null,
                                    );
                                  } else {
                                    context.read<GiftCubit>().selectPriceRange(
                                      range,
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        selectedPriceRange == range
                                            ? Icons.radio_button_checked
                                            : Icons.radio_button_off,
                                        color:
                                            selectedPriceRange == range
                                                ? Theme.of(context).primaryColor
                                                : null,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          range.label,
                                          style: TextStyle(
                                            fontWeight:
                                                selectedPriceRange == range
                                                    ? FontWeight.w600
                                                    : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.read<GiftCubit>().clearAllFilters();
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.clear_all),
                        label: const Text('Сбросить все фильтры'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          backgroundColor: Theme.of(context).colorScheme.error,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              orElse: () => const Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }
}
