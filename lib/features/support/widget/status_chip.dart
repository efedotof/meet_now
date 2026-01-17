import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';

class StatusChip extends StatelessWidget {
  final String status;
  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.grey.withAlpha(20);
    Color textColor = Colors.grey;
    String statusText = status;

    switch (status) {
      case "PENDING":
        backgroundColor = Colors.orange.withAlpha(20);
        textColor = Colors.orange;
        statusText = S.of(context).AWAITING;
        break;
      case "RECEIVED":
        backgroundColor = Colors.blue.withAlpha(20);
        textColor = Colors.blue;
        statusText = S.of(context).RECEIVED;
        break;
      case "RESOLVED":
        backgroundColor = Colors.green.withAlpha(20);
        textColor = Colors.green;
        statusText = S.of(context).ITSDECIDED;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
