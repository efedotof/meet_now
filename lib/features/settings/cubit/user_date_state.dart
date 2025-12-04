part of 'user_date_cubit.dart';

@freezed
class UserDateState with _$UserDateState {
  const factory UserDateState.initial() = _Initial;
  const factory UserDateState.loading() = _Loading;
  const factory UserDateState.loaded({required User user}) = _Loaded;
  const factory UserDateState.refreshing({User? previousUser}) = _Refreshing;
  const factory UserDateState.error({required String message, User? user}) =
      _Error;
}
