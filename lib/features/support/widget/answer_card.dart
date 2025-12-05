import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/supports/answer/answer.dart';

class AnswerCard extends StatelessWidget {
  final Answer answer;
  const AnswerCard({super.key, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(answer.content, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Divider(height: 1, color: Colors.grey[300]),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${S.of(context).author} ${answer.createdBy}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const Spacer(),
                Text(
                  '${answer.createdAt.day.toString().padLeft(2, '0')}.${answer.createdAt.month.toString().padLeft(2, '0')}.${answer.createdAt.year} ${answer.createdAt.hour.toString().padLeft(2, '0')}:${answer.createdAt.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
