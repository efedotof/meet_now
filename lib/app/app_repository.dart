import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/app/app_model.dart';
import 'package:meet_now_admin_panel/config.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';
import 'package:meet_now_app_server/repository/admin/admin_interface.dart';
import 'package:meet_now_app_server/repository/admin/admin_repository.dart';

class AppRepository extends StatelessWidget {
  const AppRepository({super.key, required this.child, required this.config});

  final Widget child;
  final AppModel config;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<TokenInterface>(
          create: (context) => TokenRepository(preferences: config.prefs),
        ),
        RepositoryProvider<AdminInterface>(
          create: (context) => AdminRepository(
            serverAddress: serverAddress,
            authAddress: authAddress,
            searchAddress: searchAddress,
            chatAddress: chatAddress,
            friendAddress: friendAddress,
            userAddress: userAddress,
            uploadsAddress: uploadsAddress,
            uploadGetAddress: uploadGetAddress,
            socketAddress: socketAddress,
            iceBreakerAddress: iceBreakerAddress,
            tokenValidation: tokenAddressToAdmin,
            gamesAddress: gamesAddress,
            purpAndInter: purpAndInter,
            reportAddress: reportAddress,
            stickersAddress: stickersAddress,
            cityAddress: cityAddress,
            giftAddress: giftAddress,
            userStatsAddress: userStatsAddress,
            supportAddress: supportAddress,
            pushNotificationAddress: pushNotificationAddress,
            mqttAddress: mqttAddress,
            tokenInterface: context.read<TokenInterface>(),
          ),
        ),
      ],
      child: child,
    );
  }
}
