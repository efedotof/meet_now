part of 'media_selection_cubit.dart';

@freezed
abstract class MediaSelectionState with _$MediaSelectionState {
  const factory MediaSelectionState({
    required List<MediaItem> selectedMedia,
    @Default(false) bool isPickerOpen,
  }) = _MediaSelectionState;

  factory MediaSelectionState.initial() => const MediaSelectionState(
        selectedMedia: [],
      );
}
