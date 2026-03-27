import 'package:flutter/material.dart';

class WebNavItem extends StatelessWidget {
  const WebNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.iconSize,
    required this.containerSize,
    required this.borderRadius,
    this.customSelectedColor,
    this.customUnselectedColor,
    this.customBackgroundColor,
    this.unreadCount = 0,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final double iconSize;
  final double containerSize;
  final double borderRadius;
  final Color? customSelectedColor;
  final Color? customUnselectedColor;
  final Color? customBackgroundColor;
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    final bottomNavTheme = Theme.of(context).bottomNavigationBarTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final selectedColor =
        customSelectedColor ??
        bottomNavTheme.selectedItemColor ??
        colorScheme.primary;
    final unselectedColor =
        customUnselectedColor ??
        bottomNavTheme.unselectedItemColor ??
        colorScheme.onSurface.withValues(alpha: 0.6);
    final backgroundColor =
        customBackgroundColor ??
        bottomNavTheme.backgroundColor ??
        Colors.transparent;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: containerSize,
            height: containerSize,
            decoration: BoxDecoration(
              color:
                  isActive
                      ? selectedColor.withValues(alpha: 0.1)
                      : backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border:
                  isActive
                      ? Border.all(
                        color: selectedColor.withValues(alpha: 0.3),
                        width: 1,
                      )
                      : null,
            ),
            child: Badge(
              label: Text('$unreadCount'),
              isLabelVisible: unreadCount > 0,
              child: Icon(
                icon,
                size: iconSize,
                color: isActive ? selectedColor : unselectedColor,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isActive ? selectedColor : unselectedColor,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
