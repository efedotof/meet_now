import 'package:flutter/material.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 16),
        Text(
          'Meet Now Admin v1.0 • Developer Access Only',
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.security, size: 12, color: Colors.grey[400]),
            const SizedBox(width: 4),
            Text(
              'Secure developer authentication',
              style: TextStyle(color: Colors.grey[500], fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }
}
