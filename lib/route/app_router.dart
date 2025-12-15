import 'package:auto_route/auto_route.dart';
import 'package:meet_now_admin_panel/features/features.dart';
part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page, path: "/"),
    AutoRoute(
      page: MainHomeRoute.page,
      initial: true,
      path: '/main_home',
      children: [
        AutoRoute(page: DashboardRoute.page, initial: true, path: 'dashboard'),
        AutoRoute(page: UsersRoute.page, path: 'user'),
        AutoRoute(
          page: PushNotificationsRoute.page,
          path: 'push_notifications',
        ),
        AutoRoute(page: ModerationRoute.page, path: 'moderation'),
        AutoRoute(page: ContentRoute.page, path: 'content'),
        AutoRoute(page: AnalyticsRoute.page, path: 'analytics'),
        AutoRoute(page: SystemRoute.page, path: 'system'),
      ],
    ),
  ];
}
