import 'package:freezed_annotation/freezed_annotation.dart';

part 'sticker.freezed.dart';
part 'sticker.g.dart';

@freezed
abstract class Sticker with _$Sticker {
  const factory Sticker({
    required String id,
    required String emoji,
    required String imageUrl,
    required String packId,
    required String packTitle,
  }) = _Sticker;

  factory Sticker.fromJson(Map<String, dynamic> json) =>
      _$StickerFromJson(json);
}