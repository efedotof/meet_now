import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sticker_state.dart';
part 'sticker_cubit.freezed.dart';

class StickerCubit extends Cubit<StickerState> {
  StickerCubit() : super(const StickerState.hidden());

  void showStickers() {
    emit(const StickerState.visible());
  }

  void hideStickers() {
    emit(const StickerState.hidden());
  }

  void toggleStickers() {
    state.when(
      hidden: () => showStickers(),
      visible: () => hideStickers(),
    );
  }
}