import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/search/cubit/matchmaking/matchmaking_cubit.dart';

class QuickMatchButton extends StatelessWidget {
  const QuickMatchButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return FloatingActionButton(
      heroTag: 'quick_match',
      onPressed: () {
        context.read<MatchmakingCubit>().quickSearch();
      },
      backgroundColor: colors.primary,
      child: Icon(Icons.flash_on, color: colors.onPrimary),
    );
  }
}
