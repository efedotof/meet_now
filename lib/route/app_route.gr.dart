// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_route.dart';

/// generated route for
/// [AboutAppScreen]
class AboutAppRoute extends PageRouteInfo<void> {
  const AboutAppRoute({List<PageRouteInfo>? children})
    : super(AboutAppRoute.name, initialChildren: children);

  static const String name = 'AboutAppRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AboutAppScreen();
    },
  );
}

/// generated route for
/// [AuthScreen]
class AuthRoute extends PageRouteInfo<void> {
  const AuthRoute({List<PageRouteInfo>? children})
    : super(AuthRoute.name, initialChildren: children);

  static const String name = 'AuthRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AuthScreen();
    },
  );
}

/// generated route for
/// [ChatMessageScreen]
class ChatMessageRoute extends PageRouteInfo<ChatMessageRouteArgs> {
  ChatMessageRoute({
    required Chat? chatModel,
    required TemporaryChat temporaryChatModel,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         ChatMessageRoute.name,
         args: ChatMessageRouteArgs(
           chatModel: chatModel,
           temporaryChatModel: temporaryChatModel,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'ChatMessageRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatMessageRouteArgs>();
      return ChatMessageScreen(
        chatModel: args.chatModel,
        temporaryChatModel: args.temporaryChatModel,
        key: args.key,
      );
    },
  );
}

class ChatMessageRouteArgs {
  const ChatMessageRouteArgs({
    required this.chatModel,
    required this.temporaryChatModel,
    this.key,
  });

  final Chat? chatModel;

  final TemporaryChat temporaryChatModel;

  final Key? key;

  @override
  String toString() {
    return 'ChatMessageRouteArgs{chatModel: $chatModel, temporaryChatModel: $temporaryChatModel, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChatMessageRouteArgs) return false;
    return chatModel == other.chatModel &&
        temporaryChatModel == other.temporaryChatModel &&
        key == other.key;
  }

  @override
  int get hashCode =>
      chatModel.hashCode ^ temporaryChatModel.hashCode ^ key.hashCode;
}

/// generated route for
/// [ChatScreen]
class ChatRoute extends PageRouteInfo<void> {
  const ChatRoute({List<PageRouteInfo>? children})
    : super(ChatRoute.name, initialChildren: children);

  static const String name = 'ChatRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChatScreen();
    },
  );
}

/// generated route for
/// [FriendRequestsScreen]
class FriendRequestsRoute extends PageRouteInfo<void> {
  const FriendRequestsRoute({List<PageRouteInfo>? children})
    : super(FriendRequestsRoute.name, initialChildren: children);

  static const String name = 'FriendRequestsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FriendRequestsScreen();
    },
  );
}

/// generated route for
/// [FriendsScreen]
class FriendsRoute extends PageRouteInfo<void> {
  const FriendsRoute({List<PageRouteInfo>? children})
    : super(FriendsRoute.name, initialChildren: children);

  static const String name = 'FriendsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FriendsScreen();
    },
  );
}

/// generated route for
/// [GameChatScreen]
class GameChatRoute extends PageRouteInfo<void> {
  const GameChatRoute({List<PageRouteInfo>? children})
    : super(GameChatRoute.name, initialChildren: children);

  static const String name = 'GameChatRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const GameChatScreen();
    },
  );
}

/// generated route for
/// [LanguageScreen]
class LanguageRoute extends PageRouteInfo<void> {
  const LanguageRoute({List<PageRouteInfo>? children})
    : super(LanguageRoute.name, initialChildren: children);

  static const String name = 'LanguageRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LanguageScreen();
    },
  );
}

/// generated route for
/// [MainHomeScreen]
class MainHomeRoute extends PageRouteInfo<void> {
  const MainHomeRoute({List<PageRouteInfo>? children})
    : super(MainHomeRoute.name, initialChildren: children);

  static const String name = 'MainHomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainHomeScreen();
    },
  );
}

/// generated route for
/// [MyReportScreen]
class MyReportRoute extends PageRouteInfo<void> {
  const MyReportRoute({List<PageRouteInfo>? children})
    : super(MyReportRoute.name, initialChildren: children);

  static const String name = 'MyReportRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MyReportScreen();
    },
  );
}

/// generated route for
/// [NotificationScreen]
class NotificationRoute extends PageRouteInfo<void> {
  const NotificationRoute({List<PageRouteInfo>? children})
    : super(NotificationRoute.name, initialChildren: children);

