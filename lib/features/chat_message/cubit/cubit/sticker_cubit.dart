import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sticker_state.dart';
part 'sticker_cubit.freezed.dart';

class StickerCubit extends Cubit<StickerState> {
  StickerCubit() : super(StickerState.initial());
}
