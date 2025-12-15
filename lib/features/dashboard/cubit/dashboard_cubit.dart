import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/model/statistics/admin_system_statistics_dto/admin_system_statistics_dto.dart';
import 'package:meet_now_app_server/model/statistics/realtime_statistics_dto/realtime_statistics_dto.dart';
import 'package:meet_now_app_server/repository/admin/admin_interface.dart';
import 'package:meet_now_app_server/repository/admin/admin_repository.dart';

part 'dashboard_state.dart';
part 'dashboard_cubit.freezed.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({required AdminInterface adminInterface})
    : _adminInterface = adminInterface,
      super(DashboardState.initial()) {
    _loadDashboardData();
  }

  final AdminInterface _adminInterface;

  Future<void> _loadDashboardData() async {
    emit(state.copyWith(isLoading: true));

    try {
      final systemStats = await _adminInterface.getSystemStatistics();
      final realtimeStats = await _adminInterface.getRealtimeStatistics();
      final activeSessionsCount = await _adminInterface
          .getActiveSessionsCount();
      final onlineUsersCount = await _adminInterface.getOnlineUsersCount();
      final newUsersCount = await _adminInterface.getNewUsersCount(hours: 24);

      final meetingStats = _createMeetingStats(systemStats);
      final alerts = _createSystemAlerts(systemStats);

      emit(
        state.copyWith(
          isLoading: false,
          totalUsers: systemStats.userStatistics.totalUsers,
          activeSessions: activeSessionsCount.activeSessionsCount,
          totalMeetings: systemStats.chatStatistics.totalChats,
          systemHealth: _calculateSystemHealth(systemStats),
          meetingStats: meetingStats,
          alerts: alerts,
          lastUpdated: DateTime.now(),
          error: null,
          onlineUsers: onlineUsersCount,
          newUsers: newUsersCount,
          realtimeStats: realtimeStats,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  List<MeetingStats> _createMeetingStats(AdminSystemStatisticsDto systemStats) {
    final baseMeetings = systemStats.chatStatistics.activeChats;
    final baseParticipants = systemStats.userStatistics.onlineUsers;

    return [
      MeetingStats(
        period: 'Mon',
        meetings: (baseMeetings * 0.8).round(),
        participants: (baseParticipants * 0.7).round(),
      ),
      MeetingStats(
        period: 'Tue',
        meetings: (baseMeetings * 0.9).round(),
        participants: (baseParticipants * 0.8).round(),
      ),
      MeetingStats(
        period: 'Wed',
        meetings: (baseMeetings * 1.0).round(),
        participants: (baseParticipants * 0.9).round(),
      ),
      MeetingStats(
        period: 'Thu',
        meetings: (baseMeetings * 1.1).round(),
        participants: (baseParticipants * 1.0).round(),
      ),
      MeetingStats(
        period: 'Fri',
        meetings: (baseMeetings * 1.2).round(),
        participants: (baseParticipants * 1.1).round(),
      ),
      MeetingStats(
        period: 'Sat',
        meetings: (baseMeetings * 0.7).round(),
        participants: (baseParticipants * 0.6).round(),
      ),
      MeetingStats(
        period: 'Sun',
        meetings: (baseMeetings * 0.6).round(),
        participants: (baseParticipants * 0.5).round(),
      ),
    ];
  }

  List<SystemAlert> _createSystemAlerts(AdminSystemStatisticsDto systemStats) {
    final alerts = <SystemAlert>[];

    if (systemStats.systemMetrics.systemUptimeHours < 1) {
      alerts.add(
        SystemAlert(
          title: 'System Restart',
          message: 'System was recently restarted',
          type: AlertType.warning,
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
      );
    }

    if (systemStats.reportStatistics.totalReports > 100) {
      alerts.add(
        SystemAlert(
          title: 'High Report Volume',
          message:
              '${systemStats.reportStatistics.totalReports} reports pending',
          type: AlertType.warning,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      );
    }

    if (systemStats.userStatistics.blockedUsers > 50) {
      alerts.add(
        SystemAlert(
          title: 'User Management',
          message:
              '${systemStats.userStatistics.blockedUsers} users are blocked',
          type: AlertType.info,
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      );
    }

    final healthScore = _calculateSystemHealth(systemStats);
    if (healthScore > 90) {
      alerts.add(
        SystemAlert(
          title: 'System Status',
          message: 'All systems operational',
          type: AlertType.success,
          timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        ),
      );
    } else if (healthScore < 70) {
      alerts.add(
        SystemAlert(
          title: 'System Performance',
          message: 'System performance below optimal levels',
          type: AlertType.warning,
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
      );
    }

    return alerts;
  }

  double _calculateSystemHealth(AdminSystemStatisticsDto systemStats) {
    double healthScore = 100.0;

    final blockedUsersRatio =
        systemStats.userStatistics.blockedUsers /
        (systemStats.userStatistics.totalUsers > 0
            ? systemStats.userStatistics.totalUsers
            : 1);
    if (blockedUsersRatio > 0.1) {
      healthScore -= 20;
    }

    if (systemStats.reportStatistics.totalReports > 100) {
      healthScore -= 15;
    } else if (systemStats.reportStatistics.totalReports > 50) {
      healthScore -= 5;
    }

    final sessionActivityRatio =
        systemStats.systemMetrics.activeSessions /
        (systemStats.userStatistics.onlineUsers > 0
            ? systemStats.userStatistics.onlineUsers
            : 1);
    if (sessionActivityRatio < 0.3) {
      healthScore -= 10;
    }

    if (systemStats.systemMetrics.systemUptimeHours < 1) {
      healthScore -= 5;
    }

    return healthScore.clamp(0.0, 100.0);
  }

  Future<void> refresh() async {
    emit(state.copyWith(isLoading: true));
    await _loadDashboardData();
  }
}
