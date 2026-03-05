import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/search/cubit/search_cubit.dart';

class AgeOption extends StatefulWidget {
  const AgeOption({super.key, required this.ageStart});

  final int ageStart;

  @override
  State<AgeOption> createState() => _AgeOptionState();
}

class _AgeOptionState extends State<AgeOption>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _elevation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _scale = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _elevation = Tween<double>(
      begin: 0.0,
      end: 3.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  void _animate(bool select) {
    if (select) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SearchCubit>().state;
    final cubit = context.read<SearchCubit>();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final isSelected = state.ageFrom == widget.ageStart;

    final ageLabel = cubit.getAgeLabel(widget.ageStart);

    WidgetsBinding.instance.addPostFrameCallback((_) => _animate(isSelected));

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.scale(
          scale: _scale.value,
          child: SizedBox(
            width: 72,
            child: Material(
              color: isSelected ? colors.primary : colors.surface,
              elevation: _elevation.value,
              shadowColor: colors.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap:
                    () =>
                        context.read<SearchCubit>().selectAge(widget.ageStart),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color:
                          isSelected
                              ? colors.primary
                              : colors.outline.withAlpha(25),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ageLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color:
                              isSelected
                                  ? colors.onPrimary
                                  : colors.onSurface.withAlpha(110),
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: colors.onPrimary,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
