import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/model/gifts/gift/gift.dart';
import 'package:meet_now_app_server/model/gifts/gift_stats/gift_stats.dart';
import 'package:meet_now_app_server/model/gifts/send_gift_request/send_gift_request.dart';
import 'package:meet_now_app_server/model/social/user_inventory/user_inventory.dart';
import 'package:meet_now_app_server/model/gifts/buy_gift_for_self_request/buy_gift_for_self_request.dart';
import 'package:meet_now_app_server/model/gifts/buy_gift_response/buy_gift_response.dart';
import 'package:meet_now_app_server/model/gifts/gift_rarity/gift_rarity.dart';
import 'package:meet_now_app_server/model/gifts/gift_type/gift_type.dart';
import 'package:meet_now_app_server/repository/gift/gift_interface.dart';

part 'gift_state.dart';
part 'gift_cubit.freezed.dart';

class GiftCubit extends Cubit<GiftState> {
  GiftCubit({required GiftInterface giftInterface})
    : _giftInterface = giftInterface,
      super(GiftState.initial()) {
    loadInitialData();
  }

  final GiftInterface _giftInterface;

  void changeView(GiftView view) {
    final state = this.state;
    if (state is _Loaded) {
      emit(state.copyWith(currentView: view));
    }
  }

  Future<void> loadInitialData() async {
    emit(const GiftState.loading());
    await _giftInterface.getTypeGift();
    try {
      final futures = await Future.wait([
        _giftInterface.getAvailableGifts(),
        _giftInterface.getInventory(),
        _giftInterface.isDailyGiftAvailable(),
        _giftInterface.getCurrentStreak(),
        _giftInterface.getGiftStats(),
        _giftInterface.getAllRarities(),
        _giftInterface.getTypeGift(),
      ]);

      final allGifts = futures[0] as List<Gift>;

      emit(
        GiftState.loaded(
          gifts: allGifts,
          allGifts: allGifts,
          inventory: futures[1] as List<UserInventory>,
          isDailyGiftAvailable: futures[2] as bool,
          currentStreak: futures[3] as int,
          giftStats: futures[4] as GiftStats,
          rarities: futures[5] as List<GiftRarity>,
          allTypes: futures[6] as List<GiftType>,
          selectedTypeIds: {},
          searchQuery: '',
          selectedRarity: null,
          selectedPriceRange: null,
          currentView: GiftView.shop,
        ),
      );
    } catch (e) {
      emit(GiftState.error(e.toString()));
    }
  }

  List<Gift> _filterGifts({
    required List<Gift> allGifts,
    required String searchQuery,
    required Set<String> selectedTypeIds,
    required GiftRarity? selectedRarity,
    required PriceRange? selectedPriceRange,
  }) {
    var filtered = allGifts;

    if (searchQuery.isNotEmpty) {
      filtered =
          filtered.where((g) {
            return g.name.toLowerCase().contains(searchQuery.toLowerCase());
          }).toList();
    }

    if (selectedTypeIds.isNotEmpty) {
      filtered =
          filtered.where((g) => selectedTypeIds.contains(g.giftType)).toList();
    }

    if (selectedRarity != null) {
      filtered =
          filtered.where((g) => g.rarity.id == selectedRarity.id).toList();
    }

    if (selectedPriceRange != null && selectedPriceRange != PriceRange.all) {
      filtered =
          filtered
              .where((g) => PriceRange.matches(g, selectedPriceRange))
              .toList();
    }

    return filtered;
  }

  void _applyFilters() {
    final state = this.state;
    if (state is _Loaded) {
      final filtered = _filterGifts(
        allGifts: state.allGifts,
        searchQuery: state.searchQuery,
        selectedTypeIds: state.selectedTypeIds,
        selectedRarity: state.selectedRarity,
        selectedPriceRange: state.selectedPriceRange,
      );
      emit(state.copyWith(gifts: filtered));
    }
  }

  void setSearchQuery(String query) {
    final state = this.state;
    if (state is _Loaded) {
      emit(state.copyWith(searchQuery: query));
      _applyFilters();
    }
  }

  void toggleType(String typeId) {
    final state = this.state;
    if (state is _Loaded) {
      final newSet = Set<String>.from(state.selectedTypeIds);
      if (newSet.contains(typeId)) {
        newSet.remove(typeId);
      } else {
        newSet.add(typeId);
      }
      emit(state.copyWith(selectedTypeIds: newSet));
      _applyFilters();
    }
  }

  void clearTypeFilters() {
    final state = this.state;
    if (state is _Loaded) {
      emit(state.copyWith(selectedTypeIds: {}));
      _applyFilters();
    }
  }

  void clearAllFilters() {
    final state = this.state;
    if (state is _Loaded) {
      emit(
        state.copyWith(
          searchQuery: '',
          selectedTypeIds: {},
          selectedRarity: null,
          selectedPriceRange: null,
        ),
      );
      _applyFilters();
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

  Future<void> buyGift({required String giftId}) async {
    final state = this.state;
    if (state is _Loaded) {
      try {
        emit(state.copyWith(isBuyingGift: true));

        final request = BuyGiftForSelfRequest(giftId: giftId);
        final response = await _giftInterface.buyGiftForSelf(request: request);
        final updatedInventory = await _giftInterface.getInventory();
        final updatedGifts = await _giftInterface.getAvailableGifts();

        emit(
          state.copyWith(
            allGifts: updatedGifts,
            inventory: updatedInventory,
            isBuyingGift: false,
            lastPurchaseResponse: response,
          ),
        );
        _applyFilters();
      } catch (e) {
        emit(state.copyWith(isBuyingGift: false));
        emit(GiftState.error('Ошибка при покупке: $e'));
      }
    }
  }

  void clearLastPurchaseResponse() {
    final state = this.state;
    if (state is _Loaded) {
      emit(state.copyWith(lastPurchaseResponse: null));
    }
  }

  Future<void> selectRarity(String? rarityId) async {
    final state = this.state;
    if (state is _Loaded) {
      final newRarity =
          rarityId == null
              ? null
              : state.rarities.firstWhere((r) => r.id == rarityId);
      emit(state.copyWith(selectedRarity: newRarity));
      _applyFilters();
    }
  }

  Future<void> selectPriceRange(PriceRange? range) async {
    final state = this.state;
    if (state is _Loaded) {
      emit(state.copyWith(selectedPriceRange: range));
      _applyFilters();
    }
  }

  void clearRarityFilter() {
    final state = this.state;
    if (state is _Loaded) {
      emit(state.copyWith(selectedRarity: null));
      _applyFilters();
    }
  }
}
