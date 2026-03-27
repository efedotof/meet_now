import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';

class SoldOutButton extends StatelessWidget {
  const SoldOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          S.of(context).sold_out,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
