import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';

class MobileBottomNavigationBar extends StatelessWidget {
  const MobileBottomNavigationBar({
    super.key,
    required this.tabsRouter,
    required this.unreadCount,
  });
  final TabsRouter tabsRouter;
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: tabsRouter.activeIndex,
      onTap: tabsRouter.setActiveIndex,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          label: S.of(context).search,
          icon: const Icon(Icons.search),
        ),
        BottomNavigationBarItem(
          label: S.of(context).chat,
          icon: Badge(
            label: Text('$unreadCount'),
            isLabelVisible: unreadCount > 0,
            child: const Icon(Icons.message),
          ),
        ),
        BottomNavigationBarItem(
          label: S.of(context).game,
          icon: const Icon(Icons.gamepad),
        ),
        BottomNavigationBarItem(
          label: S.of(context).settings,
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }
}
