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
    Key? key,
    required TemporaryChat? temporaryChatModel,
    PermanentChatResponseDto? chatModel,
    VoidCallback? onClose,
    bool isEmbedded = false,
    required String chatKey,
    List<PageRouteInfo>? children,
  }) : super(
         ChatMessageRoute.name,
         args: ChatMessageRouteArgs(
           key: key,
           temporaryChatModel: temporaryChatModel,
           chatModel: chatModel,
           onClose: onClose,
           isEmbedded: isEmbedded,
           chatKey: chatKey,
         ),
         initialChildren: children,
       );

  static const String name = 'ChatMessageRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatMessageRouteArgs>();
      return ChatMessageScreen(
        key: args.key,
        temporaryChatModel: args.temporaryChatModel,
        chatModel: args.chatModel,
        onClose: args.onClose,
        isEmbedded: args.isEmbedded,
        chatKey: args.chatKey,
      );
    },
  );
}

class ChatMessageRouteArgs {
  const ChatMessageRouteArgs({
    this.key,
    required this.temporaryChatModel,
    this.chatModel,
    this.onClose,
    this.isEmbedded = false,
    required this.chatKey,
  });

  final Key? key;

  final TemporaryChat? temporaryChatModel;

  final PermanentChatResponseDto? chatModel;

  final VoidCallback? onClose;

  final bool isEmbedded;

  final String chatKey;

  @override
  String toString() {
    return 'ChatMessageRouteArgs{key: $key, temporaryChatModel: $temporaryChatModel, chatModel: $chatModel, onClose: $onClose, isEmbedded: $isEmbedded, chatKey: $chatKey}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChatMessageRouteArgs) return false;
    return key == other.key &&
        temporaryChatModel == other.temporaryChatModel &&
        chatModel == other.chatModel &&
        onClose == other.onClose &&
        isEmbedded == other.isEmbedded &&
        chatKey == other.chatKey;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      temporaryChatModel.hashCode ^
      chatModel.hashCode ^
      onClose.hashCode ^
      isEmbedded.hashCode ^
      chatKey.hashCode;
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
class GameChatRoute extends PageRouteInfo<GameChatRouteArgs> {
  GameChatRoute({Key? key, String? chatId, List<PageRouteInfo>? children})
    : super(
        GameChatRoute.name,
        args: GameChatRouteArgs(key: key, chatId: chatId),
        initialChildren: children,
      );

  static const String name = 'GameChatRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GameChatRouteArgs>(
        orElse: () => const GameChatRouteArgs(),
      );
      return GameChatScreen(key: args.key, chatId: args.chatId);
    },
  );
}

class GameChatRouteArgs {
  const GameChatRouteArgs({this.key, this.chatId});

  final Key? key;

  final String? chatId;

  @override
  String toString() {
    return 'GameChatRouteArgs{key: $key, chatId: $chatId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GameChatRouteArgs) return false;
    return key == other.key && chatId == other.chatId;
  }

  @override
  int get hashCode => key.hashCode ^ chatId.hashCode;
}

/// generated route for
/// [GiftScreen]
class GiftRoute extends PageRouteInfo<void> {
  const GiftRoute({List<PageRouteInfo>? children})
    : super(GiftRoute.name, initialChildren: children);

  static const String name = 'GiftRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const GiftScreen();
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
/// [LockedScreen]
class LockedRoute extends PageRouteInfo<LockedRouteArgs> {
  LockedRoute({
    Key? key,
    required String blockReason,
    List<PageRouteInfo>? children,
  }) : super(
         LockedRoute.name,
         args: LockedRouteArgs(key: key, blockReason: blockReason),
         initialChildren: children,
       );

  static const String name = 'LockedRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LockedRouteArgs>();
      return LockedScreen(key: args.key, blockReason: args.blockReason);
    },
  );
}

class LockedRouteArgs {
  const LockedRouteArgs({this.key, required this.blockReason});

  final Key? key;

  final String blockReason;

  @override
  String toString() {
    return 'LockedRouteArgs{key: $key, blockReason: $blockReason}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LockedRouteArgs) return false;
    return key == other.key && blockReason == other.blockReason;
  }

  @override
  int get hashCode => key.hashCode ^ blockReason.hashCode;
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
class ProfileRoute extends PageRouteInfo<ProfileRouteArgs> {
  ProfileRoute({
    Key? key,
    FriendRequest? friendRequest,
    User? otherUser,
    List<PageRouteInfo>? children,
  }) : super(
         ProfileRoute.name,
         args: ProfileRouteArgs(
           key: key,
           friendRequest: friendRequest,
           otherUser: otherUser,
         ),
         initialChildren: children,
       );

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProfileRouteArgs>(
        orElse: () => const ProfileRouteArgs(),
      );
      return ProfileScreen(
        key: args.key,
        friendRequest: args.friendRequest,
        otherUser: args.otherUser,
      );
    },
  );
}

class ProfileRouteArgs {
  const ProfileRouteArgs({this.key, this.friendRequest, this.otherUser});

  final Key? key;

  final FriendRequest? friendRequest;

  final User? otherUser;

  @override
  String toString() {
    return 'ProfileRouteArgs{key: $key, friendRequest: $friendRequest, otherUser: $otherUser}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProfileRouteArgs) return false;
    return key == other.key &&
        friendRequest == other.friendRequest &&
        otherUser == other.otherUser;
  }

  @override
  int get hashCode =>
      key.hashCode ^ friendRequest.hashCode ^ otherUser.hashCode;
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

/// generated route for
/// [UploadsAvatarsScreen]
class UploadsAvatarsRoute extends PageRouteInfo<UploadsAvatarsRouteArgs> {
  UploadsAvatarsRoute({
    Key? key,
    bool? isSkip,
    int? currentPhotosCount,
    List<PageRouteInfo>? children,
  }) : super(
         UploadsAvatarsRoute.name,
         args: UploadsAvatarsRouteArgs(
           key: key,
           isSkip: isSkip,
           currentPhotosCount: currentPhotosCount,
         ),
         initialChildren: children,
       );

  static const String name = 'UploadsAvatarsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UploadsAvatarsRouteArgs>(
        orElse: () => const UploadsAvatarsRouteArgs(),
      );
      return UploadsAvatarsScreen(
        key: args.key,
        isSkip: args.isSkip,
        currentPhotosCount: args.currentPhotosCount,
      );
    },
  );
}

class UploadsAvatarsRouteArgs {
  const UploadsAvatarsRouteArgs({
    this.key,
    this.isSkip,
    this.currentPhotosCount,
  });

  final Key? key;

  final bool? isSkip;

  final int? currentPhotosCount;

  @override
  String toString() {
    return 'UploadsAvatarsRouteArgs{key: $key, isSkip: $isSkip, currentPhotosCount: $currentPhotosCount}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UploadsAvatarsRouteArgs) return false;
    return key == other.key &&
        isSkip == other.isSkip &&
        currentPhotosCount == other.currentPhotosCount;
  }

  @override
  int get hashCode =>
      key.hashCode ^ isSkip.hashCode ^ currentPhotosCount.hashCode;
}
