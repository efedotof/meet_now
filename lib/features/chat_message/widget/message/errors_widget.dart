import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';

class ErrorsWidget extends StatelessWidget {
  const ErrorsWidget({super.key, this.onRetry});
  final VoidCallback? onRetry;
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
            Theme.of(context).colorScheme.errorContainer,
            Theme.of(context).colorScheme.errorContainer.withAlpha(7),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_rounded,
            size: 48,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
          const SizedBox(height: 8),
          Text(
            S.of(context).download_error,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onErrorContainer,
              fontSize: 12,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 8),
            TextButton(onPressed: onRetry, child: Text(S.of(context).retry)),
          ],
        ],
      ),
    );
  }
}
