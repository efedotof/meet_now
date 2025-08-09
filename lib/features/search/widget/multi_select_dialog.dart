import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';

class MultiSelectDialog extends StatefulWidget {
  final String title;
  final List<String> items;
  final List<String> selectedItems;

  const MultiSelectDialog({
    super.key,
    required this.title,
    required this.items,
    required this.selectedItems,
  });

  @override
  State<MultiSelectDialog> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> with TickerProviderStateMixin {
  late List<String> _tempSelected;
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _opacityAnimations;

  @override
  void initState() {
    super.initState();
    _tempSelected = List.from(widget.selectedItems);
    _initAnimations();
  }

  void _initAnimations() {
    _animationControllers = List.generate(
      widget.items.length,
      (index) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300 + (index * 100)),
      ),
    );

    _scaleAnimations = _animationControllers
        .map((controller) => Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: controller, curve: Curves.elasticOut),
            ))
        .toList();

    _opacityAnimations = _animationControllers
        .map((controller) => Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: controller, curve: Curves.easeIn),
            ))
        .toList();

    // Запуск анимаций с задержкой
    Future.delayed(const Duration(milliseconds: 100), () {
      for (final controller in _animationControllers) {
        controller.forward();
      }
    });
  }

  @override
  void dispose() {
    for (final controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(widget.items.length, (index) {
              final item = widget.items[index];
              final isSelected = _tempSelected.contains(item);
              
              return AnimatedBuilder(
                animation: _animationControllers[index],
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _opacityAnimations[index],
                    child: Transform.scale(
                      scale: _scaleAnimations[index].value,
                      child: child,
                    ),
                  );
                },
                child: CheckboxListTile(
                  value: isSelected,
                  title: Text(item),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _tempSelected.add(item);
                      } else {
                        _tempSelected.remove(item);
                      }
                    });
                  },
                ),
              );
            }),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(S.of(context).cancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _tempSelected),
          child: Text(S.of(context).save),
        ),
      ],
    );
  }
}