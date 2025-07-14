import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/route/app_route.dart';
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

  void selectGender(String gender) {
    emit(state.copyWith(gender: gender, ageFrom: null));
  }

  void selectAge(int ageFrom) {
    emit(state.copyWith(ageFrom: ageFrom));
  }

  Future<void> startRandomSearch({required BuildContext context}) async {
    emit(state.copyWith(isLoading: true));
    try {
      final chat = await _searchInterface.randomSearch(
        // gender: state.gender,
        // ageFrom: state.ageFrom!,
        // ageTo: state.ageFrom! + 3,
      );

      if (chat.tempChatId.isNotEmpty && context.mounted) {
        context.pushRoute(
          ChatMessageRoute(chatModel: null, temporaryChatModel: chat),
        );
      }
    } catch (e) {
      debugPrint("search Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Произошла ошибка: $e")));
      }
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
