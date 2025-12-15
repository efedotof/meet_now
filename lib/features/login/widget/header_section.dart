import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.blue[50],
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blue[100]!, width: 2),
          ),
          child: Icon(Icons.developer_mode, size: 40, color: Colors.blue[700]),
        ),
        const SizedBox(height: 16),
        Text(
          'Developer Portal',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.grey[900],
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Meet Now Admin System',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
