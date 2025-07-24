import 'package:flutter/material.dart';
import 'app_config.dart';
import 'app_repository.dart';
import 'app_bloc.dart';

class AppInitializer extends StatelessWidget {
  const AppInitializer({super.key, required this.child, required this.config});
  final AppConfig config;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppRepository(
      config: config,
      child: AppBloc(config: config, child: child),
    );
  }
}
