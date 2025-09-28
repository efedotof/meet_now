import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_time_proposal_dto.freezed.dart';
part 'add_time_proposal_dto.g.dart';

@freezed
abstract class AddTimeProposalDto with _$AddTimeProposalDto {
  const factory AddTimeProposalDto({
    required String tempChatId,
    required String fromUserId,
    required int additionalMinutes,
  }) = _AddTimeProposalDto;

  factory AddTimeProposalDto.fromJson(Map<String, dynamic> json) =>
      _$AddTimeProposalDtoFromJson(json);
}