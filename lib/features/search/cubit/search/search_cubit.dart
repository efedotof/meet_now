import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app_server/model/chats/temporary/temporary_chat.dart';
import 'package:meet_now_app_server/model/searchs/match_delivery_state/match_delivery_state.dart';
import 'package:meet_now_app_server/model/searchs/search_filters/search_filters.dart';
import 'package:meet_now_app_server/model/searchs/search_response_dto/search_response_dto.dart';
import 'package:meet_now_app_server/model/social/city/city.dart';
import 'package:meet_now_app_server/repository/city/city_interface.dart';
import 'package:meet_now_app_server/repository/search/search_interface.dart';
import 'package:meet_now_app_server/repository/user/user_interface.dart';

part 'search_state.dart';
part 'search_cubit.freezed.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({
    required CityInterface cityInterface,
    required UserInterface userInterface,
    required SearchInterface searchInterface,
  }) : _cityInterface = cityInterface,
       _userInterface = userInterface,
       _searchInterface = searchInterface,
       super(const SearchState());

  final SearchInterface _searchInterface;
  final UserInterface _userInterface;
  final CityInterface _cityInterface;
  Timer? _debounceTimer;
  Timer? _pollingTimer;
  Timer? _deliveryPollingTimer;
  Timer? _elapsedTimer;
  bool _shouldStopSearch = false;
  String? _currentUserId;
  final Set<String> _acknowledgedChats = {};
  final Set<String> _deliveryPollingChats = {};

  final List<String> genders = const ['М', 'Ж'];
  final List<int> ageFromList = [for (int i = 0; i < 15; i++) 18 + i * 3];

  int getAgeEnd(int ageStart) => ageStart + 2;
  String getAgeLabel(int ageStart) => "$ageStart–${getAgeEnd(ageStart)}";

  void selectGender(String gender) =>
      emit(state.copyWith(gender: gender, ageFrom: null));
  void selectAge(int ageFrom) => emit(state.copyWith(ageFrom: ageFrom));
  void setInterests(List<String> interests) =>
      emit(state.copyWith(interests: interests));
  void setPurposes(List<String> purposes) =>
      emit(state.copyWith(purposes: purposes));
  void toggleInterest(String interest) {
    final newInterests = List<String>.from(state.interests);
    if (newInterests.contains(interest)) {
      newInterests.remove(interest);
    } else {
      newInterests.add(interest);
    }
    emit(state.copyWith(interests: newInterests));
  }

  void togglePurpose(String purpose) {
    final newPurposes = List<String>.from(state.purposes);
    if (newPurposes.contains(purpose)) {
      newPurposes.remove(purpose);
    } else {
      newPurposes.add(purpose);
    }
    emit(state.copyWith(purposes: newPurposes));
  }

  void setCity(String city) => emit(state.copyWith(city: city));
  void toggleVerified() => emit(state.copyWith(verified: !state.verified));

  Future<void> _initializeUserId() async {
    if (_currentUserId == null) {
      try {
        final user = await _userInterface.getUser();
        _currentUserId = user.id;
      } catch (_) {}
    }
  }

  void _startElapsedTimer() {
    _stopElapsedTimer();
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isClosed) {
        emit(state.copyWith(elapsedSeconds: state.elapsedSeconds + 1));
      }
    });
  }

  void _stopElapsedTimer() {
    _elapsedTimer?.cancel();
    _elapsedTimer = null;
  }

  Future<void> toggleSearch({required BuildContext context}) async {
    if (state.isSearching) {
      _stopSearch();
      emit(
        state.copyWith(
          isSearching: false,
          elapsedSeconds: 0,
          queuePosition: 0,
          totalInQueue: 0,
          matchedChat: null,
          searchStatus: 'STOPPED',
        ),
      );
      return;
    }

    await _initializeUserId();
    final user = await _userInterface.getUser();

    if (user.isSearchable == false) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).noOneCanSeeYouTurnOnSearchVisibility),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
      return;
    }

    if (state.gender.isEmpty || state.ageFrom == null) return;

    _shouldStopSearch = false;

    emit(
      state.copyWith(
        isSearching: true,
        elapsedSeconds: 0,
        queuePosition: 0,
        totalInQueue: 0,
        matchedChat: null,
        searchStatus: 'SEARCHING',
      ),
    );
    _startElapsedTimer();

    try {
      final gender = _convertGender(state.gender);
      final filters = SearchFilters(
        interests: state.interests,
        purposes: state.purposes,
        verified: state.verified,
        ageStart: state.ageFrom!,
        ageStop: getAgeEnd(state.ageFrom!),
        city: state.city.isEmpty ? null : state.city,
        floor: gender,
      );
      final response = await _searchInterface.startSearch(filters: filters);
      if (context.mounted) {
        _handleSearchResponse(response, context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(S.of(context).unknownError)));
      }
      emit(
        state.copyWith(
          isSearching: false,
          elapsedSeconds: 0,
          queuePosition: 0,
          totalInQueue: 0,
          searchStatus: 'ERROR',
        ),
      );
      _stopElapsedTimer();
    }
  }

  void _handleSearchResponse(SearchResponseDto response, BuildContext context) {
    if ((response.status == 'MATCHED' || response.status == 'MATCH_FOUND') &&
        response.temporaryChat != null) {
      if (context.mounted) {
        _handleMatchedChat(response.temporaryChat!, context);
      }
    } else if (response.status == 'SEARCHING') {
      emit(
        state.copyWith(
          queuePosition: response.queuePosition,
          totalInQueue: response.totalInQueue,
          searchStatus: 'SEARCHING',
        ),
      );
      if (context.mounted) {
        _startPolling(context);
      }
    } else if (response.status == 'STOPPED') {
      emit(
        state.copyWith(
          isSearching: false,
          elapsedSeconds: 0,
          queuePosition: 0,
          totalInQueue: 0,
          searchStatus: 'STOPPED',
        ),
      );
      _stopElapsedTimer();
    } else {}
  }

  Future<void> _handleMatchedChat(
    TemporaryChat temporaryChat,
    BuildContext context,
  ) async {
    final chatId = temporaryChat.tempChatId;

    emit(
      state.copyWith(
        isSearching: false,
        elapsedSeconds: 0,
        matchedChat: temporaryChat,
        searchStatus: 'MATCHED',
      ),
    );
    _stopElapsedTimer();

    await _acknowledgeChatDelivery(chatId);
    _startDeliveryPolling(chatId);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (context.mounted) {
        context.pushRoute(
          ChatMessageRoute(
            temporaryChatModel: temporaryChat,
            chatKey: temporaryChat.tempChatId,
          ),
        );
      }
    });
  }

  Future<void> _acknowledgeChatDelivery(String chatId) async {
    try {
      if (_acknowledgedChats.contains(chatId)) return;
      await _initializeUserId();
      if (_currentUserId == null) return;
      await _searchInterface.acknowledgeTemporaryChat(chatId, _currentUserId!);
      _acknowledgedChats.add(chatId);
      _checkDeliveryStatus(chatId);
    } catch (_) {}
  }

  Future<void> _checkDeliveryStatus(String chatId) async {
    try {
      final status = await _searchInterface.getMatchDeliveryStatus(chatId);
      if (status.status == MatchDeliveryStatus.DELIVERED ||
          status.status == MatchDeliveryStatus.EXPIRED ||
          status.status == MatchDeliveryStatus.CANCELLED) {
        _stopDeliveryPolling(chatId);
      }
    } catch (_) {}
  }

  void _startDeliveryPolling(String chatId) {
    if (_deliveryPollingChats.contains(chatId)) return;
    _deliveryPollingChats.add(chatId);
    _deliveryPollingTimer = Timer.periodic(const Duration(seconds: 5), (
      timer,
    ) async {
      if (!_deliveryPollingChats.contains(chatId)) {
        timer.cancel();
        return;
      }
      try {
        final status = await _searchInterface.getMatchDeliveryStatus(chatId);
        if (status.status == MatchDeliveryStatus.DELIVERED ||
            status.status == MatchDeliveryStatus.EXPIRED ||
            status.status == MatchDeliveryStatus.CANCELLED) {
          _stopDeliveryPolling(chatId);
          timer.cancel();
        }
      } catch (_) {}
    });
  }

  void _stopDeliveryPolling(String chatId) {
    _deliveryPollingChats.remove(chatId);
  }

  void _startPolling(BuildContext context) {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (_shouldStopSearch || isClosed) {
        timer.cancel();
        return;
      }
      try {
        final response = await _searchInterface.getSearchStatus();
        if ((response.status == 'MATCHED' ||
                response.status == 'MATCH_FOUND') &&
            response.temporaryChat != null) {
          timer.cancel();
          final localContext = context;
          if (localContext.mounted) {
            await _handleMatchedChat(response.temporaryChat!, localContext);
          }
        } else if (response.status == 'SEARCHING') {
          emit(
            state.copyWith(
              queuePosition: response.queuePosition,
              totalInQueue: response.totalInQueue,
              searchStatus: 'SEARCHING',
            ),
          );
        } else if (response.status == 'STOPPED' ||
            response.status == 'NO_MATCH') {
          timer.cancel();
          emit(
            state.copyWith(
              isSearching: false,
              elapsedSeconds: 0,
              queuePosition: 0,
              totalInQueue: 0,
              searchStatus: response.status,
            ),
          );
          _stopElapsedTimer();
        } else {}
      } catch (_) {}
    });
  }

  void _stopSearch() {
    _shouldStopSearch = true;
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _deliveryPollingTimer?.cancel();
    _deliveryPollingTimer = null;
    _deliveryPollingChats.clear();
    _stopElapsedTimer();
    try {
      _userInterface.stopSearch();
      _searchInterface.stopSearch();
    } catch (_) {}
  }

  Future<void> checkStatus() async {
    try {
      final response = await _searchInterface.getSearchStatus();
      if ((response.status == 'MATCHED' || response.status == 'MATCH_FOUND') &&
          response.temporaryChat != null) {
        final chatId = response.temporaryChat!.tempChatId;
        await _acknowledgeChatDelivery(chatId);
        emit(
          state.copyWith(
            isSearching: false,
            elapsedSeconds: 0,
            matchedChat: response.temporaryChat,
            searchStatus: 'MATCHED',
          ),
        );
        _stopElapsedTimer();
      }
    } catch (_) {}
  }

  Future<void> searchCities(String query) async {
    _debounceTimer?.cancel();
    if (query.isEmpty) {
      emit(state.copyWith(cities: []));
      return;
    }
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        final cities = await _cityInterface.searchCities(query);
        emit(state.copyWith(cities: cities));
      } catch (e) {
        emit(state.copyWith(cities: []));
      }
    });
  }

  void clearCities() => emit(state.copyWith(cities: []));
  void clearMatchedChat() => emit(state.copyWith(matchedChat: null));

  String _convertGender(String gender) {
    final result = switch (gender.toLowerCase()) {
      'м' || 'М' || 'муж' || 'male' => 'male',
      'ж' || "Ж" || 'жен' || 'female' => 'female',
      _ => gender,
    };
    return result;
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    _pollingTimer?.cancel();
    _deliveryPollingTimer?.cancel();
    _stopElapsedTimer();
    _stopSearch();
    _acknowledgedChats.clear();
    _deliveryPollingChats.clear();
    return super.close();
  }
}
