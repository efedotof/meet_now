import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';
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
    _loadInitialData();
  }

  final AdminInterface _adminInterface;

  Future<void> _loadInitialData() async {
    emit(state.copyWith(isLoading: true));

    try {
      await Future.wait([
        _loadReports(),
        _loadReportsStatistics(),
        _loadSupportStatistics(),
        _loadQuestions(),
        _loadSupportUsers(),
      ]);

      emit(state.copyWith(isLoading: false, error: null));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _loadReports() async {
    try {
      final reportsPage = await _adminInterface.getAllReports(
        page: 0,
        size: 50,
      );

      final reportedContent = reportsPage.content
          .map(_convertReportToReportedContent)
          .toList();

      emit(
        state.copyWith(
          reportedContent: reportedContent,
          totalReports: reportsPage.totalElements,
        ),
      );
    } catch (e) {
      throw Exception('Failed to load reports: $e');
    }
  }

  Future<void> _loadReportsByStatus(ReportStatus status) async {
    try {
      final reportsPage = await _adminInterface.getReportsByStatus(
        status: status,
        page: 0,
        size: 50,
      );

      final reportedContent = reportsPage.content
          .map(_convertReportToReportedContent)
          .toList();

      emit(
        state.copyWith(
          reportedContent: reportedContent,
          totalReports: reportsPage.totalElements,
        ),
      );
    } catch (e) {
      throw Exception('Failed to load reports: $e');
    }
  }

  Future<void> _loadReportsStatistics() async {
    try {
      final statistics = await _adminInterface.getReportsStatistics();
      emit(state.copyWith(reportsStatistics: statistics));
    } catch (e) {
      throw Exception('Failed to load statistics: $e');
    }
  }

  Future<void> _loadSupportStatistics() async {
    try {
      final statistics = await _adminInterface.getSupportStatistics();
      emit(state.copyWith(supportStatistics: statistics));
    } catch (e) {
      throw Exception('Failed to load support statistics: $e');
    }
  }

  Future<void> _loadQuestions() async {
    try {
      final questionsPage = await _adminInterface.getAllQuestionsPaginated(
        status: null,
        page: 0,
        size: 20,
      );

      emit(
        state.copyWith(
          questions: questionsPage.content,
          totalQuestions: questionsPage.totalElements,
        ),
      );
    } catch (e) {
      throw Exception('Failed to load questions: $e');
    }
  }

  Future<void> _loadSupportUsers() async {
    try {
      final activeUsers = await _adminInterface.getMostActiveSupportUsers(
        limit: 10,
      );

      emit(state.copyWith(activeSupportUsers: activeUsers));
    } catch (e) {
      throw Exception('Failed to load support users: $e');
    }
  }

  Future<void> loadUnansweredQuestions() async {
    try {
      final questions = await _adminInterface.getUnansweredQuestions();
      emit(
        state.copyWith(
          unansweredQuestions: questions,
          selectedCategory: ModerationCategory.UNANSWERED_QUESTIONS,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: 'Failed to load unanswered questions: $e'));
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

      await _loadReportsStatistics();
    } catch (e) {
      emit(state.copyWith(error: 'Failed to update report: $e'));
    }
  }

  Future<void> deleteReport(String reportId) async {
    try {
      await _adminInterface.deleteReportByAdmin(reportId: reportId);

      final updatedContent = state.reportedContent
          .where((content) => content.id != reportId)
          .toList();

      emit(state.copyWith(reportedContent: updatedContent));

      await _loadReportsStatistics();
    } catch (e) {
      emit(state.copyWith(error: 'Failed to delete report: $e'));
    }
  }

  Future<void> deleteQuestion(String questionId) async {
    try {
      await _adminInterface.deleteQuestion(questionId: questionId);

      final updatedQuestions = state.questions
          .where((question) => question.id != questionId)
          .toList();

      emit(state.copyWith(questions: updatedQuestions));

      await _loadSupportStatistics();
    } catch (e) {
      emit(state.copyWith(error: 'Failed to delete question: $e'));
    }
  }

  Future<void> closeQuestion(String questionId) async {
    try {
      await _adminInterface.forceCloseQuestion(questionId: questionId);

      final updatedQuestions = state.questions.map((question) {
        if (question.id == questionId) {
          return question.copyWith(status: 'closed');
        }
        return question;
      }).toList();

      emit(state.copyWith(questions: updatedQuestions));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to close question: $e'));
    }
  }

  Future<void> loadUserQuestions(String userId) async {
    try {
      final userQuestions = await _adminInterface.getUserQuestionsByAdmin(
        userId: userId,
      );

      emit(
        state.copyWith(
          userQuestions: userQuestions,
          selectedCategory: ModerationCategory.USER_QUESTIONS,
          selectedUserId: userId,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: 'Failed to load user questions: $e'));
    }
  }

  void changeCategory(ModerationCategory category) {
    emit(state.copyWith(selectedCategory: category, searchQuery: ''));
  }

  void filterReportsByStatus(ReportStatus? status) {
    if (status == null) {
      _loadReports();
      emit(state.copyWith(selectedReportStatus: null, searchQuery: ''));
    } else {
      _loadReportsByStatus(status);
      emit(state.copyWith(selectedReportStatus: status, searchQuery: ''));
    }
  }

  void searchReports(String query) {
    if (query.isEmpty) {
      _loadReports();
      return;
    }

    final filtered = state.reportedContent.where((content) {
      return content.title.toLowerCase().contains(query.toLowerCase()) ||
          content.content.toLowerCase().contains(query.toLowerCase()) ||
          content.reportedBy.toLowerCase().contains(query.toLowerCase());
    }).toList();

    emit(state.copyWith(reportedContent: filtered, searchQuery: query));
  }

  void searchQuestions(String query) {
    if (query.isEmpty) {
      _loadQuestions();
      return;
    }

    final filtered = state.questions.where((question) {
      return question.title.toLowerCase().contains(query.toLowerCase()) ||
          question.description.toLowerCase().contains(query.toLowerCase()) ||
          question.userId.toLowerCase().contains(query.toLowerCase());
    }).toList();

    emit(state.copyWith(questions: filtered, searchQuery: query));
  }

  Future<void> warnUser(String userId, String reason) async {
    try {
      final reportId = _findReportByUserId(userId);
      if (reportId != null) {
        await updateReportStatus(
          reportId: reportId,
          status: ReportStatus.IN_PROCESS,
        );
      }

      emit(state.copyWith(error: null));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to warn user: $e'));
    }
  }

  Future<void> banUser(String userId, String reason) async {
    try {
      await _adminInterface.blockUser(userId: userId, reason: reason);

      final reportId = _findReportByUserId(userId);
      if (reportId != null) {
        await updateReportStatus(
          reportId: reportId,
          status: ReportStatus.COMPLETED,
        );

        final updatedContent = state.reportedContent.map((content) {
          if (content.userId == userId) {
            return content.copyWith(status: ModerationStatus.banned);
          }
          return content;
        }).toList();

        emit(state.copyWith(reportedContent: updatedContent));
      }

      emit(state.copyWith(error: null));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to ban user: $e'));
    }
  }

  String? _findReportByUserId(String userId) {
    final report = state.reportedContent.firstWhere(
      (content) => content.userId == userId,
      orElse: () => throw Exception('Report not found for user $userId'),
    );
    return report.id;
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
      metadata: {
        'reporterId': report.reporterId,
        'reportedId': report.reportedId,
        'reportType': report.reason,
        'originalStatus': report.status.toString(),
      },

      username: report.reportedId,
      email: null,
      violationDetails: report.reason,
      userId: report.reportedId,
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

  void approveContent(String contentId) {
    updateReportStatus(reportId: contentId, status: ReportStatus.COMPLETED);
  }

  void rejectContent(String contentId) {
    updateReportStatus(reportId: contentId, status: ReportStatus.COMPLETED);
  }

  Future<void> refresh() async {
    emit(state.copyWith(isLoading: true));
    await _loadInitialData();
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }
}
