import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';

part 'user_date_state.dart';
part 'user_date_cubit.freezed.dart';

class UserDateCubit extends Cubit<UserDateState> {
  UserDateCubit({
    required UserModelAppInterface userModelAppInterface,
    required UserInterface userInterface,
  }) : _userModelAppInterface = userModelAppInterface,
       _userInterface = userInterface,
       super(UserDateState.initial());

  final UserModelAppInterface _userModelAppInterface;
  final UserInterface _userInterface;

  Future<void> loadUser() async {
    try {
      emit(const UserDateState.loading());

      final user = await _userInterface.getUser();
      _userModelAppInterface.user = user;

      emit(UserDateState.loaded(user: user));
    } catch (e) {
      emit(
        UserDateState.error(message: 'Не удалось загрузить пользователя: $e'),
      );
      rethrow;
    }
  }

  Future<void> refreshUser() async {
    try {
      final previousUser = state.maybeWhen(
        loaded: (user) => user,
        error: (_, user) => user,
        orElse: () => null,
      );

      emit(UserDateState.refreshing(previousUser: previousUser));

      final user = await _userInterface.getUser();
      _userModelAppInterface.user = user;

      emit(UserDateState.loaded(user: user));
    } catch (e) {
      final previousUser = state.maybeWhen(
        refreshing: (previousUser) => previousUser,
        orElse: () => null,
      );

      emit(
        UserDateState.error(
          message: 'Не удалось обновить пользователя: $e',
          user: previousUser,
        ),
      );
    }
  }

  User? get currentUser {
    return state.maybeWhen(
      loaded: (user) => user,
      refreshing: (previousUser) => previousUser,
      error: (_, user) => user,
      orElse: () => null,
    );
  }

  int? get currentBalance {
    return currentUser?.gamePoints;
  }

  bool get isUserLoaded {
    return state is _Loaded;
  }

  bool get isRefreshing {
    return state is _Refreshing;
  }

  String? get errorMessage {
    return state.maybeWhen(error: (message, _) => message, orElse: () => null);
  }
}
