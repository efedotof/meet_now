import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';
import 'app_config.dart';
import 'app_repository.dart';
import 'app_bloc.dart';

class AppInitializer extends StatefulWidget {
  const AppInitializer({
    super.key,
    required this.child,
    required this.config,
    required this.storageHive,
  });

  final AppConfig config;
  final Widget child;
  final StorageHiveRepository? storageHive;

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    if (!kIsWeb && widget.storageHive != null) {
      try {
        final storageHive = widget.storageHive!;
        try {
          final _ = storageHive.interestBox;
          final _ = storageHive.purposeBox;
        } catch (e) {
          debugPrint("Hive box error detected, attempting to fix...");
          await storageHive.init();
        }
      } catch (e) {
        debugPrint("Failed to initialize Hive: $e");
      }
    }

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Material(child: Center(child: CircularProgressIndicator()));
    }

    return AppRepository(
      config: widget.config,
      storageHive: widget.storageHive,
      child: AppBloc(config: widget.config, child: widget.child),
    );
  }
}
