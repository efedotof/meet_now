part of 'search_cubit.dart';

@freezed
abstract class SearchState with _$SearchState {
  const factory SearchState({
    @Default('') String gender,
    int? ageFrom,
    @Default(false) bool isLoading,
    @Default(false) bool isSearching, 
    @Default([]) List<String> interests,
    @Default([]) List<String> purposes,
    @Default('') String city,
    @Default(false) bool verified,
  }) = _SearchState;
}
