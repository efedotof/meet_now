import 'package:flutter/material.dart';
import 'package:meet_now_app/app/app_config.dart';
import 'package:meet_now_app/features/auth/view/sign_in/cubit/sign_in_cubit.dart';
import 'package:meet_now_app/features/auth/view/sign_up/cubit/sign_up_cubit.dart';
import 'package:meet_now_app/features/chat/cubit/chat_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/chat/chat_message_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/command_suggestions/command_suggestions_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/icebreaker/icebreaker_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/media_selection/media_selection_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/sticker/sticker_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/user_activity/user_activity_cubit.dart';
import 'package:meet_now_app/features/document/cubit/document_cubit.dart';
import 'package:meet_now_app/features/friend_requests/cubit/friend_cubit.dart';
import 'package:meet_now_app/features/friends/cubit/friends_cubit.dart';
import 'package:meet_now_app/features/game_chat/cubit/game_chat_cubit.dart';
import 'package:meet_now_app/features/game_chat/cubit/game_points_cubit.dart';
import 'package:meet_now_app/features/gift/cubit/gift_cubit.dart';
import 'package:meet_now_app/features/language/cubit/language_cubit.dart';
import 'package:meet_now_app/features/main_home/cubit/main_home/main_home_cubit.dart';
import 'package:meet_now_app/features/main_home/cubit/unread_count/unread_count_cubit.dart';
import 'package:meet_now_app/features/my_report/cubit/report_cubit.dart';
import 'package:meet_now_app/features/notification/cubit/notification_cubit.dart';
import 'package:meet_now_app/features/pin_code/cubit/pin_code_cubit.dart';
import 'package:meet_now_app/features/search/cubit/card_swiper/card_swiper_cubit.dart';
import 'package:meet_now_app/features/search/cubit/search/search_cubit.dart';
import 'package:meet_now_app/features/search/cubit/search_mode/search_mode_cubit.dart';
import 'package:meet_now_app/features/search/cubit/user_stats/user_stats_cubit.dart';
import 'package:meet_now_app/features/security/cubit/security_cubit.dart';
import 'package:meet_now_app/features/setting_profile/cubit/setting_profile_cubit.dart';
import 'package:meet_now_app/features/settings/cubit/settings_cubit.dart';
import 'package:meet_now_app/features/settings/cubit/user_date_cubit.dart';
import 'package:meet_now_app/features/splash/cubit/splash_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/support/cubit/support_cubit.dart';
import 'package:meet_now_app/features/theme/cubit/particles_cubit.dart';
import 'package:meet_now_app/features/uploads_avatars/cubit/uploads_avatars_cubit.dart';
import 'package:meet_now_app/theme/theme_cubit/theme_cubit.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';
import 'package:meet_now_app_server/repository/document/document_interface.dart';
import 'package:meet_now_app_server/repository/keys_api/keys_api_interface.dart';
import 'package:meet_now_app_server/repository/swipe/swipe_interface.dart';
import 'package:meet_now_app_server/storage/card_swiper/card_swiper_interface.dart';
import 'package:meet_now_app_server/storage/notification/notification_settings_interface.dart';
import 'package:meet_now_app_server/storage/particles/particles_interface.dart';
import 'package:meet_now_app_server/storage/rsa_keys/rsa_keys_interface.dart';

class AppBloc extends StatelessWidget {
  const AppBloc({super.key, required this.config, required this.child});

