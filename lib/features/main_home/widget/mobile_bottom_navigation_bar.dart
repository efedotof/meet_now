import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';

class MobileBottomNavigationBar extends StatelessWidget {
  const MobileBottomNavigationBar({super.key, required this.tabsRouter});
  final TabsRouter tabsRouter;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: tabsRouter.activeIndex,
      onTap: tabsRouter.setActiveIndex,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          label: S.of(context).search,
          icon: Icon(Icons.search),
        ),
        BottomNavigationBarItem(
          label: S.of(context).chat,
          icon: Icon(Icons.message),
        ),
        BottomNavigationBarItem(
          label: S.of(context).game,
          icon: Icon(Icons.gamepad),
        ),
        BottomNavigationBarItem(
          label: S.of(context).settings,
          icon: Icon(Icons.settings),
        ),
      ],
    );
  }
}
