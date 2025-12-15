import 'package:flutter/material.dart';

class LastUpdated extends StatelessWidget {
  final DateTime? lastUpdated;

  const LastUpdated({super.key, required this.lastUpdated});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.update, size: 12, color: Colors.grey[500]),
          const SizedBox(width: 6),
          Text(
            lastUpdated != null
                ? 'Updated: ${_formatDateTime(lastUpdated!)}'
                : 'Never updated',
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
