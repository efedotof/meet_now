import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/system/cubit/system_cubit.dart';

class BackupsCard extends StatelessWidget {
  final List<BackupRecord> backups;

  const BackupsCard({super.key, required this.backups});

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
            Row(
              children: [
                Text(
                  'System Backups',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => context.read<SystemCubit>().createBackup(),
                  icon: const Icon(Icons.backup, size: 18),
                  label: const Text('Create Backup'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (backups.isEmpty)
              const EmptyBackups()
            else
              Column(
                children: backups
                    .map((backup) => BackupItem(backup: backup))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class BackupItem extends StatelessWidget {
  final BackupRecord backup;

  const BackupItem({super.key, required this.backup});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          _buildStatusIcon(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  backup.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(backup.createdAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                if (backup.notes != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    backup.notes!,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${backup.size} GB',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 4),
              _buildStatusBadge(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon() {
    IconData icon;
    Color color;

    switch (backup.status) {
      case BackupStatus.completed:
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case BackupStatus.failed:
        icon = Icons.error;
        color = Colors.red;
        break;
      case BackupStatus.inProgress:
        icon = Icons.autorenew;
        color = Colors.orange;
        break;
      case BackupStatus.cancelled:
        icon = Icons.cancel;
        color = Colors.grey;
        break;
    }

    return Icon(icon, color: color, size: 24);
  }

  Widget _buildStatusBadge() {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (backup.status) {
      case BackupStatus.completed:
        backgroundColor = Colors.green[50]!;
        textColor = Colors.green[700]!;
        text = 'Completed';
        break;
      case BackupStatus.failed:
        backgroundColor = Colors.red[50]!;
        textColor = Colors.red[700]!;
        text = 'Failed';
        break;
      case BackupStatus.inProgress:
        backgroundColor = Colors.orange[50]!;
        textColor = Colors.orange[700]!;
        text = 'In Progress';
        break;
      case BackupStatus.cancelled:
        backgroundColor = Colors.grey[200]!;
        textColor = Colors.grey[700]!;
        text = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class EmptyBackups extends StatelessWidget {
  const EmptyBackups({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(Icons.backup, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No Backups Available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first system backup to get started',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
