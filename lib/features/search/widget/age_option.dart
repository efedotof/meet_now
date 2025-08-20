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
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<BorderRadius?> _borderAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _colorAnimation = ColorTween(
      begin: Theme.of(context).cardTheme.color,
      end: Theme.of(context).elevatedButtonTheme.style?.backgroundColor?.resolve({}),
    ).animate(_controller);

    _borderAnimation = BorderRadiusTween(
      begin: BorderRadius.circular(8),
      end: BorderRadius.circular(12),
    ).animate(_controller);

    _updateAnimationState();
  }

  void _updateAnimationState() {
    final state = context.read<SearchCubit>().state;
    final isSelected = state.ageFrom == widget.ageStart;

    if (isSelected) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final state = context.watch<SearchCubit>().state;

    final ageLabel = "${widget.ageStart}–${widget.ageStart + 3}";
    final isSelected = state.ageFrom == widget.ageStart;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: GestureDetector(
        onTap: () {
          context.read<SearchCubit>().selectAge(widget.ageStart);
          _updateAnimationState();
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: _colorAnimation.value,
                  borderRadius: _borderAnimation.value,
                  border: Border.all(
                    color: isSelected
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
                        color: isSelected
                            ? theme.elevatedButtonTheme.style?.foregroundColor?.resolve({})
                            : theme.textTheme.bodyMedium?.color,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(width: 8),
                    FadeTransition(
                      opacity: _opacityAnimation,
                      child: Icon(
                        Icons.check,
                        size: 18,
                        color: theme.elevatedButtonTheme.style?.foregroundColor?.resolve({}),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}