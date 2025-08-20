import 'package:meet_now_app/server/model/user/user.dart';

abstract interface class UserInterface {
  Future<void> putUserProfile();
  Future<void> patchUserUsername({required String username});
  Future<void> patchUserSearchable({required bool isSearchable});
  Future<void> patchUserPurposes({required User dto});
  Future<void> patchUserPassword({
    required String oldPassword,
    required String newPassword,
  });
  Future<void> patchUserOnline({
    required bool isOnline,
    required String token,
    required String uuid,
  });
  Future<void> patchUserEmail({required String email});
  Future<void> patchUserDescripton({required String description});
  Future<void> patchUserCity({required String city});
  Future<void> patchUserAvatar({required String avatar});
  Future<void> patchUserAge({required int age});
  Future<User> getUser();

  Future<void> startSearch();
  Future<void> stopSearch();
}
