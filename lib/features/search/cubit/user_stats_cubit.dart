import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';

part 'user_stats_state.dart';
part 'user_stats_cubit.freezed.dart';

class UserStatsCubit extends Cubit<UserStatsState> {
  UserStatsCubit({
    required SocketServiceInterface socketServiceInterface,
    required UserStatsInterface userStatsInterface,
  }) : _userStatsInterface = userStatsInterface,
       _socketServiceInterface = socketServiceInterface,
       super(const UserStatsState.initial());

  final SocketServiceInterface _socketServiceInterface;
  final UserStatsInterface _userStatsInterface;
  late final StreamSubscription<UserStats> _userStatsSub;

  Future<void> initialize() async {
    try {
      _userStatsSub = _socketServiceInterface.userStatsStream.listen(
        (userStats) {
          emit(UserStatsState.loaded(userStats));
        },
        onError: (error) {
          emit(UserStatsState.error(error.toString()));
        },
      );
    } catch (e) {
      emit(UserStatsState.error(e.toString()));
    }

    final userStats = await _userStatsInterface.getUserStats();

    emit(UserStatsState.loaded(userStats));
  }

  @override
  Future<void> close() {
    _userStatsSub.cancel();
    return super.close();
  }
}
