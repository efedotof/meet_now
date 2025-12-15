import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/moderation/cubit/moderation_cubit.dart';

class UserReportsList extends StatelessWidget {
  final List<UserReport> userReports;

  const UserReportsList({super.key, required this.userReports});

  @override
  Widget build(BuildContext context) {
    if (userReports.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'User Reports',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[900],
          ),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: userReports.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return UserReportCard(userReport: userReports[index]);
          },
        ),
      ],
    );
  }
}

class UserReportCard extends StatelessWidget {
  final UserReport userReport;

  const UserReportCard({super.key, required this.userReport});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  child: Text(
                    userReport.username[0].toUpperCase(),
                    style: TextStyle(color: Colors.blue[600]),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userReport.username,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[900],
                        ),
                      ),
                      Text(
                        userReport.email,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  userReport.reportedBy,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  _formatDate(userReport.reportedAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const Spacer(),
                Icon(Icons.flag, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  '${userReport.reportCount} reports',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            if (userReport.violationDetails != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, size: 14, color: Colors.red[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        userReport.violationDetails!,
                        style: TextStyle(fontSize: 12, color: Colors.red[700]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (userReport.status) {
      case ModerationStatus.pending:
        backgroundColor = Colors.orange[50]!;
        textColor = Colors.orange[700]!;
        text = 'Pending';
        break;
      case ModerationStatus.approved:
        backgroundColor = Colors.green[50]!;
        textColor = Colors.green[700]!;
        text = 'Approved';
        break;
      case ModerationStatus.rejected:
        backgroundColor = Colors.red[50]!;
        textColor = Colors.red[700]!;
        text = 'Rejected';
        break;
      case ModerationStatus.warned:
        backgroundColor = Colors.yellow[50]!;
        textColor = Colors.yellow[700]!;
        text = 'Warned';
        break;
      case ModerationStatus.banned:
        backgroundColor = Colors.purple[50]!;
        textColor = Colors.purple[700]!;
        text = 'Banned';
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

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        if (userReport.status == ModerationStatus.pending) ...[
          ElevatedButton(
            onPressed: () =>
                context.read<ModerationCubit>().warnUser(userReport.id),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow[50],
              foregroundColor: Colors.yellow[700],
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.yellow[100]!),
              ),
            ),
            child: const Text('Warn User'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () =>
                context.read<ModerationCubit>().banUser(userReport.id),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[50],
              foregroundColor: Colors.red[700],
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.red[100]!),
              ),
            ),
            child: const Text('Ban User'),
          ),
        ],
        const Spacer(),
        IconButton(
          icon: Icon(Icons.more_vert, color: Colors.grey[600]),
          onPressed: () {},
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${difference.inDays ~/ 7}w ago';
  }
}

class EmptyContent extends StatelessWidget {
  const EmptyContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(Icons.flag, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No Reports Found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'All moderation reports have been reviewed',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
