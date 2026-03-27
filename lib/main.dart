import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:media_ui_package/media_ui_package.dart';
import 'package:meet_now_app/app/app_config.dart';
import 'package:meet_now_app/app/app_initializer.dart';
import 'package:meet_now_app/app/utils/web_utils.dart';
import 'package:meet_now_app/features/language/cubit/language_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:media_ui_package/generated/l10n.dart' as media_package;
import 'package:meet_now_app/route/app_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/theme/theme_cubit/theme_cubit.dart';
import 'package:meet_now_app_server/hive_registrar.g.dart';
import 'package:meet_now_app_server/service/logging/logger_service.dart';
import 'package:meet_now_app_server/service/push_notification/fcm_notification_service.dart';
import 'package:meet_now_app_server/storage/storage_hive/storage_hive_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mobileads/mobile_ads.dart';
import 'theme/theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:meet_now_app/app/utils/web_reload.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FCMNotificationService.firebaseMessagingBackgroundHandler(message);
}

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      DeviceMediaLibrary.initialize();
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

      final prefs = await SharedPreferences.getInstance();
      final appConfig = AppConfig(prefs: prefs);
      runApp(
        AppInitializer(
          config: appConfig,
          storageHive: storageHive,
          child: const MeetNowApp(),
        ),
      );
      if (kIsWeb) {
        Future.delayed(const Duration(milliseconds: 50), () {
          WidgetsBinding.instance.handleMetricsChanged();
        });
      }
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
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter();
    MobileAds.initialize();
    if (kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (kIsWeb) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (isHardReload()) {
              _appRouter.replaceAll([const SplashRoute()]);
            }
          });
        }
      });
    }
    if (!kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final isDark = context.read<ThemeCubit>().state.isDark;
        _updateSystemUIOverlay(isDark);
      });
    }
  }

  void _updateSystemUIOverlay(bool isDark) {
    if (kIsWeb) return;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,

        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,

        systemNavigationBarColor:
            isDark ? const Color(0xFF111010) : Colors.white,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        if (kIsWeb) {
          updateWebBackground(state.isDark);
        } else {
          _updateSystemUIOverlay(state.isDark);
        }

        return MaterialApp.router(
          locale: Locale(context.watch<LanguageCubit>().checkLocale()),
          debugShowCheckedModeBanner: false,
          routerConfig: _appRouter.config(),
          supportedLocales: S.delegate.supportedLocales,
          theme: state.isDark ? dartTheme : lightTheme,
          builder: (context, child) {
            return ColoredBox(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: child!,
            );
          },
          localizationsDelegates: [
            S.delegate,
            media_package.S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      },
    );
  }
}
