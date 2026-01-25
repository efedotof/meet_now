import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app_server/model/searchs/search/search_random_model.dart';
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
  bool _shouldStopSearch = false;

  final List<String> genders = const ['М', 'Ж'];
  final List<int> ageFromList = [for (int i = 0; i < 15; i++) 18 + i * 3];

  void selectGender(String gender) {
    emit(state.copyWith(gender: gender, ageFrom: null));
  }

  void selectAge(int ageFrom) {
    emit(state.copyWith(ageFrom: ageFrom));
  }

  void setInterests(List<String> interests) {
    emit(state.copyWith(interests: interests));
  }

  void setPurposes(List<String> purposes) {
    emit(state.copyWith(purposes: purposes));
  }

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

  void setCity(String city) {
    emit(state.copyWith(city: city));
  }

  void toggleVerified() {
    emit(state.copyWith(verified: !state.verified));
  }

  Future<void> toggleSearch({required BuildContext context}) async {
    if (state.isSearching) {
      _shouldStopSearch = true;
      emit(state.copyWith(isSearching: false));
      return;
    }

    if (state.gender.isEmpty || state.ageFrom == null) return;

    _shouldStopSearch = false;
    emit(state.copyWith(isSearching: true));
    await _userInterface.startSearch();

    final gender = _convertGender(state.gender);

    while (!_shouldStopSearch && !isClosed) {
      try {
        final request = SearchRandomModel(
          interests: state.interests,
          purposes: state.purposes,
          ageStart: state.ageFrom!,
          ageStop: state.ageFrom! + 3,
          floor: gender,
          city: state.city,
          verified: state.verified,
        );

        final chat = await _searchInterface.randomSearch(request: request);
        if (chat.tempChatId.isNotEmpty &&
            context.mounted &&
            !_shouldStopSearch) {
          await _userInterface.stopSearch();
          emit(state.copyWith(isSearching: false));
          if (context.mounted) {
            context.router.push(
              ChatMessageRoute(chatModel: null, temporaryChatModel: chat),
            );
          }
          break;
        }
      } catch (e) {
        if (context.mounted && !_shouldStopSearch) {
          await _userInterface.stopSearch();
        }
      }

      if (!_shouldStopSearch) {
        await Future.delayed(const Duration(seconds: 3));
      }
    }
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

  void clearCities() {
    emit(state.copyWith(cities: []));
  }

  String _convertGender(String gender) {
    switch (gender.toLowerCase()) {
      case 'м':
      case 'М':
      case 'муж':
      case 'male':
        return 'male';
      case 'ж':
      case "Ж":
      case 'жен':
      case 'female':
        return 'female';
      default:
        return gender;
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    _shouldStopSearch = true;
    return super.close();
  }
}
