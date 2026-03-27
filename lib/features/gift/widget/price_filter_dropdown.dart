import 'package:flutter/material.dart';
import 'package:meet_now_app/features/gift/cubit/gift_cubit.dart';

class PriceFilterDropdown extends StatelessWidget {
  final PriceRange? currentRange;
  final ValueChanged<PriceRange?>? onChanged;

  const PriceFilterDropdown({
    super.key,
    required this.currentRange,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.brightnessOf(context) == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white12 : Colors.black12,
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButton<PriceRange?>(
        value: currentRange,
        isDense: true,
        underline: Container(),
        icon: const Icon(Icons.arrow_drop_down, size: 16, color: Colors.grey),
        style: const TextStyle(fontSize: 14, color: Colors.grey),
        items: [
          const DropdownMenuItem(
            value: null,
            child: Text('Цена', style: TextStyle(fontSize: 14)),
          ),
          ...PriceRange.values.map((range) {
            return DropdownMenuItem(
              value: range,
              child: Text(range.label, style: const TextStyle(fontSize: 14)),
            );
          }),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
