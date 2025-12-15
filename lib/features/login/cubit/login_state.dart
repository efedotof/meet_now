part of 'login_cubit.dart';

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    required String username,
    required String password,
    required bool isLoading,
    required bool obscurePassword,
    required bool rememberMe,
    required bool loginSuccess,
    String? usernameError,
    String? passwordError,
    String? generalError,
    User? user,
  }) = _LoginState;

  factory LoginState.initial() => const LoginState(
    username: '',
    password: '',
    isLoading: false,
    obscurePassword: true,
    rememberMe: false,
    loginSuccess: false,
  );
}