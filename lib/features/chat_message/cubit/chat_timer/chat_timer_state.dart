part of 'chat_timer_cubit.dart';

@freezed
class ChatTimerState with _$ChatTimerState {
  const factory ChatTimerState.initial() = _Initial;
  const factory ChatTimerState.running({
    required int totalSeconds,
    required int remainingSeconds,
    required bool isOneThirdModalShown,
  }) = _Running;
  const factory ChatTimerState.oneThirdReached() = _OneThirdReached;
  const factory ChatTimerState.finished() = _Finished;
  const factory ChatTimerState.modalRunning(int secondsRemaining) =
      _ModalRunning;
  const factory ChatTimerState.modalFinished() = _ModalFinished;
}
