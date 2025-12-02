import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final String status;
  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String text;

    switch (status) {
      case "PENDING":
        bg = Colors.orange.withAlpha(30);
        fg = Colors.orange;
        text = 'ОЖИДАЕТ';
        break;
      case "RECEIVED":
        bg = Colors.blue.withAlpha(30);
        fg = Colors.blue;
        text = 'ПОЛУЧЕНО';
        break;
      case "RESOLVED":
        bg = Colors.green.withAlpha(30);
        fg = Colors.green;
        text = 'РЕШЕНО';
        break;
      default:
        bg = Colors.grey.withAlpha(30);
        fg = Colors.grey;
        text = status;
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
