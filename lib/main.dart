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
import 'package:meet_now_app_server/storage/hive/repository/storage_hive_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/theme.dart';
import "package:hive_ce/hive.dart";
import 'package:path_provider/path_provider.dart';
import 'package:meet_now_app_server/hive_registrar.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final directory = await getApplicationDocumentsDirectory();
  Hive
    ..init(directory.path)
    ..registerAdapters();
  final appConfig = AppConfig(prefs: await SharedPreferences.getInstance());
  final storageHive = StorageHiveRepository();
  await storageHive.init();

  runApp(
    AppInitializer(
      config: appConfig,
      storageHive: storageHive,
      child: const MeetNowApp(),
    ),
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
