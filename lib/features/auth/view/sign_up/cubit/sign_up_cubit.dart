import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/sign_up_form_data.dart';
import 'package:meet_now_app/server/model/registration/registration.dart';
import 'package:meet_now_app/server/repository/auth/auth_interface.dart';
import 'package:meet_now_app/server/repository/upload_image/upload_image_interface.dart';

part 'sign_up_state.dart';
part 'sign_up_cubit.freezed.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({
    required AuthInterface authInterface,
    required UploadImageInterface uploadImageInterface,
  }) : _uploadImageInterface = uploadImageInterface,
       _authInterface = authInterface,
       super(const SignUpState.initial());

  final AuthInterface _authInterface;
  final UploadImageInterface _uploadImageInterface;

  Future<void> pickAndUploadAvatar(SignUpFormData formData) async {
    try {
      emit(const SignUpState.avatarLoading());

      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final url = await _uploadImageInterface.uploadAvatar(filePath);
        formData.avatar = url;
        debugPrint(url);
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
      final user = await _authInterface.registration(
        registration: registration,
      );

      if (user.id.isNotEmpty) {
        emit(const SignUpState.success());
      } else {
        emit(
          const SignUpState.error(
            error: 'Ошибка регистрации: пользователь пустой',
          ),
        );
      }
    } catch (e) {
      debugPrint("error: $e");
      emit(SignUpState.error(error: e.toString()));
    }
  }
}
