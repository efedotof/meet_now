import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app/server/model/registration/registration.dart';
import 'package:meet_now_app/server/repository/auth/auth_interface.dart';

part 'sign_up_state.dart';
part 'sign_up_cubit.freezed.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({required AuthInterface authInterface})
    : _authInterface = authInterface,
      super(const SignUpState.initial());

  final AuthInterface _authInterface;

  /// Пошаговая проверка данных на пустоту
  void check({
    required TextEditingController username,
    required TextEditingController email,
    required TextEditingController firstname,
    required TextEditingController subname,
    required TextEditingController descriptio,
    required String avatar,
    required TextEditingController city,
    required int age,
    required List<String> purposes,
    required List<String> interests,
    required bool isSearchable,
    required TextEditingController password,
  }) {
    if (firstname.text.trim().isEmpty ||
        subname.text.trim().isEmpty ||
        age <= 0 ||
        !isSearchable) {
      emit(const SignUpState.noData());
      return;
    }

    if (descriptio.text.trim().isEmpty) {
      emit(const SignUpState.noData());
      return;
    }

    if (avatar.trim().isEmpty) {
      emit(const SignUpState.noData());
      return;
    }

    if (city.text.trim().isEmpty) {
      emit(const SignUpState.noData());
      return;
    }

    if (purposes.isEmpty || interests.isEmpty) {
      emit(const SignUpState.noData());
      return;
    }

    if (username.text.trim().isEmpty ||
        password.text.trim().isEmpty ||
        email.text.trim().isEmpty) {
      emit(const SignUpState.noData());
      return;
    }

    emit(const SignUpState.nextPage()); // Все данные введены — можно переходить
  }

  /// Регистрация пользователя
  Future<void> registration({
    required BuildContext context,
    required TextEditingController username,
    required TextEditingController email,
    required TextEditingController firstname,
    required TextEditingController subname,
    required TextEditingController descriptio,
    required String avatar,
    required TextEditingController city,
    required int age,
    required List<String> purposes,
    required List<String> interests,
    required bool isSearchable,
    required TextEditingController password,
  }) async {
    // Ещё раз быстрая проверка

    debugPrint("проверяем");
    if (username.text.trim().isEmpty ||
        password.text.trim().isEmpty ||
        email.text.trim().isEmpty ||
        firstname.text.trim().isEmpty ||
        subname.text.trim().isEmpty ||
        descriptio.text.trim().isEmpty ||
        avatar.trim().isEmpty ||
        city.text.trim().isEmpty ||
        purposes.isEmpty ||
        interests.isEmpty ||
        age <= 0) {
      emit(const SignUpState.noData());
      debugPrint("не получилось!");
      return;
    }

    try {
      final registration = Registration(
        username: username.text.trim(),
        email: email.text.trim(),
        firstname: firstname.text.trim(),
        subname: subname.text.trim(),
        description: descriptio.text,
        avatar: avatar.trim(),
        city: city.text.trim(),
        age: age,
        purposes: purposes,
        interests: interests,
        isSearchable: isSearchable,
        password: password.text.trim(),
      );
      debugPrint("поиск");
      final user = await _authInterface.registration(
        registration: registration,
      );

      debugPrint("user: $user");

      if (user.id.isNotEmpty) {
        if (context.mounted) {
          context.replaceRoute(MainHomeRoute());
        }
        emit(const SignUpState.success());
      } else {
        emit(
          const SignUpState.error(
            error: 'Ошибка регистрации: пользователь пустой',
          ),
        );
      }
    } catch (e) {
      emit(SignUpState.error(error: e.toString()));
    }
  }
}
