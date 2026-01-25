import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/model/social/sticker/sticker.dart';
import 'package:meet_now_app_server/model/social/sticker_pack/sticker_pack.dart';
import 'package:meet_now_app_server/repository/stikers_parks/stikers_parks_interface.dart';
import 'package:meet_now_app_server/model/social/user_inventory/user_inventory.dart';
import 'package:meet_now_app_server/repository/gift/gift_interface.dart';

part 'sticker_state.dart';
part 'sticker_cubit.freezed.dart';

class StickerCubit extends Cubit<StickerState> {
  StickerCubit({
    required StikersParksInterface stickerParksInterface,
    required GiftInterface giftInterface,
  }) : _stickerParksInterface = stickerParksInterface,
       _giftInterface = giftInterface,
       super(const StickerState.hidden());

  final StikersParksInterface _stickerParksInterface;
  final GiftInterface _giftInterface;

  void showStickers() {
    emit(const StickerState.visible());
  }

  void hideStickers() {
    emit(const StickerState.hidden());
  }

  void toggleStickers() {
    state.when(hidden: () => showStickers(), visible: () => hideStickers());
  }

  Future<List<Sticker>> getAllStickers() async {
    try {
      final packs = await _stickerParksInterface.getAllStickerPacks();
      final allStickers = <Sticker>[];

      for (final pack in packs) {
        final stickers = await _stickerParksInterface.getStickersByPack(
          pack.id,
        );
        allStickers.addAll(stickers);
      }

      return allStickers;
    } catch (e) {
      throw Exception('Failed to load stickers: $e');
    }
  }

  Future<List<StickerPack>> getAllStickerPacks() async {
    try {
      final packs = await _stickerParksInterface.getAllStickerPacks();
      return packs;
    } catch (e) {
      throw Exception('Failed to load sticker packs: $e');
    }
  }

  Future<List<Sticker>> getStickersByPack(String packId) async {
    try {
      final stickers = await _stickerParksInterface.getStickersByPack(packId);
      return stickers;
    } catch (e) {
      throw Exception('Failed to load stickers for pack $packId: $e');
    }
  }

  Future<List<UserInventory>> getUserGifts() async {
    try {
      return await _giftInterface.getInventory();
    } catch (e) {
      throw Exception('Failed to load user gifts: $e');
    }
  }

  Sticker _convertGiftToSticker(UserInventory inventory) {
    return Sticker(
      id: inventory.id,
      emoji: '🎁',
      imageUrl: inventory.gift.animationUrl ?? inventory.gift.imageUrl,
    );
  }

  Future<List<Sticker>> getAllGiftsAsStickers() async {
    try {
      final inventory = await getUserGifts();
      return inventory.map(_convertGiftToSticker).toList();
    } catch (e) {
      throw Exception('Failed to load gifts as stickers: $e');
    }
  }
}
