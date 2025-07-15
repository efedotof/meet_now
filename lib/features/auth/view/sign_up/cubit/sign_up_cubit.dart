import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/server/model/registration/registration.dart';
import 'package:meet_now_app/server/repository/auth/auth_interface.dart';

part 'sign_up_state.dart';
part 'sign_up_cubit.freezed.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({required AuthInterface authInterface})
    : _authInterface = authInterface,
      super(const SignUpState.initial());

  final AuthInterface _authInterface;

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
      emit(SignUpState.error(error: e.toString()));
    }
  }
}
