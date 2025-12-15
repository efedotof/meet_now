import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/system/cubit/system_cubit.dart';

class SystemConfigCard extends StatelessWidget {
  final SystemConfig config;

  const SystemConfigCard({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'System Configuration',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 20),
            _buildConfigSwitch(
              context,
              'Maintenance Mode',
              'Put system in maintenance mode',
              config.maintenanceMode,
              (value) =>
                  context.read<SystemCubit>().toggleMaintenanceMode(value),
            ),
            const SizedBox(height: 16),
            _buildConfigSwitch(
              context,
              'Auto Backup',
              'Automatically create system backups',
              config.autoBackup,
              (value) => context.read<SystemCubit>().toggleAutoBackup(value),
            ),
            const SizedBox(height: 16),
            _buildConfigSwitch(
              context,
              'Debug Mode',
              'Enable detailed logging and debugging',
              config.debugMode,
              (value) => context.read<SystemCubit>().toggleDebugMode(value),
            ),
            const SizedBox(height: 16),
            _buildConfigSwitch(
              context,
              'Email Notifications',
              'Send email notifications for system events',
              config.emailNotifications,
              (value) =>
                  context.read<SystemCubit>().toggleEmailNotifications(value),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildConfigNumber(
                    context,
                    'Backup Frequency',
                    '${config.backupFrequency}h',
                    (value) => context
                        .read<SystemCubit>()
                        .updateBackupFrequency(value),
                    1,
                    168,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildConfigNumber(
                    context,
                    'Log Retention',
                    '${config.logRetentionDays}d',
                    (value) =>
                        context.read<SystemCubit>().updateLogRetention(value),
                    1,
                    365,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigSwitch(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Colors.blue[600],
        ),
      ],
    );
  }

  Widget _buildConfigNumber(
    BuildContext context,
    String title,
    String value,
    Function(int) onChanged,
    int min,
    int max,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.arrow_drop_up, size: 16),
                onPressed: () {
                  final current = int.parse(
                    value.replaceAll(RegExp(r'[^0-9]'), ''),
                  );
                  if (current < max) onChanged(current + 1);
                },
              ),
              IconButton(
                icon: Icon(Icons.arrow_drop_down, size: 16),
                onPressed: () {
                  final current = int.parse(
                    value.replaceAll(RegExp(r'[^0-9]'), ''),
                  );
                  if (current > min) onChanged(current - 1);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
