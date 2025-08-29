import 'package:meet_now_app/server/model/sticker/sticker.dart';
import 'package:meet_now_app/server/model/sticker_pack/sticker_pack.dart';

abstract interface class StikersParksInterface {
  Future<List<StickerPack>> getAllStickerPacks();
  Future<StickerPack> getStickerPack(String packId);
  Future<List<Sticker>> getStickersByPack(String packId);
  Future<Sticker> getSticker(String stickerId);
}
