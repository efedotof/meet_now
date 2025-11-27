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
      duration: const Duration(milliseconds: 180),
    );

    _scale = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _elevation = Tween<double>(begin: 0.0, end: 6.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
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
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final isSelected = state.ageFrom == widget.ageStart;
    final ageLabel = "${widget.ageStart}–${widget.ageStart + 3}";

    // запуск анимации
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _animate(isSelected),
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.scale(
          scale: _scale.value,
          child: Material(
            color: isSelected ? colors.primary : colors.surface,
            elevation: _elevation.value,
            shadowColor: colors.primary.withOpacity(0.22),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () =>
                  context.read<SearchCubit>().selectAge(widget.ageStart),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? colors.primary
                        : colors.outline.withOpacity(0.5),
                    width: 1.3,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ageLabel,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? colors.onPrimary
                            : colors.onSurface.withOpacity(0.9),
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.check_rounded,
                        size: 18,
                        color: colors.onPrimary,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
