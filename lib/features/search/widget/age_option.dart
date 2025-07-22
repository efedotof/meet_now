import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/search/cubit/search_cubit.dart';

class AgeOption extends StatelessWidget {
  const AgeOption({super.key, required this.ageStart});

  final int ageStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final state = context.watch<SearchCubit>().state;

    final ageLabel = "$ageStart–${ageStart + 3}";
    final isSelected = state.ageFrom == ageStart;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: GestureDetector(
        onTap: () => context.read<SearchCubit>().selectAge(ageStart),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? theme.elevatedButtonTheme.style?.backgroundColor?.resolve(
                      {},
                    )
                    : theme.cardTheme.color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  isSelected
                      ? Colors.transparent
                      : isDark
                      ? Colors.white24
                      : Colors.black12,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                ageLabel,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color:
                      isSelected
                          ? theme.elevatedButtonTheme.style?.foregroundColor
                              ?.resolve({})
                          : theme.textTheme.bodyMedium?.color,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.check,
                    size: 18,
                    color: theme.elevatedButtonTheme.style?.foregroundColor
                        ?.resolve({}),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
