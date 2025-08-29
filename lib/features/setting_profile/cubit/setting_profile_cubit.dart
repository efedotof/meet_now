import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/server/repository/user/user_interface.dart';

part 'setting_profile_state.dart';
part 'setting_profile_cubit.freezed.dart';

class SettingProfileCubit extends Cubit<SettingProfileState> {
  SettingProfileCubit({required this.userInterface}) : super(SettingProfileState.initial());

  final UserInterface userInterface;

}
