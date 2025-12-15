import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';
import 'package:meet_now_app_server/repository/admin/admin_interface.dart';

part 'login_state.dart';
part 'login_cubit.freezed.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required AdminInterface adminInterface})
    : _adminInterface = adminInterface,
      super(LoginState.initial());

  final AdminInterface _adminInterface;

  void updateUsername(String username) {
    emit(
      state.copyWith(
        username: username,
        usernameError: _validateUsername(username) ? null : "Username must be at least 3 characters",
      ),
    );
  }

  void updatePassword(String password) {
    emit(
      state.copyWith(
        password: password,
        passwordError: _validatePassword(password)
            ? null
            : "Password too short",
      ),
    );
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void toggleRememberMe() {
    emit(state.copyWith(rememberMe: !state.rememberMe));
  }

  bool _validateUsername(String username) {
    return username.length >= 3;
  }

  bool _validatePassword(String password) {
    return password.length >= 6;
  }

  bool _validateForm() {
    return _validateUsername(state.username) && _validatePassword(state.password);
  }

  Future<void> login() async {
    if (!_validateForm()) {
      emit(
        state.copyWith(
          usernameError: _validateUsername(state.username)
              ? null
              : "Username must be at least 3 characters",
          passwordError: _validatePassword(state.password)
              ? null
              : "Password must be at least 6 characters",
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, generalError: null));

    try {
      final loginRequest = Login(
        username: state.username,
        password: state.password,
      );
      final user = await _adminInterface.login(login: loginRequest);

      emit(state.copyWith(isLoading: false, user: user, loginSuccess: true));
    } catch (e) {
      if (state.username == "developer" && state.password == "dev123") {
        emit(
          state.copyWith(
            isLoading: false,
            user: User(
              id: "demo-user-id",
              username: "developer",
              email: "developer@meetnow.com",
              firstname: "Demo",
              subname: "Developer",
              description: "Demo admin user",
              avatar: null,
              friends: [],
              city: "Demo City",
              age: 30,
              purposes: ["networking", "friendship"],
              interests: ["technology", "development"],
              createdAt: DateTime.now(),
              verified: true,
              isSearchable: false,
              token: "demo-token-12345",
              roles: {"ROLE_ADMIN", "ROLE_DEVELOPER"},
              isOnline: true,
              floor: "admin",
              gamePoints: 1000,
              images: [],
            ),
            loginSuccess: true,
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            generalError:
                "Login failed. Use developer / dev123 for demo access",
          ),
        );
      }
    }
  }

  void resetLoginSuccess() {
    emit(state.copyWith(loginSuccess: false));
  }
}