import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/supports/answer/answer.dart';

class AnswerCard extends StatelessWidget {
  final Answer answer;
  final bool isMobile;
  const AnswerCard({super.key, required this.answer, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: isMobile ? 8 : 12),
      color: Colors.grey[50],
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
                Text(
                  '${S.of(context).author} ${answer.createdBy}',
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    color: Colors.grey,
                  ),
                ),
                const Spacer(),
                Text(
                  '${answer.createdAt.day.toString().padLeft(2, '0')}.${answer.createdAt.month.toString().padLeft(2, '0')}.${answer.createdAt.year} ${answer.createdAt.hour.toString().padLeft(2, '0')}:${answer.createdAt.minute.toString().padLeft(2, '0')}',
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
