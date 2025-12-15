import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/model/social/question/question.dart';
import 'package:meet_now_app_server/model/social/question/question_status.dart';
import 'package:meet_now_app_server/model/social/report/report.dart';
import 'package:meet_now_app_server/model/social/report/report_statistics_dto/report_statistics_dto.dart';
import 'package:meet_now_app_server/model/social/support_statistics_dto/support_statistics_dto.dart';
import 'package:meet_now_app_server/model/social/user_question_statistic_cto/user_question_statistic_dto.dart';
import 'package:meet_now_app_server/repository/admin/admin_interface.dart';

part 'moderation_state.dart';
part 'moderation_cubit.freezed.dart';

class ModerationCubit extends Cubit<ModerationState> {
  ModerationCubit({required AdminInterface adminInterface})
    : _adminInterface = adminInterface,
      super(ModerationState.initial()) {
    _loadModerationData();
  }

  final AdminInterface _adminInterface;

  Future<void> _loadModerationData() async {
    emit(state.copyWith(isLoading: true));

    try {
      final reports = await getAllReports();
      final statistics = await getReportsStatistics();
      final supportStatistics = await getSupportStatistics();

      emit(
        state.copyWith(
          isLoading: false,
          reportedContent: reports,
          reportsStatistics: statistics,
          supportStatistics: supportStatistics,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<List<ReportedContent>> getAllReports() async {
    try {
      final reportsPage = await _adminInterface.getAllReports(
        page: state.currentPage,
        size: 20,
      );

      return reportsPage.content
          .map((report) => _convertReportToReportedContent(report))
          .toList();
    } catch (e) {
      throw Exception('Failed to load reports: $e');
    }
  }

  Future<List<ReportedContent>> getReportsByStatus(ReportStatus status) async {
    try {
      final reportsPage = await _adminInterface.getReportsByStatus(
        status: status,
        page: state.currentPage,
        size: 20,
      );

      return reportsPage.content
          .map((report) => _convertReportToReportedContent(report))
          .toList();
    } catch (e) {
      throw Exception('Failed to load reports by status: $e');
    }
  }

  Future<void> updateReportStatus({
    required String reportId,
    required ReportStatus status,
  }) async {
    try {
      await _adminInterface.updateReportStatus(
        reportId: reportId,
        status: status,
      );

      final updatedContent = state.reportedContent.map((content) {
        if (content.id == reportId) {
          return content.copyWith(
            status: _convertReportStatusToModerationStatus(status),
          );
        }
        return content;
      }).toList();

      emit(state.copyWith(reportedContent: updatedContent));
    } catch (e) {
      throw Exception('Failed to update report status: $e');
    }
  }

  Future<void> deleteReportByAdmin(String reportId) async {
    try {
      await _adminInterface.deleteReportByAdmin(reportId: reportId);
      final updatedContent = state.reportedContent
          .where((content) => content.id != reportId)
          .toList();

      emit(state.copyWith(reportedContent: updatedContent));
    } catch (e) {
      throw Exception('Failed to delete report: $e');
    }
  }

  Future<ReportStatisticsDto> getReportsStatistics() async {
    try {
      return await _adminInterface.getReportsStatistics();
    } catch (e) {
      throw Exception('Failed to load reports statistics: $e');
    }
  }

  Future<SupportStatisticsDto> getSupportStatistics() async {
    try {
      return await _adminInterface.getSupportStatistics();
    } catch (e) {
      throw Exception('Failed to load support statistics: $e');
    }
  }

  Future<Page<Question>> getAllQuestionsPaginated({
    required QuestionStatus? status,
    required int page,
    required int size,
  }) async {
    try {
      return await _adminInterface.getAllQuestionsPaginated(
        status: status,
        page: page,
        size: size,
      );
    } catch (e) {
      throw Exception('Failed to load questions: $e');
    }
  }

  Future<void> deleteQuestion(String questionId) async {
    try {
      await _adminInterface.deleteQuestion(questionId: questionId);
    } catch (e) {
      throw Exception('Failed to delete question: $e');
    }
  }

  Future<void> deleteAnswer(String answerId) async {
    try {
      await _adminInterface.deleteAnswer(answerId: answerId);
    } catch (e) {
      throw Exception('Failed to delete answer: $e');
    }
  }

  Future<Question> forceCloseQuestion(String questionId) async {
    try {
      return await _adminInterface.forceCloseQuestion(questionId: questionId);
    } catch (e) {
      throw Exception('Failed to force close question: $e');
    }
  }

  Future<List<Question>> getUserQuestionsByAdmin(String userId) async {
    try {
      return await _adminInterface.getUserQuestionsByAdmin(userId: userId);
    } catch (e) {
      throw Exception('Failed to load user questions: $e');
    }
  }

  Future<List<UserQuestionStatisticDto>> getMostActiveSupportUsers({
    required int limit,
  }) async {
    try {
      return await _adminInterface.getMostActiveSupportUsers(limit: limit);
    } catch (e) {
      throw Exception('Failed to load active support users: $e');
    }
  }

  Future<List<Question>> getUnansweredQuestions() async {
    try {
      return await _adminInterface.getUnansweredQuestions();
    } catch (e) {
      throw Exception('Failed to load unanswered questions: $e');
    }
  }

  ReportedContent _convertReportToReportedContent(Report report) {
    return ReportedContent(
      id: report.id,
      title: _getReportTitle(report),
      content: report.reason,
      type: ContentType.other,
      reason: _convertStringToReportReason(report.reason),
      status: _convertReportStatusToModerationStatus(report.status),
      reportedAt: report.createdAt,
      reportedBy: report.reporterId,
      reportCount: 1,
      notes: 'Reported user: ${report.reportedId}',
    );
  }

  String _getReportTitle(Report report) {
    final reason = report.reason.toLowerCase();
    if (reason.contains('spam')) return 'Spam Report';
    if (reason.contains('harass') || reason.contains('abuse')) {
      return 'Harassment Report';
    }
    if (reason.contains('inappropriate')) return 'Inappropriate Content';
    if (reason.contains('misinformation')) return 'Misinformation Report';
    if (reason.contains('copyright')) return 'Copyright Violation';
    return 'User Report';
  }

  ReportReason _convertStringToReportReason(String reasonString) {
    final reason = reasonString.toLowerCase();
    if (reason.contains('spam')) return ReportReason.spam;
    if (reason.contains('harass') || reason.contains('abuse')) {
      return ReportReason.harassment;
    }
    if (reason.contains('inappropriate')) return ReportReason.inappropriate;
    if (reason.contains('misinformation')) return ReportReason.misinformation;
    if (reason.contains('copyright')) return ReportReason.copyright;
    return ReportReason.other;
  }

  ModerationStatus _convertReportStatusToModerationStatus(ReportStatus status) {
    switch (status) {
      case ReportStatus.SENT:
        return ModerationStatus.pending;
      case ReportStatus.IN_PROCESS:
        return ModerationStatus.warned;
      case ReportStatus.COMPLETED:
        return ModerationStatus.approved;
    }
  }

  void changeFilter(ModerationFilter filter) {
    emit(state.copyWith(filter: filter, isLoading: true));
    _loadModerationData();
  }

  void search(String query) {
    emit(state.copyWith(searchQuery: query, isLoading: true));
    _loadModerationData();
  }

  void approveContent(String contentId) {
    final updatedContent = state.reportedContent.map((content) {
      if (content.id == contentId) {
        return content.copyWith(status: ModerationStatus.approved);
      }
      return content;
    }).toList();

    emit(state.copyWith(reportedContent: updatedContent));

    updateReportStatus(reportId: contentId, status: ReportStatus.COMPLETED);
  }

  void rejectContent(String contentId) {
    final updatedContent = state.reportedContent.map((content) {
      if (content.id == contentId) {
        return content.copyWith(status: ModerationStatus.rejected);
      }
      return content;
    }).toList();

    emit(state.copyWith(reportedContent: updatedContent));

    // Также обновляем статус в API
    updateReportStatus(reportId: contentId, status: ReportStatus.COMPLETED);
  }

  void warnUser(String reportId) {
    final updatedReports = state.userReports.map((report) {
      if (report.id == reportId) {
        return report.copyWith(status: ModerationStatus.warned);
      }
      return report;
    }).toList();

    emit(state.copyWith(userReports: updatedReports));

    // Также обновляем статус в API
    updateReportStatus(reportId: reportId, status: ReportStatus.IN_PROCESS);
  }

  void banUser(String reportId) {
    final updatedReports = state.userReports.map((report) {
      if (report.id == reportId) {
        return report.copyWith(status: ModerationStatus.banned);
      }
      return report;
    }).toList();

    emit(state.copyWith(userReports: updatedReports));

    updateReportStatus(reportId: reportId, status: ReportStatus.COMPLETED);
  }

  Future<void> refresh() async {
    emit(state.copyWith(isLoading: true));
    await _loadModerationData();
  }
}
