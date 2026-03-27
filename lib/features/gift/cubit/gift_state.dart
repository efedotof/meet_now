part of 'gift_cubit.dart';

@freezed
abstract class GiftState with _$GiftState {
  const factory GiftState.initial() = _Initial;
  const factory GiftState.loading() = _Loading;
  const factory GiftState.loaded({
    required List<Gift> gifts,
    required List<Gift> allGifts,
    required List<UserInventory> inventory,
    required bool isDailyGiftAvailable,
    required int currentStreak,
    required GiftStats giftStats,
    required List<GiftRarity> rarities,
    required List<GiftType> allTypes,
    required Set<String> selectedTypeIds,
    required String searchQuery,
    Gift? lastClaimedGift,
    GiftRarity? selectedRarity,
    PriceRange? selectedPriceRange,
    @Default(false) bool isBuyingGift,
    @Default(GiftView.shop) GiftView currentView,
    BuyGiftResponse? lastPurchaseResponse,
  }) = _Loaded;
  const factory GiftState.error(String message) = _Error;
}

enum GiftView {
  shop('Магазин'),
  purchased('Купленное');

  final String name;
  const GiftView(this.name);
}

enum PriceRange {
  all('Все'),
  cheap('Дешевые'),
  medium('Средние'),
  expensive('Дорогие');

  final String label;
  const PriceRange(this.label);

  static bool matches(Gift gift, PriceRange range) {
    switch (range) {
      case PriceRange.all:
        return true;
      case PriceRange.cheap:
        return gift.costPoints <= 100;
      case PriceRange.medium:
        return gift.costPoints > 100 && gift.costPoints <= 500;
      case PriceRange.expensive:
        return gift.costPoints > 500;
    }
  }
}
