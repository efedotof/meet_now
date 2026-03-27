import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';

import 'web_nav_item.dart';

class WebVerticalNavigationBar extends StatelessWidget {
  const WebVerticalNavigationBar({
    super.key,
    required this.tabsRouter,
    required this.unreadCount,
  });
  final TabsRouter tabsRouter;
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    const double iconSize = 24.0;
    const double containerSize = 50.0;
    const double borderRadius = 15.0;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color backgroundColor = isDark ? Colors.white70 : Colors.black87;
    final Color selectedColor = isDark ? Colors.black : Colors.white;

    final bottomNavTheme = Theme.of(context).bottomNavigationBarTheme;
    final Color unselectedColor =
        bottomNavTheme.unselectedItemColor ?? Colors.grey;

    return Container(
      width: 80,
      margin: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          WebNavItem(
            icon: Icons.search,
            label: S.of(context).search,
            isActive: tabsRouter.activeIndex == 0,
            onTap: () => tabsRouter.setActiveIndex(0),
            iconSize: iconSize,
            containerSize: containerSize,
            borderRadius: borderRadius,
            customSelectedColor: selectedColor,
            customUnselectedColor: unselectedColor,
            customBackgroundColor: backgroundColor,
          ),
          const SizedBox(height: 16),
          WebNavItem(
            icon: Icons.message,
            label: S.of(context).chat,
            isActive: tabsRouter.activeIndex == 1,
            onTap: () => tabsRouter.setActiveIndex(1),
            iconSize: iconSize,
            containerSize: containerSize,
            borderRadius: borderRadius,
            customSelectedColor: selectedColor,
            customUnselectedColor: unselectedColor,
            customBackgroundColor: backgroundColor,
            unreadCount: unreadCount,
          ),
          const SizedBox(height: 16),
          WebNavItem(
            icon: Icons.gamepad,
            label: S.of(context).game,
            isActive: tabsRouter.activeIndex == 2,
            onTap: () => tabsRouter.setActiveIndex(2),
            iconSize: iconSize,
            containerSize: containerSize,
            borderRadius: borderRadius,
            customSelectedColor: selectedColor,
            customUnselectedColor: unselectedColor,
            customBackgroundColor: backgroundColor,
          ),
          const SizedBox(height: 16),
          WebNavItem(
            icon: Icons.settings,
            label: S.of(context).settings,
            isActive: tabsRouter.activeIndex == 3,
            onTap: () => tabsRouter.setActiveIndex(3),
            iconSize: iconSize,
            containerSize: containerSize,
            borderRadius: borderRadius,
            customSelectedColor: selectedColor,
            customUnselectedColor: unselectedColor,
            customBackgroundColor: backgroundColor,
          ),
        ],
      ),
    );
  }
}
