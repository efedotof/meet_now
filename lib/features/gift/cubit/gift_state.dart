part of 'gift_cubit.dart';

@freezed
abstract class GiftState with _$GiftState {
  const factory GiftState.initial() = _Initial;
  const factory GiftState.loading() = _Loading;
  const factory GiftState.loaded({
    required List<Gift> gifts,
    required List<UserInventory> inventory,
    required bool isDailyGiftAvailable,
    required int currentStreak,
    required GiftStats giftStats,
    required List<GiftRarity> rarities,
    Gift? lastClaimedGift,
    GiftRarity? selectedRarity,
    @Default(false) bool isBuyingGift,
    @Default(GiftView.shop) GiftView currentView,
  }) = _Loaded;
  const factory GiftState.error(String message) = _Error;
}

enum GiftView {
  shop('Магазин'),
  purchased('Купленное');

  final String name;
  const GiftView(this.name);
}
