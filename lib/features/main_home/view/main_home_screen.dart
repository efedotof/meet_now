import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:meet_now_admin_panel/route/app_router.dart';

@RoutePage()
class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});



  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        DashboardRoute(),
        AnalyticsRoute(),
        UsersRoute(),
        ContentRoute(),
        ModerationRoute(),
        PushNotificationsRoute(),
        SystemRoute(),
      ],
      transitionBuilder: (context, child, animation) =>
          FadeTransition(opacity: animation, child: child),
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue[100]!, width: 1.5),
                  ),
                  child: Icon(
                    Icons.developer_mode,
                    size: 18,
                    color: Colors.blue[700],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Developer Portal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      'Meet Now Admin System',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            backgroundColor: Colors.white,
            elevation: 1,
            shadowColor: Colors.black12,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.blue[100],
                  child: Icon(Icons.person, size: 18, color: Colors.blue[700]),
                ),
              ),
            ],
          ),
          body: child,
          bottomNavigationBar: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(5),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: NavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              indicatorColor: Colors.blue[50],
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              surfaceTintColor: Colors.transparent,
              selectedIndex: tabsRouter.activeIndex,
              onDestinationSelected: (index) {
                tabsRouter.setActiveIndex(index);
              },
              destinations: [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined, color: Colors.grey[600]),
                  selectedIcon: Icon(Icons.dashboard, color: Colors.blue[700]),
                  label: 'Dashboard',
                ),
                NavigationDestination(
                  icon: Icon(Icons.analytics_outlined, color: Colors.grey[600]),
                  selectedIcon: Icon(Icons.analytics, color: Colors.blue[700]),
                  label: 'Analytics',
                ),
                NavigationDestination(
                  icon: Icon(Icons.people_outline, color: Colors.grey[600]),
                  selectedIcon: Icon(Icons.people, color: Colors.blue[700]),
                  label: 'Users',
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.content_copy_outlined,
                    color: Colors.grey[600],
                  ),
                  selectedIcon: Icon(
                    Icons.content_copy,
                    color: Colors.blue[700],
                  ),
                  label: 'Content',
                ),
                NavigationDestination(
                  icon: Icon(Icons.shield_outlined, color: Colors.grey[600]),
                  selectedIcon: Icon(Icons.shield, color: Colors.blue[700]),
                  label: 'Moderation',
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.notifications_outlined,
                    color: Colors.grey[600],
                  ),
                  selectedIcon: Icon(
                    Icons.notifications,
                    color: Colors.blue[700],
                  ),
                  label: 'Notifications',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined, color: Colors.grey[600]),
                  selectedIcon: Icon(Icons.settings, color: Colors.blue[700]),
                  label: 'System',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
