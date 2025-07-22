import 'package:meet_now_app/server/model/login/login.dart';
import 'package:meet_now_app/server/model/registration/registration.dart';
import 'package:meet_now_app/server/model/user/user.dart';

abstract interface class AuthInterface {
  Future<User> registration({required Registration registration});

  Future<User> login({required Login login});

  Future<User?> autoLogin();
}
