part of 'icebreaker_cubit.dart';

@freezed
class IcebreakerState with _$IcebreakerState {
  const factory IcebreakerState.initial() = _Initial;
  const factory IcebreakerState.loaded({required List<IcebreakerTopec> list}) =
      _Loaded;
  const factory IcebreakerState.error(String message) = _Error;
}
