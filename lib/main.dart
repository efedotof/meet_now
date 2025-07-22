import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meet_now_app/app/app_config.dart';
import 'package:meet_now_app/app/app_initializer.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/theme/theme_cubit/theme_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final appConfig = AppConfig(prefs: await SharedPreferences.getInstance());

  runApp(AppInitializer(config: appConfig, child: const MeetNowApp()));
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
          debugShowCheckedModeBanner: false,
          routerConfig: _appRouter.config(),
          theme: state.isDark ? dartTheme : lightTheme,
        );
      },
    );
  }
}
