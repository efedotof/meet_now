import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';

class SearchResultsWidget extends StatelessWidget {
  final List<String> results;
  final TextEditingController controller;
  final VoidCallback onClear;

  const SearchResultsWidget({
    super.key,
    required this.results,
    required this.controller,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Text(
            '${S.of(context).found}:',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: results.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(results[index]),
                    selected: false,
                    onSelected: (_) {
                      controller.text = results[index];
                      onClear();
                    },
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    showCheckmark: false,
                    labelStyle: theme.textTheme.bodySmall,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                );
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 20, color: theme.colorScheme.primary),
            onPressed: onClear,
          ),
        ],
      ),
    );
  }
}
