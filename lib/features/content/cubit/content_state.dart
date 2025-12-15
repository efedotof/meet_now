part of 'content_cubit.dart';

@freezed
abstract class ContentState with _$ContentState {
  const factory ContentState({
    required bool isLoading,
    required ContentType currentContentType,
    required String searchQuery,
    required int currentPage,
    required int totalPages,
    String? error,
    List<City>? cities,
    List<IcebreakerTopec>? icebreakers,
    List<Interest>? interests,
    List<Purpose>? purposes,
    List<StickerPack>? stickerPacks,
    List<Sticker>? stickers,
    List<ChatGame>? games,
    List<AdminGiftDto>? gifts,
    List<AdminGiftRarityDto>? giftRarities,
    String? selectedPackId,
    String? gameTypeFilter,
  }) = _ContentState;

  factory ContentState.initial() => ContentState(
    isLoading: true,
    currentContentType: ContentType.cities,
    searchQuery: '',
    currentPage: 1,
    totalPages: 1,
    cities: [],
    icebreakers: [],
    interests: [],
    purposes: [],
    stickerPacks: [],
    stickers: [],
    games: [],
    gifts: [],
    giftRarities: [],
  );
}

enum ContentType {
  cities,
  icebreakers,
  interests,
  purposes,
  stickerPacks,
  stickers,
  games,
  gifts,
}
