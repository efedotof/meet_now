import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/server/model/sticker_pack/sticker_pack.dart';

part 'sticker.freezed.dart';
part 'sticker.g.dart';

@freezed
abstract class Sticker with _$Sticker {
  const factory Sticker({
    required String id,
    required StickerPack pack,

    required String emoji,
    required String imageUrl,
  }) = _Sticker;

  factory Sticker.fromJson(Map<String, dynamic> json) =>
      _$StickerFromJson(json);
}
