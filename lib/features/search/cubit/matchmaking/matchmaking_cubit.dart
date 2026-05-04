import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/model/chats/permanent_chat_response_dto/permanent_chat_response_dto.dart';
import 'package:meet_now_app_server/repository/matchmaking/matchmaking_interface.dart';

part 'matchmaking_state.dart';
part 'matchmaking_cubit.freezed.dart';

class MatchmakingCubit extends Cubit<MatchmakingState> {
  final MatchmakingInterface matchmakingInterface;

  MatchmakingCubit({required this.matchmakingInterface})
    : super(const MatchmakingState.initial());

  Future<void> quickSearch() async {
    emit(const MatchmakingState.loading());
    try {
      final result = await matchmakingInterface.quickSearch();
      if (result.success == true && result.permanentChat != null) {
        emit(MatchmakingState.found(permanentChat: result.permanentChat!));
      } else {
        emit(
          MatchmakingState.noResults(
            message: result.message ?? 'No results found',
          ),
        );
      }
    } on Exception catch (e) {
      emit(MatchmakingState.error(error: e.toString()));
    }
  }

  void reset() => emit(const MatchmakingState.initial());
}
