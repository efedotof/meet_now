import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/model/chats/chat_game/chat_game.dart';
import 'package:meet_now_app_server/model/gifts/admin_create_gift_rarity_request/admin_create_gift_rarity_request.dart';
import 'package:meet_now_app_server/model/gifts/admin_create_gift_request/admin_create_gift_request.dart';
import 'package:meet_now_app_server/model/gifts/admin_gift_dto/admin_gift_dto.dart';
import 'package:meet_now_app_server/model/gifts/admin_gift_rarity_dto/admin_gift_rarity_dto.dart';
import 'package:meet_now_app_server/model/gifts/admin_update_gift_rarity_request/admin_update_gift_rarity_request.dart';
import 'package:meet_now_app_server/model/gifts/admin_update_gift_request/admin_update_gift_request.dart';
import 'package:meet_now_app_server/model/social/city/city.dart';
import 'package:meet_now_app_server/model/social/city/city_create_request/city_create_request.dart';
import 'package:meet_now_app_server/model/social/city/city_update_request/city_update_request.dart';
import 'package:meet_now_app_server/model/social/icebreaker_topec/icebreaker_create_request/icebreaker_create_request.dart';
import 'package:meet_now_app_server/model/social/icebreaker_topec/icebreaker_topec.dart';
import 'package:meet_now_app_server/model/social/icebreaker_topec/icebreaker_update_request/icebreaker_update_request.dart';
import 'package:meet_now_app_server/model/social/interes/interest.dart';
import 'package:meet_now_app_server/model/social/interes/interest_create_request/interest_create_request.dart';
import 'package:meet_now_app_server/model/social/interes/interest_update_request/interest_update_request.dart';
import 'package:meet_now_app_server/model/social/purpose/purpose.dart';
import 'package:meet_now_app_server/model/social/purpose/purpose_create_request/purpose_create_request.dart';
import 'package:meet_now_app_server/model/social/purpose/purpose_update_request/purpose_update_request.dart';
import 'package:meet_now_app_server/model/social/sticker/sticker.dart';
import 'package:meet_now_app_server/model/social/sticker/sticker_create_request/sticker_create_request.dart';
import 'package:meet_now_app_server/model/social/sticker/sticker_update_request/sticker_update_request.dart';
import 'package:meet_now_app_server/model/social/sticker_pack/sticker_pack.dart';
import 'package:meet_now_app_server/model/social/sticker_pack/sticker_pack_create_request/sticker_pack_create_request.dart';
import 'package:meet_now_app_server/model/social/sticker_pack/sticker_pack_update_request/sticker_pack_update_request.dart';
import 'package:meet_now_app_server/repository/admin/admin_interface.dart';

part 'content_state.dart';
part 'content_cubit.freezed.dart';

class ContentCubit extends Cubit<ContentState> {
  ContentCubit({required AdminInterface adminInterface})
    : _adminInterface = adminInterface,
      super(ContentState.initial());

  final AdminInterface _adminInterface;

  // Общие методы
  void changeContentType(ContentType contentType) {
    emit(
      state.copyWith(
        currentContentType: contentType,
        isLoading: true,
        currentPage: 1,
      ),
    );
    _loadContent();
  }

  void changePage(int page) {
    emit(state.copyWith(currentPage: page, isLoading: true));
    _loadContent();
  }

  void search(String query) {
    emit(state.copyWith(searchQuery: query, isLoading: true, currentPage: 1));
    _loadContent();
  }

  Future<void> refresh() async {
    emit(state.copyWith(isLoading: true));
    await _loadContent();
  }

