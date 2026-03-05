import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';

class StatusChip extends StatelessWidget {
  final String status;
  final bool isMobile;
  const StatusChip({super.key, required this.status, required this.isMobile});

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
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 8 : 12,
        vertical: isMobile ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
      ),
      child: Text(
        statusText.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: isMobile ? 10 : 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
