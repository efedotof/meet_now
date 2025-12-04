import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/model/gifts/gift/gift.dart';
import 'package:meet_now_app_server/model/gifts/gift_stats/gift_stats.dart';
import 'package:meet_now_app_server/model/gifts/send_gift_request/send_gift_request.dart';
import 'package:meet_now_app_server/model/social/user_inventory/user_inventory.dart';
import 'package:meet_now_app_server/model/gifts/buy_gift_for_self_request/buy_gift_for_self_request.dart';
import 'package:meet_now_app_server/model/gifts/buy_gift_response/buy_gift_response.dart';
import 'package:meet_now_app_server/model/gifts/gift_rarity/gift_rarity.dart';

import 'package:meet_now_app_server/repository/gift/gift_interface.dart';

part 'gift_state.dart';
part 'gift_cubit.freezed.dart';

class GiftCubit extends Cubit<GiftState> {
  GiftCubit({required GiftInterface giftInterface})
    : _giftInterface = giftInterface,
      super(GiftState.initial());

  final GiftInterface _giftInterface;
  BuyGiftResponse? _lastPurchaseResponse;

  void changeView(GiftView view) {
    final state = this.state;
    if (state is _Loaded) {
      emit(state.copyWith(currentView: view));
    }
  }

  Future<void> loadInitialData() async {
    emit(const GiftState.loading());
    try {
      final futures = await Future.wait([
        _giftInterface.getAvailableGifts(),
        _giftInterface.getInventory(),
        _giftInterface.isDailyGiftAvailable(),
        _giftInterface.getCurrentStreak(),
        _giftInterface.getGiftStats(),
        _giftInterface.getAllRarities(),
      ]);

      emit(
        GiftState.loaded(
          gifts: futures[0] as List<Gift>,
          inventory: futures[1] as List<UserInventory>,
          isDailyGiftAvailable: futures[2] as bool,
          currentStreak: futures[3] as int,
          giftStats: futures[4] as GiftStats,
          rarities: futures[5] as List<GiftRarity>,
          selectedRarity: null,
          currentView: GiftView.shop,
        ),
      );
    } catch (e) {
      emit(GiftState.error(e.toString()));
    }
  }

  Future<void> claimDailyGift() async {
    final state = this.state;
    if (state is _Loaded) {
      try {
        final gift = await _giftInterface.claimDailyGift();
        final updatedInventory = await _giftInterface.getInventory();
        final isDailyAvailable = await _giftInterface.isDailyGiftAvailable();
        final streak = await _giftInterface.getCurrentStreak();
        final stats = await _giftInterface.getGiftStats();

        emit(
          state.copyWith(
            inventory: updatedInventory,
            isDailyGiftAvailable: isDailyAvailable,
            currentStreak: streak,
            giftStats: stats,
            lastClaimedGift: gift,
          ),
        );
      } catch (e) {
        emit(GiftState.error(e.toString()));
      }
    }
  }

  Future<void> sendGift(SendGiftRequest request) async {
    final state = this.state;
    if (state is _Loaded) {
      try {
        await _giftInterface.sendGift(sendGiftRequest: request);
        final updatedInventory = await _giftInterface.getInventory();
        emit(state.copyWith(inventory: updatedInventory));
      } catch (e) {
        emit(GiftState.error(e.toString()));
      }
    }
  }

  Future<BuyGiftResponse?> buyGift({required String giftId}) async {
    final state = this.state;
    if (state is _Loaded) {
      try {
        emit(state.copyWith(isBuyingGift: true));

        final request = BuyGiftForSelfRequest(giftId: giftId);
        final response = await _giftInterface.buyGiftForSelf(request: request);

        final updatedInventory = await _giftInterface.getInventory();
        final updatedGifts = await _giftInterface.getAvailableGifts();

        _lastPurchaseResponse = response;

        emit(
          state.copyWith(
            gifts: updatedGifts,
            inventory: updatedInventory,
            isBuyingGift: false,
          ),
        );

        return response;
      } catch (e) {
        emit(state.copyWith(isBuyingGift: false));
        emit(GiftState.error('Ошибка при покупке: $e'));
        return null;
      }
    }
    return null;
  }

  BuyGiftResponse? consumeLastPurchaseResponse() {
    final response = _lastPurchaseResponse;
    _lastPurchaseResponse = null;
    return response;
  }

  Future<void> selectRarity(String? rarityId) async {
    final state = this.state;
    if (state is _Loaded) {
      try {
        if (rarityId == null) {
          final allGifts = await _giftInterface.getAvailableGifts();
          emit(state.copyWith(gifts: allGifts, selectedRarity: null));
        } else {
          final rarity = state.rarities.firstWhere(
            (r) => r.id == rarityId,
            orElse: () => throw Exception('Раритет не найден'),
          );

          final filteredGifts = await _giftInterface.getGiftsByRarity(
            rarityName: rarity.name,
          );

          emit(state.copyWith(gifts: filteredGifts, selectedRarity: rarity));
        }
      } catch (e) {
        emit(GiftState.error('Ошибка при фильтрации: $e'));
      }
    }
  }

  void clearRarityFilter() {
    final state = this.state;
    if (state is _Loaded) {
      emit(state.copyWith(selectedRarity: null));
    }
  }
}
