import 'package:flutter/material.dart';
import 'package:meet_now_admin_panel/app/app_initialize.dart';
import 'package:meet_now_admin_panel/app/app_model.dart';
import 'package:meet_now_admin_panel/route/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  AppModel model = AppModel(prefs: prefs);

  runApp(AppInitialize(config: model, child: MeetNowAdminPanel()));
}

class MeetNowAdminPanel extends StatefulWidget {
  const MeetNowAdminPanel({super.key});

  @override
  State<MeetNowAdminPanel> createState() => _MeetNowAdminPanelState();
}

class _MeetNowAdminPanelState extends State<MeetNowAdminPanel> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _appRouter.config(),
    );
  }
}
