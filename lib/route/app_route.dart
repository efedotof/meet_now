import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:meet_now_app/features/features.dart';
import 'package:meet_now_app/features/uploads_avatars/uploads_avatars.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';
part 'app_route.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, path: "/"),
    AutoRoute(page: AuthRoute.page, path: "/auth"),
    AutoRoute(page: SignInRoute.page, path: "/sign_in"),
    AutoRoute(page: SignUpRoute.page, path: "/sign_up"),
    AutoRoute(
      page: MainHomeRoute.page,
      path: "/main_home",
      children: [
        AutoRoute(page: SearchRoute.page, path: "search"),
        AutoRoute(page: ChatRoute.page, path: "chat"),
        AutoRoute(page: GameChatRoute.page, path: "game_chat"),
        AutoRoute(page: SettingsRoute.page, path: "settings"),
      ],
    ),
    AutoRoute(page: ProfileRoute.page, path: "/profile"),
    AutoRoute(page: SecurityRoute.page, path: "/security"),
    AutoRoute(page: ThemeRoute.page, path: "/theme"),
    AutoRoute(page: SettingProfileRoute.page, path: "/setting_profile"),
    AutoRoute(page: LanguageRoute.page, path: "/language"),
    AutoRoute(page: NotificationRoute.page, path: "/notification"),
    AutoRoute(page: ChatMessageRoute.page, path: "/chat_message"),
    AutoRoute(page: AboutAppRoute.page, path: "/about_app"),

    AutoRoute(page: MyReportRoute.page, path: "/my_report"),
    AutoRoute(page: SupportRoute.page, path: "/support"),
    AutoRoute(page: FriendRequestsRoute.page, path: "/friend_requests"),
    AutoRoute(page: PinCodeRoute.page, path: "/pin_code"),
    AutoRoute(page: QrCodeRoute.page, path: "/qr_code"),
    AutoRoute(page: UploadsAvatarsRoute.page, path: "/uploads_avatars"),
    AutoRoute(page: GiftRoute.page, path: "/gift"),
    AutoRoute(page: FriendsRoute.page, path: "/friends"),
    AutoRoute(page: LockedRoute.page, path: "/locked"),
  ];
}
