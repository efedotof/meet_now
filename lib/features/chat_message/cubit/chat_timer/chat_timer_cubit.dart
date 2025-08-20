import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_timer_state.dart';
part 'chat_timer_cubit.freezed.dart';

class ChatTimerCubit extends Cubit<ChatTimerState> {
  Timer? _countdownTimer;
  Timer? _modalTimer;
  int _totalSeconds = 0;
  int _remainingSeconds = 0;
  bool _isOneThirdModalShown = false;
  final VoidCallback? onTimerFinished; 

  ChatTimerCubit({
    required int durationMinutes,
    this.onTimerFinished,
  }) : super(ChatTimerState.initial()) {
    _totalSeconds = durationMinutes * 60;
    _remainingSeconds = _totalSeconds;
    _startCountdownTimer();
  }

  void _startCountdownTimer() {
    emit(ChatTimerState.running(
      totalSeconds: _totalSeconds,
      remainingSeconds: _remainingSeconds,
      isOneThirdModalShown: _isOneThirdModalShown,
    ));

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        emit(ChatTimerState.running(
          totalSeconds: _totalSeconds,
          remainingSeconds: _remainingSeconds,
          isOneThirdModalShown: _isOneThirdModalShown,
        ));

        if (!_isOneThirdModalShown && _remainingSeconds <= _totalSeconds ~/ 3) {
          _isOneThirdModalShown = true;
          emit(ChatTimerState.oneThirdReached());
        }
      } else {
        timer.cancel();
        emit(ChatTimerState.finished());
        onTimerFinished?.call(); 
      }
    });
  }

  void startModalTimer() {
    int secondsRemaining = 30;
    emit(ChatTimerState.modalRunning(secondsRemaining));

    _modalTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        secondsRemaining--;
        emit(ChatTimerState.modalRunning(secondsRemaining));
      } else {
        timer.cancel();
        emit(ChatTimerState.modalFinished());
      }
    });
  }

  void addTime(int seconds) {
    _totalSeconds += seconds;
    _remainingSeconds += seconds;
    emit(ChatTimerState.running(
      totalSeconds: _totalSeconds,
      remainingSeconds: _remainingSeconds,
      isOneThirdModalShown: _isOneThirdModalShown,
    ));
  }

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    _modalTimer?.cancel();
    return super.close();
  }
}