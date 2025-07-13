import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/settings/cubit/settings_cubit.dart';

@RoutePage()
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<SettingsCubit>().userModelAppInterface.user!;
    debugPrint(user.token!);
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Column(
        children: [
          Text(user.id, style: TextStyle(color: Colors.black)),
          Text(user.username, style: TextStyle(color: Colors.black)),
          Text(user.friends.toString(), style: TextStyle(color: Colors.black)),
          Text(user.firstname!, style: TextStyle(color: Colors.black)),
          Text(user.subname!, style: TextStyle(color: Colors.black)),
          Text(user.token!, style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
