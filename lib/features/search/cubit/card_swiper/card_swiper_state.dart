part of 'card_swiper_cubit.dart';

@freezed
abstract class CardSwiperState with _$CardSwiperState {
  const factory CardSwiperState({
    SwipeCandidateResponse? currentCandidate,
    @Default(false) bool isLoading,
    String? errorMessage,
    String? gender,
    int? minAge,
    int? maxAge,
    @Default(false) bool? verified,
    @Default([]) List<String> interests,
    @Default([]) List<String> purposes,
    @Default(false) bool isLoadingMatches,
    @Default([]) List<MatchResponse> matches,
    String? matchesErrorMessage,
    @Default(false) bool isLoadingLikes,
    @Default([]) List<UserLikeResponse> userLikes,
    String? likesErrorMessage,
  }) = _CardSwiperState;

  factory CardSwiperState.initial() => CardSwiperState(
    currentCandidate: null,
    isLoading: false,
    errorMessage: null,
    gender: null,
    minAge: null,
    maxAge: null,
    verified: null,
    interests: const [],
    purposes: const [],
    isLoadingMatches: false,
    matches: const [],
    matchesErrorMessage: null,
    isLoadingLikes: false,
    userLikes: const [],
    likesErrorMessage: null,
  );
}
