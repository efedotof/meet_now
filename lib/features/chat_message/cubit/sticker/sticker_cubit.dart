import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/model/sticker/sticker.dart';
import 'package:meet_now_app_server/repository/stikers_parks/stikers_parks_interface.dart';

part 'sticker_state.dart';
part 'sticker_cubit.freezed.dart';

class StickerCubit extends Cubit<StickerState> {
  StickerCubit({required StikersParksInterface stickerParksInterface})
    : _stickerParksInterface = stickerParksInterface,
      super(const StickerState.hidden());

  final StikersParksInterface _stickerParksInterface;

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
}
