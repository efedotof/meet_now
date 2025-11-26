import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';

part 'media_selection_state.dart';
part 'media_selection_cubit.freezed.dart';

class MediaSelectionCubit extends Cubit<MediaSelectionState> {
  MediaSelectionCubit() : super(MediaSelectionState.initial());

  void addMedia(List<MediaItem> mediaItems) {
    final updatedMedia = [...state.selectedMedia, ...mediaItems];
    emit(state.copyWith(selectedMedia: updatedMedia));
  }

  void removeMedia(MediaItem mediaItem) {
    final updatedMedia = List<MediaItem>.from(state.selectedMedia)
      ..remove(mediaItem);
    emit(state.copyWith(selectedMedia: updatedMedia));
  }

  void clearMedia() {
    emit(state.copyWith(selectedMedia: []));
  }

  void setPickerOpen(bool isOpen) {
    emit(state.copyWith(isPickerOpen: isOpen));
  }

  bool get hasSelectedMedia => state.selectedMedia.isNotEmpty;
}
