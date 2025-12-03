import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/model/gifts/gift/gift.dart';
import 'package:meet_now_app_server/model/gifts/gift_stats/gift_stats.dart';
import 'package:meet_now_app_server/model/gifts/send_gift_request/send_gift_request.dart';
import 'package:meet_now_app_server/model/social/user_inventory/user_inventory.dart';

import 'package:meet_now_app_server/repository/gift/gift_interface.dart';

part 'gift_state.dart';
part 'gift_cubit.freezed.dart';

class GiftCubit extends Cubit<GiftState> {
  GiftCubit({required GiftInterface giftInterface})
    : _giftInterface = giftInterface,
      super(GiftState.initial());

  final GiftInterface _giftInterface;

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
      ]);

      debugPrint("$futures");

      emit(
        GiftState.loaded(
          gifts: futures[0] as List<Gift>,
          inventory: futures[1] as List<UserInventory>,
          isDailyGiftAvailable: futures[2] as bool,
          currentStreak: futures[3] as int,
          giftStats: futures[4] as GiftStats,
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
}
