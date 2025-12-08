import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/model/social/sticker/sticker.dart';
import 'package:meet_now_app_server/model/social/sticker_pack/sticker_pack.dart';
import 'package:meet_now_app_server/repository/message/message_interface.dart';
import 'package:meet_now_app_server/repository/stikers_parks/stikers_parks_interface.dart';
// TODO: Временно отключен функционал подарков
// import 'package:meet_now_app_server/model/social/user_inventory/user_inventory.dart';
// import 'package:meet_now_app_server/repository/gift/gift_interface.dart';
// import 'package:meet_now_app_server/model/chats/send_gift_in_chat_request/send_gift_in_chat_request.dart';

part 'sticker_state.dart';
part 'sticker_cubit.freezed.dart';

class StickerCubit extends Cubit<StickerState> {
  StickerCubit({
    required MessageInterface messageInterface,
    required StikersParksInterface stickerParksInterface,
    // TODO: Временно отключен функционал подарков
    // required GiftInterface giftInterface,
  }) : _messageInterface = messageInterface,
       _stickerParksInterface = stickerParksInterface,
       // TODO: Временно отключен функционал подарков
       // _giftInterface = giftInterface,
       super(const StickerState.hidden());

  final StikersParksInterface _stickerParksInterface;
  // TODO: Временно отключен функционал подарков
  // final GiftInterface _giftInterface;
  final MessageInterface _messageInterface;

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

  // TODO: Временно отключен функционал подарков
  /*
  // Получение подарков пользователя из инвентаря
  Future<List<UserInventory>> getUserGifts() async {
    try {
      final inventory = await _giftInterface.getInventory();
      return inventory;
    } catch (e) {
      throw Exception('Failed to load user gifts: $e');
    }
  }

  // Отправка подарка в чат
  Future<void> sendGiftToChat({
    required UserInventory inventory,
    required String recipientId,
    required String chatId,
    required String tempChatId,
    String message = '',
    bool isAnonymous = false,
  }) async {
    try {
      final request = SendGiftInChatRequest(
        recipientId: recipientId,
        giftId: inventory.gift.id,
        chatId: chatId,
        tempChatId: tempChatId,
        message: message,
        isAnonymous: isAnonymous,
      );

      _giftInterface.sendGiftInChat(request: request);

      _updateLocalInventoryAfterSending(inventory);
    } catch (e) {
      throw Exception('Failed to send gift: $e');
    }
  }

  void _updateLocalInventoryAfterSending(UserInventory sentInventory) {
    // Этот метод может быть использован для обновления UI без перезагрузки данных
    // Например, можно создать событие или обновить состояние
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
  */
}
