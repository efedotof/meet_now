import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:meet_now_app/route/app_route.dart';

@RoutePage()
class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      // list of your tab routes
      // routes used here must be declared as children
      // routes of /dashboard
      routes: const [
        SearchRoute(),
        ChatRoute(),
        FriendsRoute(),
        SettingsRoute(),
      ],
      transitionBuilder:
          (context, child, animation) =>
              FadeTransition(opacity: animation, child: child),
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: (index) {
              tabsRouter.setActiveIndex(index);
            },
            items: [
              BottomNavigationBarItem(
                label: 'Search',
                icon: Icon(Icons.search),
              ),
              BottomNavigationBarItem(label: 'Chat', icon: Icon(Icons.message)),
              BottomNavigationBarItem(label: 'Friend', icon: Icon(Icons.group)),
              BottomNavigationBarItem(
                label: 'Setting',
                icon: Icon(Icons.settings),
              ),
            ],
          ),
        );
      },
    );
  }
}
