import 'dart:async';
import 'package:meet_now_app/server/model/timer/add_time_proposal_dto.dart';
import 'package:meet_now_app/server/model/timer/add_time_response_dto.dart';
import 'package:meet_now_app/server/model/timer/timer_update_dto.dart';

abstract interface class TimerRepositoryInterface {
  Stream<TimerUpdateDto> get timerUpdates;
  Stream<AddTimeProposalDto> get addTimeProposals;
  Stream<AddTimeResponseDto> get addTimeResponses;
  
  void connect(String tempChatId, String userId);
  void disconnect();
  
  void proposeAddTime(String tempChatId, String fromUserId, int additionalMinutes);
  void respondToAddTime(String tempChatId, String userId, bool accepted, int additionalMinutes);
  
  bool get isConnected;
}