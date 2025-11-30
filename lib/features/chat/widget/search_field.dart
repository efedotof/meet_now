import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;

  const SearchField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey.shade600, size: 22),

          const SizedBox(width: 8),

          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search",
                hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              ),
            ),
          ),

          Icon(Icons.mic_none, color: Colors.grey.shade600, size: 22),
        ],
      ),
    );
  }
}
