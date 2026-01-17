import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/splash/cubit/splash_cubit.dart';
import 'package:meet_now_app/route/app_route.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashCubit>().checkAutoLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        state.whenOrNull(
          navigateToAuth: () => context.replaceRoute(const AuthRoute()),
          navigateToLocked: () => context.replaceRoute(const LockedRoute()),
          navigateToUploadAvatar:
              () => context.replaceRoute(UploadsAvatarsRoute()),
          navigateToPinCode: () => context.replaceRoute(const PinCodeRoute()),
          navigateToMainHome: () => context.replaceRoute(const MainHomeRoute()),
        );
      },
      child: Scaffold(
        body: Center(child: Text("MeetNow", style: TextStyle(fontSize: 20))),
      ),
    );
  }
}
