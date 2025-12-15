import 'package:flutter/material.dart';
import 'package:meet_now_admin_panel/features/moderation/cubit/moderation_cubit.dart';
import 'package:meet_now_app_server/model/social/report/report_statistics_dto/report_statistics_dto.dart';

class ModerationStats extends StatelessWidget {
  final List<ReportedContent> reportedContent;
  final ReportStatisticsDto? statistics;

  const ModerationStats({
    super.key,
    required this.reportedContent,
    this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    final pendingContent = reportedContent
        .where((item) => item.status == ModerationStatus.pending)
        .length;
    final approvedContent = reportedContent
        .where((item) => item.status == ModerationStatus.approved)
        .length;
    final rejectedContent = reportedContent
        .where((item) => item.status == ModerationStatus.rejected)
        .length;
    final totalReports = reportedContent.length;

    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            _buildStatItem(
              'Pending',
              pendingContent.toString(),
              Icons.pending_actions,
              Colors.orange,
            ),
            const VerticalDivider(),
            _buildStatItem(
              'Approved',
              approvedContent.toString(),
              Icons.check_circle,
              Colors.green,
            ),
            const VerticalDivider(),
            _buildStatItem(
              'Rejected',
              rejectedContent.toString(),
              Icons.cancel,
              Colors.red,
            ),
            const VerticalDivider(),
            _buildStatItem(
              'Total',
              totalReports.toString(),
              Icons.flag,
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.grey[900],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
