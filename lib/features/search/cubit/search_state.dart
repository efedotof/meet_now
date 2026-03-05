part of 'search_cubit.dart';

@freezed
abstract class SearchState with _$SearchState {
  const factory SearchState({
    @Default('') String gender,
    int? ageFrom,
    @Default(false) bool isLoading,
    @Default(false) bool isSearching,
    @Default(0) int? queuePosition,
    @Default(0) int? totalInQueue,
    @Default([]) List<String> interests,
    @Default([]) List<String> purposes,
    @Default('') String city,
    @Default(false) bool verified,
    @Default([]) List<City> cities,
    TemporaryChat? matchedChat,
    @Default('') String searchStatus,
    @Default(false) bool isChatDeliveryConfirmed,
    @Default('') String chatDeliveryStatus,
  }) = _SearchState;
}
