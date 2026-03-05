import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String? text;
  final List<Widget>? children;
  final bool isMobile;
  const InfoCard(
    this.title,
    this.text, {
    super.key,
    this.children,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontSize: isMobile ? null : 18),
            ),
            const SizedBox(height: 8),
            if (text != null)
              Text(text!, style: TextStyle(fontSize: isMobile ? null : 16)),
            if (children != null) ...children!,
          ],
        ),
      ),
    );
  }
}