  Future<void> createCity(CityCreateRequest request) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _adminInterface.createCity(request: request);
      await _loadContent();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> updateCity(String cityId, CityUpdateRequest request) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _adminInterface.updateCity(cityId: cityId, request: request);
      await _loadContent();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> deleteCity(String cityId) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _adminInterface.deleteCity(cityId: cityId);
      await _loadContent();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> bulkDeleteCities(List<String> cityIds) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _adminInterface.bulkDeleteCities(cityIds: cityIds);
      await _loadContent();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> createTopic(IcebreakerCreateRequest request) async {
    try {
      emit(state.copyWith(isLoading: true));
      final topic = await _adminInterface.createTopic(request: request);
      debugPrint("Topic topic: $topic");
      await _loadContent();
    } catch (e) {
      debugPrint("Произошла ошибка $e");
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> updateTopic(int id, IcebreakerUpdateRequest request) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _adminInterface.updateTopic(id: id, request: request);
      await _loadContent();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> deleteTopic(int id) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _adminInterface.deleteTopic(id: id);
      await _loadContent();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> bulkDeleteTopics(List<int> topicIds) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _adminInterface.bulkDeleteTopics(topicIds: topicIds);
      await _loadContent();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  // Интересы
  Future<void> createInterest(InterestCreateRequest request) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _adminInterface.createInterest(request: request);
      await _loadContent();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> updateInterest(
    String interestId,
    InterestUpdateRequest request,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _adminInterface.updateInterest(
        interestId: interestId,
        request: request,
      );
      await _loadContent();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> deleteInterest(String interestId) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _adminInterface.deleteInterest(interestId: interestId);
      await _loadContent();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> bulkDeleteInterests(List<String> interestIds) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _adminInterface.bulkDeleteInterests(interestIds: interestIds);
      await _loadContent();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  // Цели
  Future<void> createPurpose(PurposeCreateRequest request) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _adminInterface.createPurpose(request: request);
      await _loadContent();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> updatePurpose(
    String purposeId,
    PurposeUpdateRequest request,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _adminInterface.updatePurpose(
        purposeId: purposeId,
        request: request,
      );
      await _loadContent();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> deletePurpose(String purposeId) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _adminInterface.deletePurpose(purposeId: purposeId);
      await _loadContent();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> bulkDeletePurposes(List<String> purposeIds) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _adminInterface.bulkDeletePurposes(purposeIds: purposeIds);
      await _loadContent();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  // Стикеры и наборы стикеров
  Future<void> createStickerPack(StickerPackCreateRequest request) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _adminInterface.createStickerPack(request: request);
      await _loadContent();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> updateStickerPack(
    String packId,
    StickerPackUpdateRequest request,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _adminInterface.updateStickerPack(packId: packId, request: request);
      await _loadContent();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> deleteStickerPack(String packId) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _adminInterface.deleteStickerPack(packId: packId);
      await _loadContent();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> createSticker(StickerCreateRequest request) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _adminInterface.createSticker(request: request);
      await _loadContent();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> updateSticker(
    String stickerId,
    StickerUpdateRequest request,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _adminInterface.updateSticker(
        stickerId: stickerId,
        request: request,
      );
      await _loadContent();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> deleteSticker(String stickerId) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _adminInterface.deleteSticker(stickerId: stickerId);
      await _loadContent();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  // Игры
  Future<void> bulkDeleteGames(List<String> gameIds) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _adminInterface.bulkDeleteGames(gameIds: gameIds);
      await _loadContent();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> cleanupOldGames(int daysOld) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _adminInterface.cleanupOldGames(daysOld: daysOld);
      await _loadContent();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  // Подарки
  Future<void> createGift(AdminCreateGiftRequest request) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _adminInterface.createGift(request: request);
      await _loadContent();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> updateGift(String giftId, AdminUpdateGiftRequest request) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _adminInterface.updateGift(giftId: giftId, request: request);
      await _loadContent();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> deleteGift(String giftId) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _adminInterface.deleteGift(giftId: giftId);
      await _loadContent();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> toggleGiftActive(String giftId) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _adminInterface.toggleGiftActive(giftId: giftId);
      await _loadContent();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  // Редкости подарков
  Future<void> createGiftRarity(AdminCreateGiftRarityRequest request) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _adminInterface.createGiftRarity(request: request);
      await _loadContent();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> updateGiftRarity(
    String rarityId,
    AdminUpdateGiftRarityRequest request,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _adminInterface.updateGiftRarity(
        rarityId: rarityId,
        request: request,
      );
      await _loadContent();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> deleteGiftRarity(String rarityId) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _adminInterface.deleteGiftRarity(rarityId: rarityId);
      await _loadContent();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  // Загрузка контента
  Future<void> _loadContent() async {
    try {
      switch (state.currentContentType) {
        case ContentType.cities:
          final result = await _adminInterface.getAllCities(
            page: state.currentPage,
            size: 20,
            search: state.searchQuery,
          );
          emit(
            state.copyWith(
              isLoading: false,
              cities: result.content,
              totalPages: result.totalPages,
              error: null,
            ),
          );
          break;

        case ContentType.icebreakers:
          final result = await _adminInterface.getAllTopicsWithPagination(
            page: state.currentPage,
            size: 20,
            search: state.searchQuery,
          );
          emit(
            state.copyWith(
              isLoading: false,
              icebreakers: result.content,
              totalPages: result.totalPages,
              error: null,
            ),
          );
          break;

        case ContentType.interests:
          final result = await _adminInterface.getAllInterestsAdmin(
            page: state.currentPage,
            size: 20,
            search: state.searchQuery,
          );
          emit(
            state.copyWith(
              isLoading: false,
              interests: result.content,
              totalPages: result.totalPages,
              error: null,
            ),
          );
          break;

        case ContentType.purposes:
          final result = await _adminInterface.getAllPurposesAdmin(
            page: state.currentPage,
            size: 20,
            search: state.searchQuery,
          );
          emit(
            state.copyWith(
              isLoading: false,
              purposes: result.content,
              totalPages: result.totalPages,
              error: null,
            ),
          );
          break;

        case ContentType.stickerPacks:
          final result = await _adminInterface.getAllStickerPacksAdmin(
            page: state.currentPage,
            size: 20,
            search: state.searchQuery,
          );
          emit(
            state.copyWith(
              isLoading: false,
              stickerPacks: result.content,
              totalPages: result.totalPages,
              error: null,
            ),
          );
          break;

        case ContentType.stickers:
          final result = await _adminInterface.getAllStickersAdmin(
            page: state.currentPage,
            size: 20,
            packId: state.selectedPackId ?? '',
          );
          emit(
            state.copyWith(
              isLoading: false,
              stickers: result.content,
              totalPages: result.totalPages,
              error: null,
            ),
          );
          break;

        case ContentType.games:
          final result = await _adminInterface.getAllGamesWithPagination(
            page: state.currentPage,
            size: 20,
            gameType: state.gameTypeFilter ?? '',
          );
          emit(
            state.copyWith(
              isLoading: false,
              games: result.content,
              totalPages: result.totalPages,
              error: null,
            ),
          );
          break;

        case ContentType.gifts:
          final gifts = await _adminInterface.getAllGiftsAdmin();
          final rarities = await _adminInterface.getAllRaritiesAdmin();
          emit(
            state.copyWith(
              isLoading: false,
              gifts: gifts,
              giftRarities: rarities,
              error: null,
            ),
          );
          break;
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void selectStickerPack(String packId) {
    emit(
      state.copyWith(selectedPackId: packId, isLoading: true, currentPage: 1),
    );
    _loadContent();
  }

  void changeGameTypeFilter(String gameType) {
    emit(
      state.copyWith(gameTypeFilter: gameType, isLoading: true, currentPage: 1),
    );
    _loadContent();
  }
}
