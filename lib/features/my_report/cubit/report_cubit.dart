import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/model/report/report.dart';
import 'package:meet_now_app_server/repository/report/report_interface.dart';

part 'report_state.dart';
part 'report_cubit.freezed.dart';

class ReportCubit extends Cubit<ReportState> {
  ReportCubit({required ReportInterface reportInterface})
    : _reportInterface = reportInterface,
      super(const ReportState.initial());

  final ReportInterface _reportInterface;

  Future<void> loadReports() async {
    emit(const ReportState.loading());
    try {
      final reports = await _reportInterface.getUserReports();
      emit(ReportState.loaded(reports));
    } catch (e) {
      emit(ReportState.error(e.toString()));
    }
  }


  Future<void> withdrawReport(String reportId) async {
    try {
      await _reportInterface.withdrawReport(reportId: reportId);
      await loadReports();
    } catch (e) {
      emit(ReportState.error(e.toString()));
    }
  }
}
