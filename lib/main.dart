import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meet_now_app/features/auth/view/sign_in/cubit/sign_in_cubit.dart';
import 'package:meet_now_app/features/auth/view/sign_up/cubit/sign_up_cubit.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_repository.dart';
import 'package:meet_now_app/storage/password/password_storage_repository.dart';
import 'package:meet_now_app/storage/user/user_storage_repository.dart';
import 'package:meet_now_app/theme/repository/theme_repository.dart';
import 'package:meet_now_app/theme/theme_cubit/theme_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/splash/cubit/splash_cubit.dart';
import 'server/repository/auth/auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final prefs = await SharedPreferences.getInstance();

  ///
  /// репозиторий для темы
  ///
  final themeRepository = ThemeRepository(preferences: prefs);

  ///
  /// сохранение пользователя в local
  ///
  final userStorageRepository = UserStorageRepository(preferences: prefs);

  ///
  /// получение и регистрация пароля
  ///
  final passwordStorageRepository = PasswordStorageRepository(
    preferences: prefs,
  );

  ///
  /// тут getter и setter для модели пользователя
  ///
  final userModelAppRepository = UserModelAppRepository();

  ///
  /// репозиторий для авторизации
  ///
  final authRepository = AuthRepository(
    passwordStorageInterface: passwordStorageRepository,
    userModelAppInterface: userModelAppRepository,
    userStorageInterface: userStorageRepository,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit(themeInterface: themeRepository),
        ),
        BlocProvider(
          create: (context) => SignInCubit(authInterface: authRepository),
        ),
        BlocProvider(
          create: (context) => SignUpCubit(authInterface: authRepository),
        ),
        BlocProvider(
          create:
              (context) => SplashCubit(
                userStorageInterface: userStorageRepository,
                passwordStorageInterface: passwordStorageRepository,
                authInterface: authRepository,
                userModelAppInterface: userModelAppRepository,
              ),
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
