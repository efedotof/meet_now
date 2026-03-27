import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/search/cubit/search/search_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';

class SearchProgressBar extends StatelessWidget {
  const SearchProgressBar({super.key});

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (!state.isSearching) {
          return const SizedBox.shrink();
        }
        final colors = Theme.of(context).colorScheme;
        return Center(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.black87,
              boxShadow: [
                BoxShadow(
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black87)
                      .withAlpha(20),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${S.of(context).aSearchIsUnderway} ${_formatTime(state.elapsedSeconds)}',
                  style: TextStyle(
                    color: colors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    context.read<SearchCubit>().toggleSearch(context: context);
                  },
                  child: Icon(Icons.close, size: 20, color: Colors.red),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
