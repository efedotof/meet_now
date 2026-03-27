import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/gifts/gift/gift.dart';

class CostChip extends StatelessWidget {
  const CostChip({super.key, required this.gift});
  final Gift gift;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color:
            Theme.brightnessOf(context) == Brightness.dark
                ? Colors.white60
                : Colors.black87,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.stars, size: 16, color: Colors.amber[800]),
          const SizedBox(width: 4),
          Text(
            '${gift.costPoints} ${S.of(context).points}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color:
                  Theme.brightnessOf(context) == Brightness.dark
                      ? Colors.black
                      : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
