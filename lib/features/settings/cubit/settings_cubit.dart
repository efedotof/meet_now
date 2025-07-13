import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';

part 'settings_state.dart';
part 'settings_cubit.freezed.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({required this.userModelAppInterface})
    : super(SettingsState.initial());
  final UserModelAppInterface userModelAppInterface;
}
