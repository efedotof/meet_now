import 'package:meet_now_app/server/model/report/report.dart';

abstract interface class ReportInterface {
  Future<List<Report>> getUserReports();
  Future<void> createReport({
    required String reportedId,
    required String reason,
  });
  Future<void> withdrawReport({required String reportId});
}
