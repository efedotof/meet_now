import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/server/repository/user/user_interface.dart';
import 'package:meet_now_app/server/model/user/user.dart';

part 'setting_profile_state.dart';
part 'setting_profile_cubit.freezed.dart';

class SettingProfileCubit extends Cubit<SettingProfileState> {
  SettingProfileCubit({required UserInterface userInterface})
    : _userInterface = userInterface,
      super(SettingProfileState.initial());

  final UserInterface _userInterface;

  void initialize(User user) {
    emit(
      state.copyWith(
        user: user,
        username: user.username,
        firstname: user.firstname ?? '',
        subname: user.subname ?? '',
        description: user.description ?? '',
        city: user.city ?? '',
        age: user.age?.toString() ?? '',
        interests: List.from(user.interests),
        purposes: List.from(user.purposes),
        isSearchable: user.isSearchable,
      ),
    );
  }

  void updateUsername(String username) {
    emit(state.copyWith(username: username));
  }

  void updateFirstname(String firstname) {
    emit(state.copyWith(firstname: firstname));
  }

  void updateSubname(String subname) {
    emit(state.copyWith(subname: subname));
  }

  void updateDescription(String description) {
    emit(state.copyWith(description: description));
  }

  void updateCity(String city) {
    emit(state.copyWith(city: city));
  }

  void updateAge(String age) {
    emit(state.copyWith(age: age));
  }

  void updateIsSearchable(bool isSearchable) {
    emit(state.copyWith(isSearchable: isSearchable));
  }

  void addInterest(String interest) {
    if (interest.isNotEmpty && !state.interests.contains(interest)) {
      final updatedInterests = List<String>.from(state.interests)
        ..add(interest);
      emit(state.copyWith(interests: updatedInterests));
    }
  }

  void removeInterest(String interest) {
    final updatedInterests = List<String>.from(state.interests)
      ..remove(interest);
    emit(state.copyWith(interests: updatedInterests));
  }

  void addPurpose(String purpose) {
    if (purpose.isNotEmpty && !state.purposes.contains(purpose)) {
      final updatedPurposes = List<String>.from(state.purposes)..add(purpose);
      emit(state.copyWith(purposes: updatedPurposes));
    }
  }

  void removePurpose(String purpose) {
    final updatedPurposes = List<String>.from(state.purposes)..remove(purpose);
    emit(state.copyWith(purposes: updatedPurposes));
  }

  void updateOldPassword(String password) {
    emit(state.copyWith(oldPassword: password));
  }

  void updateNewPassword(String password) {
    emit(state.copyWith(newPassword: password));
  }

  Future<void> updateProfile() async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));

      final user = state.user!;
      final updatedUser = user.copyWith(
        username: state.username,
        firstname: state.firstname,
        subname: state.subname,
        description: state.description,
        city: state.city,
        age: int.tryParse(state.age),
        interests: state.interests,
        purposes: state.purposes,
        isSearchable: state.isSearchable,
      );

      await _userInterface.putUserProfile(user: updatedUser);

      emit(
        state.copyWith(isLoading: false, user: updatedUser, isSuccess: true),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> changePassword() async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));

      await _userInterface.patchUserPassword(
        oldPassword: state.oldPassword!,
        newPassword: state.newPassword!,
      );

      emit(
        state.copyWith(
          isLoading: false,
          isPasswordChanged: true,
          oldPassword: '',
          newPassword: '',
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  void clearSuccess() {
    emit(state.copyWith(isSuccess: false, isPasswordChanged: false));
  }
}
