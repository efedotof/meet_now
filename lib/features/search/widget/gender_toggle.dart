import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/search/cubit/search_cubit.dart';

class GenderToggle extends StatefulWidget {
  const GenderToggle({super.key});

  @override
  State<GenderToggle> createState() => _GenderToggleState();
}

class _GenderToggleState extends State<GenderToggle> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<SearchCubit>().state;
    final cubit = context.read<SearchCubit>();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outline.withAlpha(30), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children:
            cubit.genders.map((gender) {
              final isSelected = state.gender == gender;
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isSelected ? colors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow:
                        isSelected
                            ? [
                              BoxShadow(
                                color: colors.primary.withAlpha(30),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ]
                            : null,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => cubit.selectGender(gender),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 300),
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color:
                                  isSelected
                                      ? colors.onPrimary
                                      : colors.onSurface.withAlpha(80),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                            child: Text(gender),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
