part of 'search_mode_cubit.dart';

@freezed
class SearchModeState with _$SearchModeState {
  const factory SearchModeState.isSearch() = _IsSearch;
  const factory SearchModeState.isCardSwiper() = _IsCardSwiper;
}
