import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/moderation/cubit/moderation_cubit.dart';

class ReportedContentList extends StatelessWidget {
  final List<ReportedContent> contentItems;

  const ReportedContentList({super.key, required this.contentItems});

  @override
  Widget build(BuildContext context) {
    if (contentItems.isEmpty) {
      return const EmptyContent();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Reported Content',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${contentItems.length} items',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: contentItems.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return ReportedContentCard(contentItem: contentItems[index]);
          },
        ),
      ],
    );
  }
}

class ReportedContentCard extends StatelessWidget {
  final ReportedContent contentItem;

  const ReportedContentCard({super.key, required this.contentItem});

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
                _buildReasonIcon(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contentItem.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[900],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getReasonText(contentItem.reason),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                contentItem.content,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person_outline, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  'Reporter: ${contentItem.reportedBy}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  _formatDate(contentItem.reportedAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            if (contentItem.notes != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 14, color: Colors.blue[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        contentItem.notes!,
                        style: TextStyle(fontSize: 12, color: Colors.blue[700]),
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

  Widget _buildReasonIcon() {
    IconData icon;
    Color color;

    switch (contentItem.reason) {
      case ReportReason.spam:
        icon = Icons.report_gmailerrorred;
        color = Colors.orange;
        break;
      case ReportReason.harassment:
        icon = Icons.warning;
        color = Colors.red;
        break;
      case ReportReason.inappropriate:
        icon = Icons.block;
        color = Colors.purple;
        break;
      case ReportReason.misinformation:
        icon = Icons.info;
        color = Colors.amber;
        break;
      case ReportReason.copyright:
        icon = Icons.copyright;
        color = Colors.blue;
        break;
      case ReportReason.other:
        icon = Icons.flag;
        color = Colors.grey;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }

  String _getReasonText(ReportReason reason) {
    switch (reason) {
      case ReportReason.spam:
        return 'Spam';
      case ReportReason.harassment:
        return 'Harassment';
      case ReportReason.inappropriate:
        return 'Inappropriate Content';
      case ReportReason.misinformation:
        return 'Misinformation';
      case ReportReason.copyright:
        return 'Copyright Violation';
      case ReportReason.other:
        return 'Other';
    }
  }

  Widget _buildStatusBadge() {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (contentItem.status) {
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
        border: Border.all(color: textColor.withAlpha(100)),
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
        if (contentItem.status == ModerationStatus.pending) ...[
          ElevatedButton.icon(
            onPressed: () =>
                context.read<ModerationCubit>().approveContent(contentItem.id),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[50],
              foregroundColor: Colors.green[700],
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.green[100]!),
              ),
            ),
            icon: const Icon(Icons.check, size: 16),
            label: const Text('Approve'),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () =>
                context.read<ModerationCubit>().rejectContent(contentItem.id),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[50],
              foregroundColor: Colors.red[700],
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.red[100]!),
              ),
            ),
            icon: const Icon(Icons.close, size: 16),
            label: const Text('Reject'),
          ),
        ],
        if (contentItem.status != ModerationStatus.pending) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Resolved',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
        const Spacer(),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: Colors.grey[600]),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'view_details',
              child: Row(
                children: [
                  Icon(Icons.visibility, size: 16),
                  SizedBox(width: 8),
                  Text('View Details'),
                ],
              ),
            ),
            if (contentItem.status == ModerationStatus.pending)
              const PopupMenuItem(
                value: 'quick_approve',
                child: Row(
                  children: [
                    Icon(Icons.bolt, size: 16),
                    SizedBox(width: 8),
                    Text('Quick Approve'),
                  ],
                ),
              ),
          ],
          onSelected: (value) {
            switch (value) {
              case 'view_details':
                // TODO: Implement view details
                break;
              case 'quick_approve':
                context.read<ModerationCubit>().approveContent(contentItem.id);
                break;
            }
          },
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
            Icon(Icons.flag_outlined, size: 64, color: Colors.grey[300]),
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
              'All moderation reports have been reviewed and processed',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => context.read<ModerationCubit>().refresh(),
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}
