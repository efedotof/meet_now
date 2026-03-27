import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/repository/user/user_interface.dart';
import 'package:meet_now_app_server/storage/card_swiper/card_swiper_interface.dart';

part 'search_mode_state.dart';
part 'search_mode_cubit.freezed.dart';

class SearchModeCubit extends Cubit<SearchModeState> {
  SearchModeCubit({
    required CardSwiperInterface cardSwiperInterface,
    required UserInterface userInterface,
  }) : _userInterface = userInterface,
       _cardSwiperInterface = cardSwiperInterface,
       super(
         cardSwiperInterface.isCardSwiper()
             ? const SearchModeState.isCardSwiper()
             : const SearchModeState.isSearch(),
       );

  final CardSwiperInterface _cardSwiperInterface;
  final UserInterface _userInterface;

  Future<void> setMode(bool isCardSwiperMode) async {
    try {
      await _cardSwiperInterface.setValue(value: isCardSwiperMode);
      await _userInterface.updateCardMode(enabled: isCardSwiperMode);
      emit(
        isCardSwiperMode
            ? const SearchModeState.isCardSwiper()
            : const SearchModeState.isSearch(),
      );
    } catch (_) {}
  }

  Future<void> toggleMode() async {
    final newMode = state is! _IsCardSwiper;
    await setMode(newMode);
  }

  Future<void> refresh() async {
    try {
      final isCardSwiperMode = _cardSwiperInterface.isCardSwiper();
      emit(
        isCardSwiperMode
            ? const SearchModeState.isCardSwiper()
            : const SearchModeState.isSearch(),
      );
    } catch (_) {}
  }
}
