import 'package:flutter/material.dart';

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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: results.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ChoiceChip(
                    label: Text(results[index]),
                    selected: false,
                    onSelected: (_) {
                      controller.text = results[index];
                      onClear();
                    },
                  ),
                );
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: onClear,
          ),
        ],
      ),
    );
  }
}
