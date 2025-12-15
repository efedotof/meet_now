import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/system/cubit/system_cubit.dart';

class SystemLogsCard extends StatelessWidget {
  final List<SystemLog> logs;
  final String searchQuery;

  const SystemLogsCard({
    super.key,
    required this.logs,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final filteredLogs = logs.where((log) {
      final query = searchQuery.toLowerCase();
      return log.message.toLowerCase().contains(query) ||
          log.component.toLowerCase().contains(query) ||
          log.level.toString().toLowerCase().contains(query);
    }).toList();

    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'System Logs',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
                const Spacer(),
                _buildSearchField(context),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => context.read<SystemCubit>().clearLogs(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    foregroundColor: Colors.grey[700],
                    elevation: 0,
                  ),
                  child: const Text('Clear Logs'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (filteredLogs.isEmpty)
              const EmptyLogs()
            else
              Column(
                children: filteredLogs.map((log) => LogItem(log: log)).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return SizedBox(
      width: 200,
      child: TextField(
        onChanged: (query) => context.read<SystemCubit>().searchLogs(query),
        decoration: InputDecoration(
          hintText: 'Search logs...',
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          prefixIcon: const Icon(Icons.search, size: 20),
        ),
      ),
    );
  }
}

class LogItem extends StatelessWidget {
  final SystemLog log;

  const LogItem({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getLogColor(log.level).withAlpha(1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getLogColor(log.level).withAlpha(3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLevelIcon(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.message,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.computer, size: 12, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      log.component,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      _formatTime(log.timestamp),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                if (log.details != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    log.details!,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelIcon() {
    IconData icon;
    Color color = _getLogColor(log.level);

    switch (log.level) {
      case LogLevel.info:
        icon = Icons.info;
        break;
      case LogLevel.warning:
        icon = Icons.warning;
        break;
      case LogLevel.error:
        icon = Icons.error;
        break;
      case LogLevel.debug:
        icon = Icons.bug_report;
        break;
      case LogLevel.critical:
        icon = Icons.crisis_alert;
        break;
    }

    return Icon(icon, color: color, size: 20);
  }

  Color _getLogColor(LogLevel level) {
    switch (level) {
      case LogLevel.info:
        return Colors.blue;
      case LogLevel.warning:
        return Colors.orange;
      case LogLevel.error:
        return Colors.red;
      case LogLevel.debug:
        return Colors.green;
      case LogLevel.critical:
        return Colors.purple;
    }
  }

  String _formatTime(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
  }
}

class EmptyLogs extends StatelessWidget {
  const EmptyLogs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(Icons.list_alt, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No Logs Available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'System logs will appear here as events occur',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
