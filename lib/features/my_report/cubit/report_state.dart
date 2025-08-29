part of 'report_cubit.dart';

@freezed
class ReportState with _$ReportState {
  const factory ReportState.initial() = _Initial;
  const factory ReportState.loading() = _Loading;
  const factory ReportState.error(String message) = _Error;
  const factory ReportState.loaded(List<Report> reports) = _Loaded;
}
