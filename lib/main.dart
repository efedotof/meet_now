import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:meet_now_app/app/app_config.dart';
import 'package:meet_now_app/app/app_initializer.dart';
import 'package:meet_now_app/features/language/cubit/language_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/theme/theme_cubit/theme_cubit.dart';
import 'package:meet_now_app_server/repository/push_notification/fcm_service_impl.dart';
import 'package:meet_now_app_server/service/logging/logger_service.dart';
import 'package:meet_now_app_server/storage/first_open_app/repository/storage_hive_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/theme.dart';
import "package:hive_ce/hive.dart";
import 'package:path_provider/path_provider.dart';
import 'package:meet_now_app_server/hive_registrar.g.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FCMServiceImpl.firebaseMessagingBackgroundHandler(message);
}

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      final LoggerService logger = LoggerService();
      await logger.init();

      if (!kIsWeb) {
        try {
          await SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
        } catch (e) {
          logger.error("Orientation error: $e");
        }
      }

      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        FirebaseMessaging.onBackgroundMessage(
          firebaseMessagingBackgroundHandler,
        );
      } catch (e) {
        logger.error("Firebase initialization error: $e");
      }

      StorageHiveRepository? storageHive;

      if (!kIsWeb) {
        try {
          final directory = await getApplicationDocumentsDirectory();
          Hive
            ..init(directory.path)
            ..registerAdapters();

          storageHive = StorageHiveRepository();
          await storageHive.init();
        } catch (e) {
          logger.error("Hive initialization error: $e");
          storageHive = null;
        }
      }

      final appConfig = AppConfig(prefs: await SharedPreferences.getInstance());

      runApp(
        AppInitializer(
          config: appConfig,
          storageHive: storageHive,
          child: const MeetNowApp(),
        ),
      );
    },
    (error, stackTrace) {
      debugPrint('Uncaught error: $error\n$stackTrace');
    },
  );
}

class MeetNowApp extends StatefulWidget {
  const MeetNowApp({super.key});

  @override
  State<MeetNowApp> createState() => _MeetNowAppState();
}

class _MeetNowAppState extends State<MeetNowApp> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp.router(
          locale: Locale(context.watch<LanguageCubit>().checkLocale()),
          debugShowCheckedModeBanner: false,
          routerConfig: _appRouter.config(),
          supportedLocales: S.delegate.supportedLocales,
          theme: state.isDark ? dartTheme : lightTheme,
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      },
    );
  }
}
