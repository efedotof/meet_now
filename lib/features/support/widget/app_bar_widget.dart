import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/support/cubit/support_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({super.key});

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Positioned(
      top: 20,
      left: 4,
      right: 4,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () => context.maybePop(),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: isDark ? Colors.black : Colors.white,
                ),
              ),
            ),
            Container(
              height: 45,
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              child: Text(
                S.of(context).my_question_support,
                style: TextStyle(color: isDark ? Colors.black : Colors.white),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () => context.read<SupportCubit>().getMyQuestions(),
                child: Icon(
                  Icons.refresh,
                  color: isDark ? Colors.black : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
