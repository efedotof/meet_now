import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';

class LoadingPlaceholder extends StatelessWidget {
  const LoadingPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.surfaceContainerHighest,
            Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(7),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            S.of(context).loading,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
