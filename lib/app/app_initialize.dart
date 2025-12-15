import 'package:flutter/material.dart';
import 'package:meet_now_admin_panel/app/app_model.dart';

import 'app_bloc.dart';
import 'app_repository.dart';

class AppInitialize extends StatelessWidget {
  const AppInitialize({super.key, required this.config, required this.child});
  final AppModel config;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppRepository(
      config: config,
      child: AppBloc(config: config, child: child),
    );
  }
}
