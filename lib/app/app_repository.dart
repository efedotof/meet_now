import 'package:flutter/material.dart';
import 'package:meet_now_app/app/app_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/server/repository/auth/auth_interface.dart';
import 'package:meet_now_app/server/repository/auth/auth_repository.dart';
import 'package:meet_now_app/server/repository/chat/chat_interface.dart';
import 'package:meet_now_app/server/repository/chat/chat_repository.dart';
import 'package:meet_now_app/server/repository/city/city_interface.dart';
import 'package:meet_now_app/server/repository/city/city_repository.dart';
import 'package:meet_now_app/server/repository/friend/friend_interface.dart';
import 'package:meet_now_app/server/repository/friend/friend_repository.dart';
import 'package:meet_now_app/server/repository/games/games_interface.dart';
import 'package:meet_now_app/server/repository/games/games_repository.dart';
import 'package:meet_now_app/server/repository/icebreaker/icebreaker_interface.dart';
import 'package:meet_now_app/server/repository/icebreaker/icebreaker_repository.dart';
import 'package:meet_now_app/server/repository/message/message_interface.dart';
import 'package:meet_now_app/server/repository/message/message_repository.dart';
import 'package:meet_now_app/server/repository/purp_and_int/purp_and_interes_interface.dart';
import 'package:meet_now_app/server/repository/purp_and_int/purp_and_interes_repository.dart';
import 'package:meet_now_app/server/repository/report/report_interface.dart';
import 'package:meet_now_app/server/repository/report/report_repository.dart';
import 'package:meet_now_app/server/repository/search/search_interface.dart';
import 'package:meet_now_app/server/repository/search/search_repository.dart';
import 'package:meet_now_app/server/repository/socket/socket_service_impl.dart';
import 'package:meet_now_app/server/repository/socket/socket_service_interface.dart';
import 'package:meet_now_app/server/repository/stikers_parks/stikers_parks_interface.dart';
import 'package:meet_now_app/server/repository/stikers_parks/stikers_parks_repository.dart';
import 'package:meet_now_app/server/repository/timer/timer_repository.dart';
import 'package:meet_now_app/server/repository/timer/timer_repository_interface.dart';
import 'package:meet_now_app/server/repository/upload_image/upload_image_interface.dart';
import 'package:meet_now_app/server/repository/upload_image/upload_image_repository.dart';
import 'package:meet_now_app/server/repository/user/user_interface.dart';
import 'package:meet_now_app/server/repository/user/user_repository.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_repository.dart';
import 'package:meet_now_app/server/service/command_executor/command_executor_service.dart';
import 'package:meet_now_app/storage/first_open_app/first_open_app_interface.dart';
import 'package:meet_now_app/storage/first_open_app/first_open_app_repository.dart';
import 'package:meet_now_app/storage/hive/repository/storage_hive_interface.dart';
import 'package:meet_now_app/storage/hive/repository/storage_hive_repository.dart';
import 'package:meet_now_app/storage/language/language_storage_interface.dart';
import 'package:meet_now_app/storage/language/language_storage_repository.dart';
import 'package:meet_now_app/storage/password/password_storage_interface.dart';
import 'package:meet_now_app/storage/password/password_storage_repository.dart';
import 'package:meet_now_app/storage/pincode/pincode_storage_interface.dart';
import 'package:meet_now_app/storage/pincode/pinconde_storage_repository.dart';
import 'package:meet_now_app/storage/user/user_storage_interface.dart';
import 'package:meet_now_app/storage/user/user_storage_repository.dart';
import 'package:meet_now_app/theme/repository/theme_interface.dart';
import 'package:meet_now_app/theme/repository/theme_repository.dart';

class AppRepository extends StatelessWidget {
  const AppRepository({
    super.key,
    required this.child,
    required this.config,
    required this.storageHive,
  });

  final Widget child;
  final AppConfig config;
  final StorageHiveRepository storageHive;

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
          create:
              (context) => UploadImageRepository(
                userModelAppInterface: context.read<UserModelAppInterface>(),
              ),
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
        RepositoryProvider(
          create:
              (context) => CommandExecutorService(
                icebreakerInterface: context.read<IcebreakerInterface>(),
              ),
        ),
        RepositoryProvider<PincodeStorageInterface>(
          create:
              (context) => PincondeStorageRepository(preferences: config.prefs),
        ),
        RepositoryProvider<LanguageStorageInterface>(
          create:
              (context) => LanguageStorageRepository(preferences: config.prefs),
        ),
        RepositoryProvider<GamesInterface>(
          create:
              (context) => GamesRepository(
                userModelAppInterface: context.read<UserModelAppInterface>(),
              ),
        ),
        RepositoryProvider<StorageHiveInterface>.value(value: storageHive),
        RepositoryProvider<PurpAndInteresInterface>(
          create:
              (context) => PurpAndInteresRepository(
                storageHiveInterface: context.read<StorageHiveInterface>(),
              ),
        ),
        RepositoryProvider<FirstOpenAppInterface>(
          create:
              (context) => FirstOpenAppRepository(preferences: config.prefs),
        ),
        RepositoryProvider<ReportInterface>(
          create:
              (context) => ReportRepository(
                userModelAppInterface: context.read<UserModelAppInterface>(),
              ),
        ),
        RepositoryProvider<StikersParksInterface>(
          create:
              (context) => StikersParksRepository(
                userModelAppInterface: context.read<UserModelAppInterface>(),
              ),
        ),
        RepositoryProvider<CityInterface>(
          create: (context) => CityRepository(),
        ),

        RepositoryProvider<TimerRepositoryInterface>(
          create: (context) => TimerRepository(),
        ),
      ],
      child: child,
    );
  }
}
