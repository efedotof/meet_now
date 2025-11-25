part of 'sync_timer_cubit.dart';

@freezed
class SyncTimerState with _$SyncTimerState {
  const factory SyncTimerState.initial() = _Initial;

  const factory SyncTimerState.running({
    required int remainingTime,
    required String formattedTime,
  }) = _Running;

  const factory SyncTimerState.finished() = _Finished;

  const factory SyncTimerState.addTimeProposed({
    required int remainingTime,
    required String formattedTime,
    required int additionalMinutes,
    required String fromUserId,
  }) = _AddTimeProposed;

  const factory SyncTimerState.waitingForResponse({
    required int remainingTime,
    required String formattedTime,
    required int additionalMinutes,
  }) = _WaitingForResponse;

  const factory SyncTimerState.timeAdded({required int additionalMinutes}) =
      _TimeAdded;

  const factory SyncTimerState.timeRejected() = _TimeRejected;

  const factory SyncTimerState.timeOptions({
    required int remainingTime,
    required String formattedTime,
  }) = _TimeOptions;

  const factory SyncTimerState.error(String message) = _Error;

  const SyncTimerState._();

  int get remainingTime => when(
    initial: () => 0,
    running: (remainingTime, formattedTime) => remainingTime,
    finished: () => 0,
    addTimeProposed:
        (remainingTime, formattedTime, additionalMinutes, fromUserId) =>
            remainingTime,
    waitingForResponse:
        (remainingTime, formattedTime, additionalMinutes) => remainingTime,
    timeAdded: (additionalMinutes) => 0,
    timeRejected: () => 0,
    timeOptions: (remainingTime, formattedTime) => remainingTime,
    error: (message) => 0,
  );

  String get formattedTime => when(
    initial: () => '00:00',
    running: (remainingTime, formattedTime) => formattedTime,
    finished: () => '00:00',
    addTimeProposed:
        (remainingTime, formattedTime, additionalMinutes, fromUserId) =>
            formattedTime,
    waitingForResponse:
        (remainingTime, formattedTime, additionalMinutes) => formattedTime,
    timeAdded: (additionalMinutes) => '00:00',
    timeRejected: () => '00:00',
    timeOptions: (remainingTime, formattedTime) => formattedTime,
    error: (message) => '00:00',
  );
}
