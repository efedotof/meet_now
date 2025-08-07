import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:meet_now_app/app/app_config.dart';
import 'package:meet_now_app/app/app_initializer.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/theme/theme_cubit/theme_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/theme.dart';

void main() async {
  bool isJailbroken = false;
  try {
    isJailbroken = await FlutterJailbreakDetection.jailbroken;
  } catch (e) {
    debugPrint("Ошибка при проверке рут/джейлбрейк: $e");
  }
  if (isJailbroken) {
    runApp(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: AlertDialog(
              title: Text('Ошибка безопасности'),
              content: Text(
                'Приложение не может работать на рутованных устройствах или устройствах с джейлбрейком.',
              ),
            ),
          ),
        ),
      ),
    );
    await Future.delayed(const Duration(seconds: 3));
    SystemNavigator.pop();
    return;
  }

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
