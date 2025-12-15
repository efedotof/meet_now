part of 'dashboard_cubit.dart';

@freezed
abstract class DashboardState with _$DashboardState {
  const factory DashboardState({
    required bool isLoading,
    required int totalUsers,
    required int activeSessions,
    required int totalMeetings,
    required double systemHealth,
    required List<MeetingStats> meetingStats,
    required List<SystemAlert> alerts,
    DateTime? lastUpdated,
    String? error,
    required int onlineUsers,
    required int newUsers,
    required RealtimeStatisticsDto realtimeStats,
  }) = _DashboardState;

  factory DashboardState.initial() => DashboardState(
    isLoading: true,
    totalUsers: 0,
    activeSessions: 0,
    totalMeetings: 0,
    systemHealth: 0.0,
    meetingStats: [],
    alerts: [],
    lastUpdated: null,
    error: null,
    onlineUsers: 0,
    newUsers: 0,
    realtimeStats: RealtimeStatisticsDto(
      onlineUsers: 0,
      searchingUsers: 0,
      activeChats: 0,
      activeTemporaryChats: 0,
      activeSessions: 0,
      systemUptimeHours: 0,
      timestamp: DateTime.now(),
    ),
  );
}

class MeetingStats {
  final String period;
  final int meetings;
  final int participants;

  const MeetingStats({
    required this.period,
    required this.meetings,
    required this.participants,
  });
}

class SystemAlert {
  final String title;
  final String message;
  final AlertType type;
  final DateTime timestamp;

  const SystemAlert({
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
  });
}

enum AlertType { info, warning, error, success }
