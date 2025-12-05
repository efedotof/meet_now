import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';

class InformationSection extends StatelessWidget {
  const InformationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        S
            .of(context)
            .settings_are_saved_automatically_and_applied_to_new_notifications,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        textAlign: TextAlign.center,
      ),
    );
  }
}
