import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/model/friends_request/friend_request.dart';
import 'package:meet_now_app_server/repository/friend/friend_interface.dart';

part 'friend_state.dart';
part 'friend_cubit.freezed.dart';

class FriendCubit extends Cubit<FriendState> {
  FriendCubit({required this.friendInterface}) : super(FriendState.initial());
  final FriendInterface friendInterface;

  Future<void> getIncomeFriend() async {
    try {
      final friendRequest = await friendInterface.getIncomingRequests();
      if (friendRequest.isEmpty) {
        emit(FriendState.emptyFriendRequest());
      } else {
        emit(FriendState.myFriendRequest(friendRequest: friendRequest));
      }
    } catch (e) {
      debugPrint("Произошла ошибка получения списка друзей: $e");
    }
  }

  Future<void> acceptRequest(String requesterId) async {
    try {
      await friendInterface.requestAccept(requesterId: requesterId);
      await getIncomeFriend();
    } catch (e) {
      debugPrint("Ошибка при принятии запроса: $e");
    }
  }

  Future<void> rejectRequest(String requesterId) async {
    try {
      await friendInterface.requestReject(requesterId: requesterId);
      await getIncomeFriend();
    } catch (e) {
      debugPrint("Ошибка при отклонении запроса: $e");
    }
  }
}
