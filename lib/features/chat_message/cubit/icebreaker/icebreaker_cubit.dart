import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/server/model/icebreaker_topec/icebreaker_topec.dart';
import 'package:meet_now_app/server/repository/icebreaker/icebreaker_interface.dart';

part 'icebreaker_state.dart';
part 'icebreaker_cubit.freezed.dart';

class IcebreakerCubit extends Cubit<IcebreakerState> {
  IcebreakerCubit({required this.icebreakerInterface})
    : super(IcebreakerState.initial());

  final IcebreakerInterface icebreakerInterface;

  Future<List<IcebreakerTopec>> getIcebreaker({
    required String text,
    required String commandText,
  }) async {
    try {
      return await icebreakerInterface.textSearch(text: text);
    } catch (e) {
      emit(IcebreakerState.error(e.toString()));
      return [];
    }
  }
}
