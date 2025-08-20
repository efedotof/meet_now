import 'package:flutter/material.dart';
import 'package:meet_now_app/app/app_config.dart';
import 'package:meet_now_app/features/auth/view/sign_in/cubit/sign_in_cubit.dart';
import 'package:meet_now_app/features/auth/view/sign_up/cubit/sign_up_cubit.dart';
import 'package:meet_now_app/features/chat/cubit/chat_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/chat/chat_message_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/command_suggestions/command_suggestions_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/icebreaker/icebreaker_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/user_activity/user_activity_cubit.dart';
import 'package:meet_now_app/features/friends/cubit/friends_cubit.dart';
import 'package:meet_now_app/features/language/cubit/language_cubit.dart';
import 'package:meet_now_app/features/main_home/cubit/main_home_cubit.dart';
import 'package:meet_now_app/features/pin_code/cubit/pin_code_cubit.dart';
import 'package:meet_now_app/features/search/cubit/search_cubit.dart';
import 'package:meet_now_app/features/security/cubit/security_cubit.dart';
import 'package:meet_now_app/features/settings/cubit/settings_cubit.dart';
import 'package:meet_now_app/features/splash/cubit/splash_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/server/repository/auth/auth_interface.dart';
import 'package:meet_now_app/server/repository/friend/friend_interface.dart';
import 'package:meet_now_app/server/repository/games/games_interface.dart';
import 'package:meet_now_app/server/repository/icebreaker/icebreaker_interface.dart';
import 'package:meet_now_app/server/repository/message/message_interface.dart';
import 'package:meet_now_app/server/repository/search/search_interface.dart';
import 'package:meet_now_app/server/repository/socket/socket_service_interface.dart';
import 'package:meet_now_app/server/repository/upload_image/upload_image_interface.dart';
import 'package:meet_now_app/server/repository/user/user_interface.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';
import 'package:meet_now_app/server/service/command_executor/command_executor_service.dart';
import 'package:meet_now_app/storage/language/language_storage_interface.dart';
import 'package:meet_now_app/storage/password/password_storage_interface.dart';
import 'package:meet_now_app/storage/pincode/pincode_storage_interface.dart';
import 'package:meet_now_app/storage/user/user_storage_interface.dart';
import 'package:meet_now_app/theme/repository/theme_interface.dart';
import 'package:meet_now_app/theme/theme_cubit/theme_cubit.dart';

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
              (context) =>
                  SignInCubit(authInterface: context.read<AuthInterface>()),
        ),
        BlocProvider(
          create:
              (context) => SignUpCubit(
                authInterface: context.read<AuthInterface>(),
                uploadImageInterface: context.read<UploadImageInterface>(),
              ),
        ),
        BlocProvider(
          create:
              (context) => SplashCubit(
                authInterface: context.read<AuthInterface>(),
                pincodeStorageInterface:
                    context.read<PincodeStorageInterface>(),
              ),
        ),
        BlocProvider(
          create:
              (context) =>
                  SearchCubit(searchInterface: context.read<SearchInterface>(), userInterface: context.read<UserInterface>()),
        ),
        BlocProvider(
          create:
              (context) => ChatCubit(
                userModelAppInterface: context.read<UserModelAppInterface>(),
                socketServiceInterface: context.read<SocketServiceInterface>(),
              ),
        ),
        BlocProvider(
          create:
              (context) => SettingsCubit(
                userModelAppInterface: context.read<UserModelAppInterface>(),
                passwordStorageInterface:
                    context.read<PasswordStorageInterface>(),
                userStorageInterface: context.read<UserStorageInterface>(),
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
                gamesInterface: context.read<GamesInterface>(),
                friendInterface: context.read<FriendInterface>(),
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
      ],
      child: child,
    );
  }
}
