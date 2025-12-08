import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.photo_library_outlined, size: 54, color: Colors.grey[350]),
          const SizedBox(height: 14),
          Text(
            S.of(context).there_are_no_photos_yet,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            S.of(context).add_a_photo_so_that_other_users_can_recognize_you,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
        ],
      ),
    );
  }
}
