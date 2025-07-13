import 'package:meet_now_app/server/model/user/user.dart';
import 'user_model_app_interface.dart';

class UserModelAppRepository implements UserModelAppInterface {
  User? _user;

  @override
  User? get user => _user;

  @override
  set user(User? value) {
    _user = value;
  }
}
