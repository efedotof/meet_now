part of 'sticker_cubit.dart';

@freezed
class StickerState with _$StickerState {
  const factory StickerState.hidden() = _Hidden;
  const factory StickerState.visible() = _Visible;
}