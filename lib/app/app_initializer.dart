import 'package:flutter/material.dart';
import 'package:meet_now_app_server/storage/hive/repository/storage_hive_repository.dart';
import 'app_config.dart';
import 'app_repository.dart';
import 'app_bloc.dart';

class AppInitializer extends StatelessWidget {
  const AppInitializer({
    super.key,
    required this.child,
    required this.config,
    required this.storageHive,
  });
  final AppConfig config;
  final Widget child;
  final StorageHiveRepository storageHive;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final _ = storageHive.interestBox;
        final _ = storageHive.purposeBox;
      } catch (e) {
        debugPrint("Hive box error detected, attempting to fix...");
        await storageHive.init();
      }
    });

    return AppRepository(
      config: config,
      storageHive: storageHive,
      child: AppBloc(config: config, child: child),
    );
  }
}
