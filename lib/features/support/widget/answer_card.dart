import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/supports/answer/answer.dart';

class AnswerCard extends StatelessWidget {
  final Answer answer;

  const AnswerCard({super.key, required this.answer});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Card(
      margin: EdgeInsets.symmetric(vertical: isMobile ? 8 : 12),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              answer.content,
              style: TextStyle(fontSize: isMobile ? 14 : 16),
            ),
            SizedBox(height: isMobile ? 8 : 12),
            Divider(height: 1, color: Colors.grey[300]),
            SizedBox(height: isMobile ? 8 : 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${S.of(context).author} ${answer.createdBy}',
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 14,
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${answer.createdAt.day.toString().padLeft(2, '0')}.'
                  '${answer.createdAt.month.toString().padLeft(2, '0')}.'
                  '${answer.createdAt.year} '
                  '${answer.createdAt.hour.toString().padLeft(2, '0')}:'
                  '${answer.createdAt.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
