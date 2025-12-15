part of 'moderation_cubit.dart';

@freezed
abstract class ModerationState with _$ModerationState {
  const factory ModerationState({
    required bool isLoading,
    required List<ReportedContent> reportedContent,
    required List<Question> questions,
    required List<UserQuestionStatisticDto> activeSupportUsers,
    required ModerationCategory selectedCategory,
    required ReportStatus? selectedReportStatus,
    required String searchQuery,
    required int totalReports,
    required int totalQuestions,
    ReportStatisticsDto? reportsStatistics,
    SupportStatisticsDto? supportStatistics,
    List<Question>? unansweredQuestions,
    List<Question>? userQuestions,
    String? selectedUserId,
    String? error,
  }) = _ModerationState;

  factory ModerationState.initial() => ModerationState(
    isLoading: true,
    reportedContent: [],
    questions: [],
    activeSupportUsers: [],
    selectedCategory: ModerationCategory.REPORTS,
    selectedReportStatus: null,
    searchQuery: '',
    totalReports: 0,
    totalQuestions: 0,
    reportsStatistics: null,
    supportStatistics: null,
    unansweredQuestions: null,
    userQuestions: null,
    selectedUserId: null,
    error: null,
  );
}

enum ModerationCategory {
  REPORTS,
  REPORTS_STATISTICS,
  SUPPORT_STATISTICS,
  QUESTIONS,
  UNANSWERED_QUESTIONS,
  USER_QUESTIONS,
  ACTIVE_SUPPORT_USERS,
}

class ReportedContent {
  final String id;
  final String title;
  final String content;
  final ContentType type;
  final ReportReason reason;
  final ModerationStatus status;
  final DateTime reportedAt;
  final String reportedBy;
  final int reportCount;
  final String? notes;
  final Map<String, dynamic> metadata;

  // Добавьте эти поля:
  final String? username;
  final String? email;
  final String? violationDetails;
  final String? userId; // Для идентификации пользователя

  const ReportedContent({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.reason,
    required this.status,
    required this.reportedAt,
    required this.reportedBy,
    required this.reportCount,
    this.notes,
    this.metadata = const {},
    // Инициализируйте новые поля:
    this.username,
    this.email,
    this.violationDetails,
    this.userId,
  });

  ReportedContent copyWith({
    String? id,
    String? title,
    String? content,
    ContentType? type,
    ReportReason? reason,
    ModerationStatus? status,
    DateTime? reportedAt,
    String? reportedBy,
    int? reportCount,
    String? notes,
    Map<String, dynamic>? metadata,
    String? username,
    String? email,
    String? violationDetails,
    String? userId,
  }) {
    return ReportedContent(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      reportedAt: reportedAt ?? this.reportedAt,
      reportedBy: reportedBy ?? this.reportedBy,
      reportCount: reportCount ?? this.reportCount,
      notes: notes ?? this.notes,
      metadata: metadata ?? this.metadata,
      username: username ?? this.username,
      email: email ?? this.email,
      violationDetails: violationDetails ?? this.violationDetails,
      userId: userId ?? this.userId,
    );
  }
}

enum ContentType { post, comment, message, profile, meeting, other }

enum ReportReason {
  spam,
  harassment,
  inappropriate,
  misinformation,
  copyright,
  other,
}

enum ModerationStatus { pending, approved, rejected, warned, banned }
