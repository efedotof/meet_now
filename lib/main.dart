import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/theme/repository/theme_repository.dart';
import 'package:meet_now_app/theme/theme_cubit/theme_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final prefs = await SharedPreferences.getInstance();
  final themeRepository = ThemeRepository(preferences: prefs);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit(themeInterface: themeRepository),
        ),
      ],
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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _appRouter.config(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}
