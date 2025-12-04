import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';

part 'game_points_state.dart';
part 'game_points_cubit.freezed.dart';

class GamePointsCubit extends Cubit<GamePointsState> {
  final UserModelAppInterface _userModelAppInterface;
  final UserInterface _userInterface;

  GamePointsCubit({
    required UserModelAppInterface userModelAppInterface,
    required UserInterface userInterface,
  }) : _userInterface = userInterface,
       _userModelAppInterface = userModelAppInterface,
       super(const GamePointsState.initial());

  Future<void> loadPoints() async {
    try {
      emit(const GamePointsState.loading());

      final user = await _userInterface.getUser();
      _userModelAppInterface.user = user;

      final points = user.gamePoints;

      emit(GamePointsState.loaded(points: points));
    } catch (e) {
      emit(GamePointsState.error(message: 'Не удалось загрузить очки: $e'));
    }
  }

  Future<void> refreshPoints() async {
    try {
      emit(const GamePointsState.refreshing());

      final user = await _userInterface.getUser();
      _userModelAppInterface.user = user;

      final points = user.gamePoints;

      emit(GamePointsState.loaded(points: points));
    } catch (e) {
      if (state is _Loaded) {
        final currentState = state as _Loaded;
        emit(currentState.copyWith(lastError: 'Не удалось обновить очки: $e'));
      } else {
        emit(GamePointsState.error(message: 'Не удалось обновить очки: $e'));
      }
    }
  }

  bool hasEnoughPoints(int requiredPoints) {
    return state.maybeWhen(
      loaded: (points, _) => points >= requiredPoints,
      orElse: () => false,
    );
  }

  int? get currentPoints {
    return state.when(
      initial: () => null,
      loading: () => null,
      loaded: (points, _) => points,
      refreshing: () => null,
      error: (_) => null,
    );
  }
}
