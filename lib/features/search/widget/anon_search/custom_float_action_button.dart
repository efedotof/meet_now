import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/search/cubit/search/search_cubit.dart';
import 'pulse_animation.dart';

class CustomFloatActionButton extends StatefulWidget {
  const CustomFloatActionButton({super.key});

  @override
  State<CustomFloatActionButton> createState() =>
      _CustomFloatActionButtonState();
}

class _CustomFloatActionButtonState extends State<CustomFloatActionButton> {
  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        final cubit = context.read<SearchCubit>();
        final canSearch = state.gender.isNotEmpty && state.ageFrom != null;
        final colors = Theme.of(context).colorScheme;

        return PulseAnimation(
          isAnimating: state.isSearching,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
            decoration: BoxDecoration(
              color: canSearch ? colors.primary : colors.surface,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                if (canSearch)
                  BoxShadow(
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
              ],
            ),
            width: state.isSearching ? 160 : 60,
            height: 60,
            child: Row(
              mainAxisAlignment:
                  state.isSearching
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.center,
              children: [
                if (state.isSearching)
                  Text(
                    _formatTime(state.elapsedSeconds),
                    style: TextStyle(
                      color: colors.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                GestureDetector(
                  onTap:
                      canSearch
                          ? () => cubit.toggleSearch(context: context)
                          : null,
                  child: Icon(
                    state.isSearching ? Icons.close : Icons.search,
                    color:
                        canSearch
                            ? colors.onPrimary
                            : colors.onSurface.withAlpha(40),
                    size: 26,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
