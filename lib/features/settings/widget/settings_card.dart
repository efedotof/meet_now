import 'package:flutter/material.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key, required this.items});
  final List<Widget> items;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children:
            items
                .map(
                  (item) => Column(
                    children: [
                      item,
                      if (item != items.last)
                        Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                          color: Theme.of(context).dividerColor,
                        ),
                    ],
                  ),
                )
                .toList(),
      ),
    );
  }
}
