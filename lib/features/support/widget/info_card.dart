import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String? text;
  final List<Widget>? children;
  const InfoCard(this.title, this.text, {super.key, this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (text != null) Text(text!),
            if (children != null) ...children!,
          ],
        ),
      ),
    );
  }
}
