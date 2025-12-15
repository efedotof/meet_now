part of 'moderation_cubit.dart';

@freezed
abstract class ModerationState with _$ModerationState {
  const factory ModerationState({
    required bool isLoading,
    required List<ReportedContent> reportedContent,
    required List<UserReport> userReports,
    required ModerationFilter filter,
    required String searchQuery,
    required int currentPage,
    required bool hasMore,
    ReportStatisticsDto? reportsStatistics,
    SupportStatisticsDto? supportStatistics,
    String? error,
  }) = _ModerationState;

  factory ModerationState.initial() => ModerationState(
    isLoading: true,
    reportedContent: [],
    userReports: [],
    filter: ModerationFilter.PENDING,
    searchQuery: '',
    currentPage: 1,
    hasMore: true,
    reportsStatistics: null,
    supportStatistics: null,
    error: null,
  );
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
    );
  }
}

class UserReport {
  final String id;
  final String userId;
  final String username;
  final String email;
  final ReportReason reason;
  final ModerationStatus status;
  final DateTime reportedAt;
  final String reportedBy;
  final int reportCount;
  final String? violationDetails;

  const UserReport({
    required this.id,
    required this.userId,
    required this.username,
    required this.email,
    required this.reason,
    required this.status,
    required this.reportedAt,
    required this.reportedBy,
    required this.reportCount,
    this.violationDetails,
  });

  UserReport copyWith({
    String? id,
    String? userId,
    String? username,
    String? email,
    ReportReason? reason,
    ModerationStatus? status,
    DateTime? reportedAt,
    String? reportedBy,
    int? reportCount,
    String? violationDetails,
  }) {
    return UserReport(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      reportedAt: reportedAt ?? this.reportedAt,
      reportedBy: reportedBy ?? this.reportedBy,
      reportCount: reportCount ?? this.reportCount,
      violationDetails: violationDetails ?? this.violationDetails,
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

enum ModerationFilter { PENDING, RECEIVED, RESOLVED, }