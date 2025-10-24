import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/user/user.dart';

class InterestsSection extends StatelessWidget {
  const InterestsSection({super.key, required this.theme, required this.user});
  final ThemeData theme;
  final User user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            S.of(context).myInterests,
            style: theme.textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              user.interests
                  .map(
                    (interest) => Chip(
                      label: Text(interest),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }
}
