import 'package:freezed_annotation/freezed_annotation.dart';

part 'timer_update_dto.freezed.dart';
part 'timer_update_dto.g.dart';

@freezed
abstract class TimerUpdateDto with _$TimerUpdateDto {
  const factory TimerUpdateDto({
    required String tempChatId,
    required int remainingTime,
    required bool finished,
  }) = _TimerUpdateDto;

  factory TimerUpdateDto.fromJson(Map<String, dynamic> json) =>
      _$TimerUpdateDtoFromJson(json);
}

extension TimerUpdateDtoExt on TimerUpdateDto {
  int get remainingSeconds => (remainingTime / 1000).round();
  
  String get formattedTime {
    final minutes = (remainingSeconds / 60).floor();
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}