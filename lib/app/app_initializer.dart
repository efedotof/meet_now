import 'package:flutter/material.dart';
import 'package:meet_now_app/app/app_config.dart';
import 'package:meet_now_app/features/auth/view/sign_in/cubit/sign_in_cubit.dart';
import 'package:meet_now_app/features/auth/view/sign_up/cubit/sign_up_cubit.dart';
import 'package:meet_now_app/features/chat/cubit/chat_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/chat/chat_message_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/command_suggestions/command_suggestions_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/icebreaker/icebreaker_cubit.dart';
import 'package:meet_now_app/features/friends/cubit/friends_cubit.dart';
import 'package:meet_now_app/features/main_home/cubit/main_home_cubit.dart';
import 'package:meet_now_app/features/search/cubit/search_cubit.dart';
import 'package:meet_now_app/features/settings/cubit/settings_cubit.dart';
import 'package:meet_now_app/features/splash/cubit/splash_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/server/repository/auth/auth_interface.dart';
import 'package:meet_now_app/server/repository/auth/auth_repository.dart';
import 'package:meet_now_app/server/repository/chat/chat_interface.dart';
import 'package:meet_now_app/server/repository/chat/chat_repository.dart';
import 'package:meet_now_app/server/repository/friend/friend_interface.dart';
import 'package:meet_now_app/server/repository/friend/friend_repository.dart';
import 'package:meet_now_app/server/repository/icebreaker/icebreaker_interface.dart';
import 'package:meet_now_app/server/repository/icebreaker/icebreaker_repository.dart';
import 'package:meet_now_app/server/repository/message/message_interface.dart';
import 'package:meet_now_app/server/repository/message/message_repository.dart';
import 'package:meet_now_app/server/repository/search/search_interface.dart';
import 'package:meet_now_app/server/repository/search/search_repository.dart';
import 'package:meet_now_app/server/repository/socket/socket_service_impl.dart';
import 'package:meet_now_app/server/repository/socket/socket_service_interface.dart';
import 'package:meet_now_app/server/repository/upload_image/upload_image_interface.dart';
import 'package:meet_now_app/server/repository/upload_image/upload_image_repository.dart';
import 'package:meet_now_app/server/repository/user/user_interface.dart';
import 'package:meet_now_app/server/repository/user/user_repository.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_repository.dart';
import 'package:meet_now_app/storage/password/password_storage_interface.dart';
import 'package:meet_now_app/storage/password/password_storage_repository.dart';
import 'package:meet_now_app/storage/user/user_storage_interface.dart';
import 'package:meet_now_app/storage/user/user_storage_repository.dart';
import 'package:meet_now_app/theme/repository/theme_interface.dart';
import 'package:meet_now_app/theme/repository/theme_repository.dart';
import 'package:meet_now_app/theme/theme_cubit/theme_cubit.dart';

class AppInitializer extends StatelessWidget {
  const AppInitializer({super.key, required this.child, required this.config});
  final AppConfig config;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ThemeInterface>(
          create: (context) => ThemeRepository(preferences: config.prefs),
        ),

        RepositoryProvider<UserStorageInterface>(
          create: (context) => UserStorageRepository(preferences: config.prefs),
        ),
        RepositoryProvider<PasswordStorageInterface>(
          create:
              (context) => PasswordStorageRepository(preferences: config.prefs),
        ),
        RepositoryProvider<UserModelAppInterface>(
          create: (context) => UserModelAppRepository(),
        ),
        RepositoryProvider<SearchInterface>(
          create:
              (context) => SearchRepository(
                userModelAppInterface: context.read<UserModelAppInterface>(),
              ),
        ),
        RepositoryProvider<SocketServiceInterface>(
          create:
              (context) => SocketServiceImpl(
                userModelAppInterface: context.read<UserModelAppInterface>(),
              ),
        ),
        RepositoryProvider<ChatInterface>(
          create:
              (context) => ChatRepository(
                userModelAppInterface: context.read<UserModelAppInterface>(),
              ),
        ),
        RepositoryProvider<FriendInterface>(
          create:
              (context) => FriendRepository(
                userModelAppInterface: context.read<UserModelAppInterface>(),
              ),
        ),
        RepositoryProvider<UserInterface>(
          create:
              (context) => UserRepository(
                userModelAppInterface: context.read<UserModelAppInterface>(),
                passwordStorageInterface:
                    context.read<PasswordStorageInterface>(),
                userStorageInterface: context.read<UserStorageInterface>(),
              ),
        ),
        RepositoryProvider<AuthInterface>(
          create:
              (context) => AuthRepository(
                passwordStorageInterface:
                    context.read<PasswordStorageInterface>(),
                userModelAppInterface: context.read<UserModelAppInterface>(),
                userStorageInterface: context.read<UserStorageInterface>(),
              ),
        ),
        RepositoryProvider<UploadImageInterface>(
          create: (context) => UploadImageRepository(),
        ),
        RepositoryProvider<MessageInterface>(
          create:
              (context) => MessageRepository(
                socketService: context.read<SocketServiceInterface>(),
              ),
        ),
        RepositoryProvider<IcebreakerInterface>(
          create:
              (context) => IcebreakerRepository(
                userModelAppInterface: context.read<UserModelAppInterface>(),
              ),
        ),
      ],
      child: MultiBlocProvider(
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
                (context) =>
                    SplashCubit(authInterface: context.read<AuthInterface>()),
          ),
          BlocProvider(
            create:
                (context) => SearchCubit(
                  searchInterface: context.read<SearchInterface>(),
                ),
          ),
          BlocProvider(
            create:
                (context) => ChatCubit(
                  userModelAppInterface: context.read<UserModelAppInterface>(),
                  socketServiceInterface:
                      context.read<SocketServiceInterface>(),
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
                  socketServiceInterface:
                      context.read<SocketServiceInterface>(),
                ),
          ),
          BlocProvider(
            create:
                (context) => CommandSuggestionsCubit(
                  icebreakerInterface: context.read<IcebreakerInterface>(),
                ),
          ),
        ],
        child: child,
      ),
    );
  }
}
