import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/model/chats/chat_finished/chat_finished.dart';
import 'package:meet_now_app_server/model/chats/timer/add_time_proposal_dto.dart';
import 'package:meet_now_app_server/model/chats/timer/add_time_response_dto.dart';
import 'package:meet_now_app_server/model/chats/timer/timer_update_dto.dart';

import 'package:meet_now_app_server/repository/timer/timer_repository_interface.dart';

part 'sync_timer_state.dart';
part 'sync_timer_cubit.freezed.dart';

class SyncTimerCubit extends Cubit<SyncTimerState> {
  final TimerRepositoryInterface _timerRepository;
  final String _tempChatId;
  final String _userId;
  final int _totalTime;

  StreamSubscription<TimerUpdateDto>? _timerSubscription;
  StreamSubscription<AddTimeProposalDto>? _proposalSubscription;
  StreamSubscription<AddTimeResponseDto>? _responseSubscription;
  StreamSubscription<ChatFinished>? _chatFinishedSubscription;

  bool _hasShownTimeOptions = false;

  SyncTimerCubit({
    required TimerRepositoryInterface timerRepository,
    required String tempChatId,
    required String userId,
    required int totalTime,
  }) : _timerRepository = timerRepository,
       _tempChatId = tempChatId,
       _userId = userId,
       _totalTime = totalTime,
       super(const SyncTimerState.initial()) {
    _initialize();
  }

  void _initialize() {
    _timerRepository.connect(_tempChatId, _userId);

    _timerSubscription = _timerRepository.timerUpdates.listen(_onTimerUpdate);
    _proposalSubscription = _timerRepository.addTimeProposals.listen(
      _onAddTimeProposal,
    );
    _responseSubscription = _timerRepository.addTimeResponses.listen(
      _onAddTimeResponse,
    );
    _chatFinishedSubscription = _timerRepository.chatFinishedStream.listen(
      _onChatFinished,
    );
  }

  void _onTimerUpdate(TimerUpdateDto update) {
    if (update.tempChatId != _tempChatId) return;

    if (update.finished) {
      emit(SyncTimerState.finished());
    } else {
      final shouldShowTimeOptions = _shouldShowTimeOptions(
        update.remainingTime,
      );

      if (shouldShowTimeOptions && !_hasShownTimeOptions) {
        emit(
          SyncTimerState.timeOptions(
            remainingTime: update.remainingTime,
            formattedTime: update.formattedTime,
          ),
        );
        _hasShownTimeOptions = true;
      } else {
        emit(
          SyncTimerState.running(
            remainingTime: update.remainingTime,
            formattedTime: update.formattedTime,
          ),
        );
      }
    }
  }

  bool _shouldShowTimeOptions(int remainingTime) {
    final percentage = (remainingTime / _totalTime) * 100;
    return percentage <= 15 && percentage >= 10;
  }

  void _onAddTimeProposal(AddTimeProposalDto proposal) {
    if (proposal.tempChatId != _tempChatId) return;

    if (proposal.fromUserId != _userId) {
      emit(
        SyncTimerState.addTimeProposed(
          remainingTime: state.remainingTime,
          formattedTime: state.formattedTime,
          additionalMinutes: proposal.additionalMinutes,
          fromUserId: proposal.fromUserId,
        ),
      );
    }
  }

  void _onAddTimeResponse(AddTimeResponseDto response) {
    if (response.tempChatId != _tempChatId) return;

    if (response.accepted) {
      emit(
        SyncTimerState.timeAdded(additionalMinutes: response.additionalMinutes),
      );
      _hasShownTimeOptions = false;
    } else {
      emit(SyncTimerState.timeRejected());
    }
  }

  void _onChatFinished(ChatFinished chatFinished) {
    if (chatFinished.tempChatId != _tempChatId) return;

    emit(SyncTimerState.finished());
  }

  void proposeAddTime(int additionalMinutes) {
    _timerRepository.proposeAddTime(_tempChatId, _userId, additionalMinutes);

    emit(
      SyncTimerState.waitingForResponse(
        remainingTime: state.remainingTime,
        formattedTime: state.formattedTime,
        additionalMinutes: additionalMinutes,
      ),
    );
  }

  void respondToProposal(bool accepted, int additionalMinutes) {
    _timerRepository.respondToAddTime(
      _tempChatId,
      _userId,
      accepted,
      additionalMinutes,
    );

    emit(
      SyncTimerState.running(
        remainingTime: state.remainingTime,
        formattedTime: state.formattedTime,
      ),
    );
  }

  void clearTimeOptions() {
    _hasShownTimeOptions = true;
    emit(
      SyncTimerState.running(
        remainingTime: state.remainingTime,
        formattedTime: state.formattedTime,
      ),
    );
  }

  @override
  Future<void> close() {
    _timerSubscription?.cancel();
    _proposalSubscription?.cancel();
    _responseSubscription?.cancel();
    _chatFinishedSubscription?.cancel();
    _timerRepository.disconnect();
    return super.close();
  }
}
