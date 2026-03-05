import 'package:flutter/material.dart';
import 'package:meet_now_app/features/chat_message/cubit/sync_timer/sync_timer_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';

class TimeOption extends StatelessWidget {
  const TimeOption({
    super.key,
    required this.minutes,
    required this.isDark,
    SyncTimerCubit? timerCubit,
  }) : _timerCubit = timerCubit;
  final int minutes;
  final bool isDark;
  final SyncTimerCubit? _timerCubit;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _timerCubit?.proposeAddTime(minutes);
        Navigator.of(context).pop();
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: isDark ? Colors.black87 : Colors.white70,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withAlpha(10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.access_time,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$minutes ${S.of(context).mines}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            Text(
              S.of(context).mines,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
