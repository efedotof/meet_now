import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app/server/model/search/search_random_model.dart';
import 'package:meet_now_app/server/repository/search/search_interface.dart';

part 'search_state.dart';
part 'search_cubit.freezed.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({required SearchInterface searchInterface})
    : _searchInterface = searchInterface,
      super(const SearchState());

  final SearchInterface _searchInterface;

  final List<String> genders = const ['М', 'Ж'];
  final List<int> ageFromList = [for (int i = 0; i < 15; i++) 18 + i * 3];

  final List<String> availableInterests = const [
    'Спорт',
    'Музыка',
    'Искусство',
    'Технологии',
    'Путешествия',
  ];

  final List<String> availablePurposes = const [
    'Дружба',
    'Общение',
    'Свидания',
    'Серьезные отношения',
  ];

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

  Future<void> startRandomSearch({required BuildContext context}) async {
    if (state.gender.isEmpty || state.ageFrom == null) return;

    emit(state.copyWith(isLoading: true));
    try {
      final request = SearchRandomModel(
        interests: state.interests,
        purposes: state.purposes,
        ageStart: state.ageFrom!,
        ageStop: state.ageFrom! + 3,
        floor: state.gender,
        city: state.city,
        verified: state.verified,
      );

      final chat = await _searchInterface.randomSearch(request: request);

      if (chat.tempChatId.isNotEmpty && context.mounted) {
        context.router.push(
          ChatMessageRoute(chatModel: null, temporaryChatModel: chat),
        );
      }
    } catch (e) {
      debugPrint("Search Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Произошла ошибка: ${e.toString()}")),
        );
      }
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