  static const String name = 'NotificationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NotificationScreen();
    },
  );
}

/// generated route for
/// [NotificationSettingScreen]
class NotificationSettingRoute extends PageRouteInfo<void> {
  const NotificationSettingRoute({List<PageRouteInfo>? children})
    : super(NotificationSettingRoute.name, initialChildren: children);

  static const String name = 'NotificationSettingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NotificationSettingScreen();
    },
  );
}

/// generated route for
/// [PinCodeScreen]
class PinCodeRoute extends PageRouteInfo<void> {
  const PinCodeRoute({List<PageRouteInfo>? children})
    : super(PinCodeRoute.name, initialChildren: children);

  static const String name = 'PinCodeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PinCodeScreen();
    },
  );
}

/// generated route for
/// [ProfileScreen]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileScreen();
    },
  );
}

/// generated route for
/// [QrCodeScreen]
class QrCodeRoute extends PageRouteInfo<void> {
  const QrCodeRoute({List<PageRouteInfo>? children})
    : super(QrCodeRoute.name, initialChildren: children);

  static const String name = 'QrCodeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const QrCodeScreen();
    },
  );
}

/// generated route for
/// [SearchScreen]
class SearchRoute extends PageRouteInfo<void> {
  const SearchRoute({List<PageRouteInfo>? children})
    : super(SearchRoute.name, initialChildren: children);

  static const String name = 'SearchRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SearchScreen();
    },
  );
}

/// generated route for
/// [SecurityScreen]
class SecurityRoute extends PageRouteInfo<void> {
  const SecurityRoute({List<PageRouteInfo>? children})
    : super(SecurityRoute.name, initialChildren: children);

  static const String name = 'SecurityRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SecurityScreen();
    },
  );
}

/// generated route for
/// [SettingProfileScreen]
class SettingProfileRoute extends PageRouteInfo<SettingProfileRouteArgs> {
  SettingProfileRoute({
    Key? key,
    required User user,
    List<PageRouteInfo>? children,
  }) : super(
         SettingProfileRoute.name,
         args: SettingProfileRouteArgs(key: key, user: user),
         initialChildren: children,
       );

  static const String name = 'SettingProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SettingProfileRouteArgs>();
      return SettingProfileScreen(key: args.key, user: args.user);
    },
  );
}

class SettingProfileRouteArgs {
  const SettingProfileRouteArgs({this.key, required this.user});

  final Key? key;

  final User user;

  @override
  String toString() {
    return 'SettingProfileRouteArgs{key: $key, user: $user}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SettingProfileRouteArgs) return false;
    return key == other.key && user == other.user;
  }

  @override
  int get hashCode => key.hashCode ^ user.hashCode;
}

/// generated route for
/// [SettingsScreen]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsScreen();
    },
  );
}

/// generated route for
/// [SignInScreen]
class SignInRoute extends PageRouteInfo<void> {
  const SignInRoute({List<PageRouteInfo>? children})
    : super(SignInRoute.name, initialChildren: children);

  static const String name = 'SignInRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SignInScreen();
    },
  );
}

/// generated route for
/// [SignUpScreen]
class SignUpRoute extends PageRouteInfo<void> {
  const SignUpRoute({List<PageRouteInfo>? children})
    : super(SignUpRoute.name, initialChildren: children);

  static const String name = 'SignUpRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SignUpScreen();
    },
  );
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashScreen();
    },
  );
}

/// generated route for
/// [SupportScreen]
class SupportRoute extends PageRouteInfo<void> {
  const SupportRoute({List<PageRouteInfo>? children})
    : super(SupportRoute.name, initialChildren: children);

  static const String name = 'SupportRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SupportScreen();
    },
  );
}

/// generated route for
/// [TemporaryChatScreen]
class TemporaryChatRoute extends PageRouteInfo<void> {
  const TemporaryChatRoute({List<PageRouteInfo>? children})
    : super(TemporaryChatRoute.name, initialChildren: children);

  static const String name = 'TemporaryChatRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TemporaryChatScreen();
    },
  );
}

/// generated route for
/// [ThemeScreen]
class ThemeRoute extends PageRouteInfo<void> {
  const ThemeRoute({List<PageRouteInfo>? children})
    : super(ThemeRoute.name, initialChildren: children);

  static const String name = 'ThemeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ThemeScreen();
    },
  );
}
