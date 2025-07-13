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
      super(SearchState.initial());

  final SearchInterface _searchInterface;

  Future<void> startRandomSearch({required BuildContext context}) async {
    try {
      final chat = await _searchInterface.randomSearch();
      if (chat.tempChatId.isNotEmpty) {
        if (context.mounted) {
          context.pushRoute(
            ChatMessageRoute(chatModel: null, temporaryChatModel: chat),
          );
        }
      }
    } catch (e) {
      debugPrint("search Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Произошла ошибка: $e")));
      }
    }
  }
}
