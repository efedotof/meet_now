// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

part 'report.freezed.dart';
part 'report.g.dart';

@freezed
abstract class Report with _$Report {
  const factory Report({
    required String id,
    required String reporterId,
    required String reportedId,
    required String reason,
    required ReportStatus status,
    required DateTime createdAt,
  }) = _User;

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
}

enum ReportStatus { SENT, IN_PROCESS, COMPLETED }
