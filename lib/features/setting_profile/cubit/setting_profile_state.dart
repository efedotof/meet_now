part of 'setting_profile_cubit.dart';

@freezed
abstract class SettingProfileState with _$SettingProfileState {
  const factory SettingProfileState({
    User? user,
    required String username,
    required String firstname,
    required String subname,
    required String description,
    required String city,
    required String age,
    required List<String> interests,
    required List<String> purposes,
    required bool isSearchable,
    String? oldPassword,
    String? newPassword,
    required bool isLoading,
    String? errorMessage,
    required bool isSuccess,
    required bool isPasswordChanged,
  }) = _SettingProfileState;

  factory SettingProfileState.initial() => const SettingProfileState(
        username: '',
        firstname: '',
        subname: '',
        description: '',
        city: '',
        age: '',
        interests: [],
        purposes: [],
        isSearchable: true,
        oldPassword: '',
        newPassword: '',
        isLoading: false,
        errorMessage: null,
        isSuccess: false,
        isPasswordChanged: false,
      );
}