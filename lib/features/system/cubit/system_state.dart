part of 'system_cubit.dart';

@freezed
abstract class SystemState with _$SystemState {
  const factory SystemState({
    required bool isLoading,
    required SystemHealth systemHealth,
    required ServerStatus serverStatus,
    required List<SystemLog> systemLogs,
    required SystemConfig config,
    required List<BackupRecord> backups,
    required SystemPerformance performance,
    required String searchQuery,
  }) = _SystemState;

  factory SystemState.initial() => SystemState(
    isLoading: true,
    systemHealth: SystemHealth.initial(),
    serverStatus: ServerStatus.initial(),
    systemLogs: [],
    config: SystemConfig.defaults(),
    backups: [],
    performance: SystemPerformance.initial(),
    searchQuery: '',
  );
}

class SystemHealth {
  final double cpuUsage;
  final double memoryUsage;
  final double diskUsage;
  final double networkUsage;
  final int activeConnections;
  final DateTime lastUpdated;

  const SystemHealth({
    required this.cpuUsage,
    required this.memoryUsage,
    required this.diskUsage,
    required this.networkUsage,
    required this.activeConnections,
    required this.lastUpdated,
  });

  factory SystemHealth.initial() => SystemHealth(
    cpuUsage: 0.0,
    memoryUsage: 0.0,
    diskUsage: 0.0,
    networkUsage: 0.0,
    activeConnections: 0,
    lastUpdated: DateTime.now(),
  );
}

class ServerStatus {
  final bool database;
  final bool cache;
  final bool fileStorage;
  final bool emailService;
  final bool pushService;
  final bool analytics;
  final DateTime lastChecked;

  const ServerStatus({
    required this.database,
    required this.cache,
    required this.fileStorage,
    required this.emailService,
    required this.pushService,
    required this.analytics,
    required this.lastChecked,
  });

  factory ServerStatus.initial() => ServerStatus(
    database: true,
    cache: true,
    fileStorage: true,
    emailService: true,
    pushService: true,
    analytics: true,
    lastChecked: DateTime.now(),
  );

  bool get allServicesRunning =>
      database &&
      cache &&
      fileStorage &&
      emailService &&
      pushService &&
      analytics;
}

class SystemLog {
  final String id;
  final LogLevel level;
  final String message;
  final String component;
  final DateTime timestamp;
  final String? details;

  const SystemLog({
    required this.id,
    required this.level,
    required this.message,
    required this.component,
    required this.timestamp,
    this.details,
  });
}

class SystemConfig {
  final bool maintenanceMode;
  final bool autoBackup;
  final int backupFrequency;
  final int logRetentionDays;
  final int sessionTimeout;
  final bool debugMode;
  final bool emailNotifications;
  final int maxFileSize;

  const SystemConfig({
    required this.maintenanceMode,
    required this.autoBackup,
    required this.backupFrequency,
    required this.logRetentionDays,
    required this.sessionTimeout,
    required this.debugMode,
    required this.emailNotifications,
    required this.maxFileSize,
  });

  factory SystemConfig.defaults() => const SystemConfig(
    maintenanceMode: false,
    autoBackup: true,
    backupFrequency: 24,
    logRetentionDays: 30,
    sessionTimeout: 60,
    debugMode: false,
    emailNotifications: true,
    maxFileSize: 100,
  );

  SystemConfig copyWith({
    bool? maintenanceMode,
    bool? autoBackup,
    int? backupFrequency,
    int? logRetentionDays,
    int? sessionTimeout,
    bool? debugMode,
    bool? emailNotifications,
    int? maxFileSize,
  }) {
    return SystemConfig(
      maintenanceMode: maintenanceMode ?? this.maintenanceMode,
      autoBackup: autoBackup ?? this.autoBackup,
      backupFrequency: backupFrequency ?? this.backupFrequency,
      logRetentionDays: logRetentionDays ?? this.logRetentionDays,
      sessionTimeout: sessionTimeout ?? this.sessionTimeout,
      debugMode: debugMode ?? this.debugMode,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      maxFileSize: maxFileSize ?? this.maxFileSize,
    );
  }
}

class BackupRecord {
  final String id;
  final String name;
  final DateTime createdAt;
  final BackupStatus status;
  final double size;
  final String? notes;

  const BackupRecord({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.status,
    required this.size,
    this.notes,
  });

  BackupRecord copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    BackupStatus? status,
    double? size,
    String? notes,
  }) {
    return BackupRecord(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      size: size ?? this.size,
      notes: notes ?? this.notes,
    );
  }
}

class SystemPerformance {
  final double averageResponseTime;
  final int requestsPerMinute;
  final int errorRate;
  final int activeUsers;
  final List<PerformancePoint> history;

  const SystemPerformance({
    required this.averageResponseTime,
    required this.requestsPerMinute,
    required this.errorRate,
    required this.activeUsers,
    required this.history,
  });

  factory SystemPerformance.initial() => SystemPerformance(
    averageResponseTime: 0.0,
    requestsPerMinute: 0,
    errorRate: 0,
    activeUsers: 0,
    history: [],
  );
}

class PerformancePoint {
  final DateTime timestamp;
  final double responseTime;
  final int requests;

  const PerformancePoint({
    required this.timestamp,
    required this.responseTime,
    required this.requests,
  });
}

enum LogLevel { info, warning, error, debug, critical }

enum BackupStatus { completed, failed, inProgress, cancelled }
