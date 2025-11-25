import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/sign_up_form_data.dart';
import 'package:meet_now_app_server/model/auth/registration/registration.dart';
import 'package:meet_now_app_server/model/social/city/city.dart';

import 'package:meet_now_app_server/repository/auth/auth_interface.dart';
import 'package:meet_now_app_server/repository/city/city_interface.dart';
import 'package:meet_now_app_server/repository/upload_image/upload_image_interface.dart';

part 'sign_up_state.dart';
part 'sign_up_cubit.freezed.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({
    required CityInterface cityInterface,
    required AuthInterface authInterface,
    required UploadImageInterface uploadImageInterface,
  }) : _cityInterface = cityInterface,
       _uploadImageInterface = uploadImageInterface,
       _authInterface = authInterface,
       super(const SignUpState.initial());

  final AuthInterface _authInterface;
  final UploadImageInterface _uploadImageInterface;
  final CityInterface _cityInterface;

  Future<void> pickAndUploadAvatar(SignUpFormData formData) async {
    try {
      emit(const SignUpState.avatarLoading());

      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final url = await _uploadImageInterface.uploadAvatar(filePath);
        formData.avatar = url;
        emit(const SignUpState.avatarLoaded());
      } else {
        emit(const SignUpState.initial());
      }
    } catch (e) {
      emit(SignUpState.error(error: 'Ошибка при загрузке: $e'));
    }
  }

  Future<void> registration(Registration registration) async {
    emit(const SignUpState.loading());
    try {
      final gender = _convertGender(registration.floor);

      final regData = Registration(
        username: registration.username,
        email: registration.email,
        firstname: registration.firstname,
        subname: registration.subname,
        description: registration.description,
        city: registration.city,
        age: registration.age,
        purposes: registration.purposes,
        interests: registration.interests,
        isSearchable: registration.isSearchable,
        password: registration.password,
        floor: gender,
      );

      final user = await _authInterface.registration(registration: regData);

      if (user.id.isNotEmpty) {
        emit(const SignUpState.success());
      } else {
        emit(
          const SignUpState.error(
            error: 'Ошибка регистрации: пользователь не создан',
          ),
        );
      }
    } catch (e) {
      debugPrint("Registration error: $e");
      emit(SignUpState.error(error: _getUserFriendlyError(e)));
    }
  }

  Future<List<City>> searchCities(String query) async {
    if (query.isEmpty) {
      return [];
    }

    try {
      return await _cityInterface.searchCities(query);
    } catch (e) {
      debugPrint("City search error: $e");
      return [];
    }
  }

  String _convertGender(String gender) {
    switch (gender.toLowerCase()) {
      case 'м':
      case 'male':
        return 'male';
      case 'ж':
      case 'female':
        return 'female';
      default:
        return gender;
    }
  }

  String _getUserFriendlyError(dynamic error) {
    final errorString = error.toString();

    if (errorString.contains('username') || errorString.contains('логин')) {
      return 'Этот логин уже занят';
    } else if (errorString.contains('email') || errorString.contains('почта')) {
      return 'Этот email уже используется';
    } else if (errorString.contains('password') ||
        errorString.contains('пароль')) {
      return 'Пароль слишком слабый';
    } else if (errorString.contains('network') ||
        errorString.contains('connection')) {
      return 'Проблемы с подключением к интернету';
    } else {
      return 'Произошла ошибка при регистрации. Попробуйте еще раз';
    }
  }

  void reset() {
    emit(const SignUpState.initial());
  }
}
