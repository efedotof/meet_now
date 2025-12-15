import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/app/app_model.dart';
import 'package:meet_now_admin_panel/features/analytics/cubit/analytics_cubit.dart';
import 'package:meet_now_admin_panel/features/content/cubit/content_cubit.dart';
import 'package:meet_now_admin_panel/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:meet_now_admin_panel/features/login/cubit/login_cubit.dart';
import 'package:meet_now_admin_panel/features/moderation/cubit/moderation_cubit.dart';
import 'package:meet_now_admin_panel/features/push_notifications/cubit/push_notifications_cubit.dart';
import 'package:meet_now_admin_panel/features/system/cubit/system_cubit.dart';
import 'package:meet_now_admin_panel/features/users/cubit/users_cubit.dart';
import 'package:meet_now_app_server/repository/admin/admin_interface.dart';

class AppBloc extends StatelessWidget {
  const AppBloc({super.key, required this.config, required this.child});

  final AppModel config;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              LoginCubit(adminInterface: context.read<AdminInterface>()),
        ),
        BlocProvider(
          create: (context) =>
              DashboardCubit(adminInterface: context.read<AdminInterface>()),
        ),
        BlocProvider(
          create: (context) =>
              AnalyticsCubit(adminInterface: context.read<AdminInterface>()),
        ),
        BlocProvider(
          create: (context) =>
              ContentCubit(adminInterface: context.read<AdminInterface>()),
        ),
        BlocProvider(
          create: (context) =>
              ModerationCubit(adminInterface: context.read<AdminInterface>()),
        ),
        BlocProvider(
          create: (context) => PushNotificationsCubit(
            adminInterface: context.read<AdminInterface>(),
          ),
        ),
        BlocProvider(
          create: (context) =>
              SystemCubit(adminInterface: context.read<AdminInterface>()),
        ),
        BlocProvider(
          create: (context) =>
              UsersCubit(adminInterface: context.read<AdminInterface>()),
        ),
      ],
      child: child,
    );
  }
}
