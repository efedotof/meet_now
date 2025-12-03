part of 'gift_cubit.dart';

@freezed
class GiftState with _$GiftState {
  const factory GiftState.initial() = _Initial;
  const factory GiftState.loading() = _Loading;
  const factory GiftState.loaded({
    required List<Gift> gifts,
    required List<UserInventory> inventory,
    required bool isDailyGiftAvailable,
    required int currentStreak,
    required GiftStats giftStats,
    Gift? lastClaimedGift,

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
