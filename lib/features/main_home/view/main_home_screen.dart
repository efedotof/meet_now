import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/main_home/cubit/main_home_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/route/app_route.dart';

@RoutePage()
class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: [SearchRoute(), ChatRoute(), FriendsRoute(), SettingsRoute()],
      transitionBuilder:
          (context, child, animation) =>
              FadeTransition(opacity: animation, child: child),
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        final bool isWideScreen = MediaQuery.of(context).size.width >= 600;

        return BlocBuilder<MainHomeCubit, MainHomeState>(
          builder: (context, state) {
            return Scaffold(
              body:
                  isWideScreen
                      ? Row(
                        children: [
                          NavigationRail(
                            selectedIndex: tabsRouter.activeIndex,
                            onDestinationSelected: tabsRouter.setActiveIndex,
                            labelType: NavigationRailLabelType.all,
                            destinations:  [
                              NavigationRailDestination(
                                icon: Icon(Icons.search),
                                label: Text(S.of(context).search),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.message),
                                label: Text(S.of(context).chat),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.group),
                                label: Text(S.of(context).friends),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.settings),
                                label: Text(S.of(context).settings),
                              ),
                            ],
                          ),
                          const VerticalDivider(thickness: 1, width: 1),
                          Expanded(child: child),
                        ],
                      )
                      : child,
              bottomNavigationBar:
                  isWideScreen
                      ? null
                      : BottomNavigationBar(
                        currentIndex: tabsRouter.activeIndex,
                        onTap: tabsRouter.setActiveIndex,
                        items:  [
                          BottomNavigationBarItem(
                            label: S.of(context).search,
                            icon: Icon(Icons.search),
                          ),
                          BottomNavigationBarItem(
                            label: S.of(context).chat,
                            icon: Icon(Icons.message),
                          ),
                          BottomNavigationBarItem(
                            label: S.of(context).friends,
                            icon: Icon(Icons.group),
                          ),
                          BottomNavigationBarItem(
                            label: S.of(context).settings,
                            icon: Icon(Icons.settings),
                          ),
                        ],
                      ),
            );
          },
        );
      },
    );
  }
}
