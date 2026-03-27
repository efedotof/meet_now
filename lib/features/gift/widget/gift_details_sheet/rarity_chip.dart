import 'package:flutter/material.dart';
import 'package:meet_now_app_server/model/gifts/gift/gift.dart';

class RarityChip extends StatelessWidget {
  const RarityChip({super.key, required this.gift});
  final Gift gift;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Color(int.parse(gift.rarity.color.replaceAll('#', '0xFF'))),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        gift.rarity.displayName,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
