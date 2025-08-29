import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/server/model/sticker/sticker.dart';

part 'sticker_pack.freezed.dart';
part 'sticker_pack.g.dart';

@freezed
abstract class StickerPack with _$StickerPack {
  const factory StickerPack({
    required String id,
    required String title,
    required List<Sticker> stickers
  }) = _StickerPack;

  factory StickerPack.fromJson(Map<String, dynamic> json) => _$StickerPackFromJson(json);
}
