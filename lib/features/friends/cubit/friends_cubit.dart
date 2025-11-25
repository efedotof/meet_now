import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/model/social/friend_dto/friend_dto.dart';

import 'package:meet_now_app_server/repository/friend/friend_interface.dart';

part 'friends_state.dart';
part 'friends_cubit.freezed.dart';

class FriendsCubit extends Cubit<FriendsState> {
  FriendsCubit({required FriendInterface friendInterface})
    : _friendInterface = friendInterface,
      super(FriendsState.initial()) {
    getFriendsList();
  }
  final FriendInterface _friendInterface;

  Future<void> getFriendsList() async {
    try {
      final friends = await _friendInterface.getFriends();
      if (friends.isNotEmpty) {
        emit(FriendsState.friendsList(friends: friends));
      } else {
        emit(FriendsState.friendsList(friends: []));
      }
    } catch (e) {
      debugPrint("getFriendsList error: $e");
    }
  }

  Future<void> refreshFriend() async {
    try {
      final friends = await _friendInterface.getFriends();
      if (friends.isNotEmpty) {
        emit(FriendsState.friendsList(friends: friends));
      } else {
        emit(FriendsState.friendsList(friends: []));
      }
    } catch (e) {
      debugPrint("getFriendsList error: $e");
    }
  }
}
