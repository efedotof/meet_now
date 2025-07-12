import 'package:meet_now_app/server/model/user/user.dart';

abstract interface class UserStorageInterface {
  Future<void> saveUser(User user);
  Future<User?> getUser();
  Future<void> clearUser();
}
