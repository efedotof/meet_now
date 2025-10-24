import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/model/user_activity/user_activity.dart';
import 'package:meet_now_app_server/repository/socket/socket_service_interface.dart';
import 'package:meet_now_app_server/repository/user_model_app/user_model_app_interface.dart';

part 'user_activity_state.dart';
part 'user_activity_cubit.freezed.dart';

class UserActivityCubit extends Cubit<UserActivityState> {
  final SocketServiceInterface _socketService;
  final UserModelAppInterface _userModelApp;
  StreamSubscription<UserActivity>? _activitySubscription;
  Timer? _activityTimer;

  UserActivityCubit({
    required SocketServiceInterface socketService,
    required UserModelAppInterface userModelApp,
  }) : _socketService = socketService,
       _userModelApp = userModelApp,
       super(const UserActivityState.initial()) {
    _activitySubscription = _socketService.userActivityStream.listen(
      _handleActivity,
    );
  }

  void subscribeAction({required String chatId}) {
    _socketService.actionSub(chatId: chatId);
  }

  void _handleActivity(UserActivity activity) {
    emit(UserActivityState.activity(activity: activity));

    _activityTimer?.cancel();
    _activityTimer = Timer(const Duration(seconds: 5), () {
      emit(const UserActivityState.initial());
    });
  }

  void sendActivity({required ActivityType type, required String chatId}) {
    final user = _userModelApp.user;
    if (user == null || user.id.isEmpty) return;

    final activity = UserActivity(
      chatId: chatId,
      userId: user.id,
      username: user.username,
      activityType: type,
      timestamp: DateTime.now(),
    );

    _socketService.sendActivity(activity);
  }

  void resetActivity() {
    _activityTimer?.cancel();
    emit(const UserActivityState.initial());
  }

  @override
  Future<void> close() {
    _activitySubscription?.cancel();
    _activityTimer?.cancel();
    return super.close();
  }
}
