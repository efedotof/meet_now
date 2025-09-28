import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_time_response_dto.freezed.dart';
part 'add_time_response_dto.g.dart';

@freezed
abstract class AddTimeResponseDto with _$AddTimeResponseDto {
  const factory AddTimeResponseDto({
    required String tempChatId,
    required String userId,
    required bool accepted,
    required int additionalMinutes,
  }) = _AddTimeResponseDto;

  factory AddTimeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AddTimeResponseDtoFromJson(json);
}