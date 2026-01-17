import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

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
              onChanged: onChanged,

              style: const TextStyle(color: Colors.black, fontSize: 16),

              cursorColor: Colors.black,

              decoration: InputDecoration(
                fillColor: Colors.transparent,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isCollapsed: true,
                isDense: true,
                hintText: S.of(context).search,
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
