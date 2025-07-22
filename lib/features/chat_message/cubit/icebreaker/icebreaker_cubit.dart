import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'icebreaker_state.dart';
part 'icebreaker_cubit.freezed.dart';

class IcebreakerCubit extends Cubit<IcebreakerState> {
  IcebreakerCubit() : super(IcebreakerState.initial());
}
