import 'package:flutter/material.dart';
import 'package:meet_now_app_server/model/social/question/question_status.dart';

class StatusChip extends StatelessWidget {
  final QuestionStatus status;
  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String text;

    switch (status) {
      case QuestionStatus.pending:
        bg = Colors.orange.withAlpha(30);
        fg = Colors.orange;
        text = 'ОЖИДАЕТ';
        break;
      case QuestionStatus.received:
        bg = Colors.blue.withAlpha(30);
        fg = Colors.blue;
        text = 'ПОЛУЧЕНО';
        break;
      case QuestionStatus.resolved:
        bg = Colors.green.withAlpha(30);
        fg = Colors.green;
        text = 'РЕШЕНО';
        break;
    }

    return Chip(
      backgroundColor: bg,
      label: Text(
        text,
        style: TextStyle(color: fg, fontWeight: FontWeight.bold),
      ),
    );
  }
}
