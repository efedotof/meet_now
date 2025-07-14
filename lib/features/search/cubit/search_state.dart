part of 'search_cubit.dart';

@freezed
abstract class SearchState with _$SearchState {
  const factory SearchState({
    @Default('') String gender,
    int? ageFrom,
    @Default(false) bool isLoading,
  }) = _SearchState;
}
