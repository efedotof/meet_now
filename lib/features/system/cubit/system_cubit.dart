import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/repository/admin/admin_interface.dart';

part 'system_state.dart';
part 'system_cubit.freezed.dart';

class SystemCubit extends Cubit<SystemState> {
  SystemCubit({required AdminInterface adminInterface}) : _adminInterface = adminInterface, super(SystemState.initial()) {
    _loadSystemData();
  }

  final AdminInterface _adminInterface;


  Future<void> _loadSystemData() async {
    await Future.delayed(const Duration(seconds: 2));

    final systemHealth = SystemHealth(
      cpuUsage: 45.2,
      memoryUsage: 67.8,
      diskUsage: 32.1,
      networkUsage: 12.4,
      activeConnections: 342,
      lastUpdated: DateTime.now(),
    );

    final serverStatus = ServerStatus(
      database: true,
      cache: true,
      fileStorage: true,
      emailService: true,
      pushService: true,
      analytics: false,
      lastChecked: DateTime.now(),
    );

    final systemLogs = [
      SystemLog(
        id: '1',
        level: LogLevel.info,
        message: 'System startup completed',
        component: 'Core',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      SystemLog(
        id: '2',
        level: LogLevel.warning,
        message: 'High memory usage detected',
        component: 'Monitoring',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        details: 'Memory usage exceeded 80% threshold',
      ),
      SystemLog(
        id: '3',
        level: LogLevel.error,
        message: 'Analytics service connection failed',
        component: 'Analytics',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        details: 'Failed to connect to analytics service at 10.0.1.45:8080',
      ),
      SystemLog(
        id: '4',
        level: LogLevel.info,
        message: 'Backup completed successfully',
        component: 'Backup',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      SystemLog(
        id: '5',
        level: LogLevel.debug,
        message: 'User session created',
        component: 'Auth',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ];

    final backups = [
      BackupRecord(
        id: '1',
        name: 'backup_2024_01_15',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        status: BackupStatus.completed,
        size: 2.4,
        notes: 'Full system backup',
      ),
      BackupRecord(
        id: '2',
        name: 'backup_2024_01_14',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        status: BackupStatus.completed,
        size: 2.3,
      ),
      BackupRecord(
        id: '3',
        name: 'backup_2024_01_13',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        status: BackupStatus.failed,
        size: 0.0,
        notes: 'Network timeout during backup',
      ),
    ];

    final performance = SystemPerformance(
      averageResponseTime: 245.6,
      requestsPerMinute: 3420,
      errorRate: 2,
      activeUsers: 892,
      history: [
        PerformancePoint(
          timestamp: DateTime.now().subtract(const Duration(hours: 6)),
          responseTime: 230.1,
          requests: 2890,
        ),
        PerformancePoint(
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          responseTime: 245.6,
          requests: 3120,
        ),
        PerformancePoint(
          timestamp: DateTime.now().subtract(const Duration(hours: 4)),
          responseTime: 267.8,
          requests: 3420,
        ),
        PerformancePoint(
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          responseTime: 254.3,
          requests: 2980,
        ),
        PerformancePoint(
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          responseTime: 231.9,
          requests: 2760,
        ),
        PerformancePoint(
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          responseTime: 245.6,
          requests: 3240,
        ),
      ],
    );

    emit(
      state.copyWith(
        isLoading: false,
        systemHealth: systemHealth,
        serverStatus: serverStatus,
        systemLogs: systemLogs,
        backups: backups,
        performance: performance,
      ),
    );
  }

  void toggleMaintenanceMode(bool enabled) {
    final updatedConfig = state.config.copyWith(maintenanceMode: enabled);
    emit(state.copyWith(config: updatedConfig));
  }

  void toggleAutoBackup(bool enabled) {
    final updatedConfig = state.config.copyWith(autoBackup: enabled);
    emit(state.copyWith(config: updatedConfig));
  }

  void updateBackupFrequency(int hours) {
    final updatedConfig = state.config.copyWith(backupFrequency: hours);
    emit(state.copyWith(config: updatedConfig));
  }

  void updateLogRetention(int days) {
    final updatedConfig = state.config.copyWith(logRetentionDays: days);
    emit(state.copyWith(config: updatedConfig));
  }

  void toggleDebugMode(bool enabled) {
    final updatedConfig = state.config.copyWith(debugMode: enabled);
    emit(state.copyWith(config: updatedConfig));
  }

  void toggleEmailNotifications(bool enabled) {
    final updatedConfig = state.config.copyWith(emailNotifications: enabled);
    emit(state.copyWith(config: updatedConfig));
  }

  void searchLogs(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void clearLogs() {
    emit(state.copyWith(systemLogs: []));
  }

  Future<void> createBackup() async {
    final newBackup = BackupRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'backup_${DateTime.now().toIso8601String().split('T').first}',
      createdAt: DateTime.now(),
      status: BackupStatus.inProgress,
      size: 0.0,
    );

    emit(state.copyWith(backups: [newBackup, ...state.backups]));

    await Future.delayed(const Duration(seconds: 3));

    final updatedBackups = state.backups.map((backup) {
      if (backup.id == newBackup.id) {
        return backup.copyWith(
          status: BackupStatus.completed,
          size: 2.5,
          notes: 'Manual backup created successfully',
        );
      }
      return backup;
    }).toList();

    emit(state.copyWith(backups: updatedBackups));
  }

  Future<void> restartServices() async {
    await Future.delayed(const Duration(seconds: 2));

    final updatedStatus = ServerStatus(
      database: true,
      cache: true,
      fileStorage: true,
      emailService: true,
      pushService: true,
      analytics: true,
      lastChecked: DateTime.now(),
    );

    emit(state.copyWith(serverStatus: updatedStatus));
  }

  Future<void> refresh() async {
    emit(state.copyWith(isLoading: true));
    await _loadSystemData();
  }
}