  final AppConfig config;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  ThemeCubit(themeInterface: context.read<ThemeInterface>()),
        ),
        BlocProvider(
          create:
              (context) => NotificationCubit(
                notificationSettingsRepository:
                    context.read<NotificationSettingsInterface>(),
              ),
        ),

        BlocProvider(
          create:
              (context) => SearchModeCubit(
                cardSwiperInterface: context.read<CardSwiperInterface>(),
                userInterface: context.read<UserInterface>(),
              ),
        ),

        BlocProvider(
          create:
              (context) => DocumentCubit(
                documentInterface: context.read<DocumentInterface>(),
              ),
        ),

        BlocProvider(
          create:
              (context) => SignInCubit(
                authInterface: context.read<AuthInterface>(),
                rsaKeys: context.read<RsaKeysInterface>(),
                keysApi: context.read<KeysApiInterface>(),
              ),
        ),
        BlocProvider(
          create:
              (context) => ParticlesCubit(
                particlesRepository: context.read<ParticlesInterface>(),
              ),
        ),
        BlocProvider(
          create:
              (context) => SignUpCubit(
                authInterface: context.read<AuthInterface>(),
                uploadImageInterface: context.read<UploadImageInterface>(),
                cityInterface: context.read<CityInterface>(),
                rsaKeys: context.read<RsaKeysInterface>(),
                keysApi: context.read<KeysApiInterface>(),
              ),
        ),
        BlocProvider(
          create:
              (context) => SplashCubit(
                authInterface: context.read<AuthInterface>(),
                pincodeStorageInterface:
                    context.read<PincodeStorageInterface>(),
                purpAndInteresInterface:
                    context.read<PurpAndInteresInterface>(),
                firstOpenAppInterface: context.read<FirstOpenAppInterface>(),
              ),
        ),
        BlocProvider(
          create:
              (context) => SearchCubit(
                searchInterface: context.read<SearchInterface>(),
                userInterface: context.read<UserInterface>(),
                cityInterface: context.read<CityInterface>(),
              ),
        ),
        BlocProvider(
          create:
              (context) => ChatCubit(
                userModelAppInterface: context.read<UserModelAppInterface>(),
                socketServiceInterface: context.read<SocketServiceInterface>(),
                chatInterface: context.read<ChatInterface>(),
              ),
        ),
        BlocProvider(
          create:
              (context) => SettingsCubit(
                userModelAppInterface: context.read<UserModelAppInterface>(),
                passwordStorageInterface:
                    context.read<PasswordStorageInterface>(),
                userStorageInterface: context.read<UserStorageInterface>(),
                userInterface: context.read<UserInterface>(),
                fcmServiceInterface: context.read<FCMServiceInterface>(),
                cardSwiperInterface: context.read<CardSwiperInterface>(),
              ),
        ),
        BlocProvider(
          create:
              (context) => FriendsCubit(
                friendInterface: context.read<FriendInterface>(),
              ),
        ),
        BlocProvider(
          create:
              (context) => ChatMessageCubit(
                messageInterface: context.read<MessageInterface>(),
                friendInterface: context.read<FriendInterface>(),
                uploadImageInterface: context.read<UploadImageInterface>(),
                socketInterface: context.read<SocketServiceInterface>(),
                chatInterface: context.read<ChatInterface>(),
                userInterface: context.read<UserInterface>(),
              ),
        ),
        BlocProvider(
          create:
              (context) => IcebreakerCubit(
                icebreakerInterface: context.read<IcebreakerInterface>(),
              ),
        ),
        BlocProvider(
          create:
              (context) => MainHomeCubit(
                socketServiceInterface: context.read<SocketServiceInterface>(),
                storageHiveInterface: context.read<StorageHiveInterface>(),
                userInterface: context.read<UserInterface>(),
              ),
        ),
        BlocProvider(
          create:
              (context) => UnreadCountCubit(
                socketService: context.read<SocketServiceInterface>(),
              ),
        ),
        BlocProvider(
          create:
              (context) => CommandSuggestionsCubit(
                commandExecutorService: context.read<CommandExecutorService>(),
              ),
        ),
        BlocProvider(
          create:
              (context) => UserActivityCubit(
                socketService: context.read<SocketServiceInterface>(),
                userModelApp: context.read<UserModelAppInterface>(),
              ),
        ),
        BlocProvider(
          create:
              (context) => PinCodeCubit(
                pincodeStorageInterface:
                    context.read<PincodeStorageInterface>(),
                authInterface: context.read<AuthInterface>(),
              ),
        ),
        BlocProvider(
          create:
              (context) => SecurityCubit(
                pincodeStorageInterface:
                    context.read<PincodeStorageInterface>(),
              ),
        ),
        BlocProvider(
          create:
              (context) => LanguageCubit(
                languageStorageInterface:
                    context.read<LanguageStorageInterface>(),
              ),
        ),
        BlocProvider(
          create:
              (context) =>
                  FriendCubit(friendInterface: context.read<FriendInterface>()),
        ),
        BlocProvider(
          create:
              (context) => SettingProfileCubit(
                userInterface: context.read<UserInterface>(),
                uploadImageInterface: context.read<UploadImageInterface>(),
              ),
        ),
        BlocProvider(
          create:
              (context) => UploadsAvatarsCubit(
                uploadImageInterface: context.read<UploadImageInterface>(),
              ),
        ),
        BlocProvider(
          create:
              (context) =>
                  ReportCubit(reportInterface: context.read<ReportInterface>()),
        ),
        BlocProvider(
          create:
              (context) => StickerCubit(
                stickerParksInterface: context.read<StikersParksInterface>(),
                giftInterface: context.read<GiftInterface>(),
                // messageInterface: context.read<MessageInterface>(),
              ),
        ),
        BlocProvider(
          create:
              (context) => GameChatCubit(
                gamesRepository: context.read<GamesInterface>(),
                tokenInterface: context.read<TokenInterface>(),
                userInterface: context.read<UserInterface>(),
                uploadImageInterface: context.read<UploadImageInterface>(),
              ),
        ),
        BlocProvider(create: (context) => MediaSelectionCubit()),
        BlocProvider(
          create:
              (context) =>
                  GiftCubit(giftInterface: context.read<GiftInterface>()),
        ),
        BlocProvider(
          create:
              (context) => UserStatsCubit(
                socketServiceInterface: context.read<SocketServiceInterface>(),
                userStatsInterface: context.read<UserStatsInterface>(),
              ),
        ),
        BlocProvider(
          create:
              (context) => SupportCubit(
                supportInterface: context.read<SupportInterface>(),
              ),
        ),

        BlocProvider(
          create:
              (context) => GamePointsCubit(
                userModelAppInterface: context.read<UserModelAppInterface>(),
                userInterface: context.read<UserInterface>(),
              ),
        ),
        BlocProvider(
          create:
              (context) => UserDateCubit(
                userModelAppInterface: context.read<UserModelAppInterface>(),
                userInterface: context.read<UserInterface>(),
              ),
        ),
        BlocProvider(
          create:
              (context) =>
                  CardSwiperCubit(interface: context.read<SwipeInterface>()),
        ),
      ],
      child: child,
    );
  }
}
