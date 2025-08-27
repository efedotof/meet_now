import 'package:meet_now_app/server/model/friends_request/friend_request.dart';
import 'package:meet_now_app/server/model/user/user.dart';

abstract interface class FriendInterface {
  Future<String> sendFriendRequest({required String toUserId});

  Future<String> requestAccept({required String requesterId});

  Future<String> requestReject({required String requesterId});

  Future<String> removeFriend({required String friendId});

  Future<List<User>> getFriends();

  Future<List<FriendRequest>> getIncomingRequests();
}
