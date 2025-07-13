import 'package:meet_now_app/server/model/user/user.dart';

abstract interface class UserModelAppInterface {
  User? get user;
  set user(User? value);
}
