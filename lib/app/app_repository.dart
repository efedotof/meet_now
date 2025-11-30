import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/app/app_config.dart';
import 'package:meet_now_app/config.dart';
import 'package:meet_now_app_server/initialize.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';

class AppRepository extends StatelessWidget {
  const AppRepository({
    super.key,
    required this.child,
    required this.config,
    required this.storageHive,
  });

  final Widget child;
  final AppConfig config;
  final StorageHiveRepository storageHive;

  MultiRepositoryProvider get getRepository =>
      Initialize(
        encryptionKey: encryptionKey,
        prefs: config.prefs,
        child: child,
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
        tokenValidation: tokenValidation,
        gamesAddress: gamesAddress,
        purpAndInter: purpAndInter,
        reportAddress: reportAddress,
        stickersAddress: stickersAddress,
        cityAddress: cityAddress,
        giftAddress: giftAddress,
        userStatsAddress: userStatsAddress,
        supportAddress: supportAddress,
        pushNotificationAddress: pushNotificationAddress,
      ).initializeRepository();

  @override
  Widget build(BuildContext context) {
    return Initialize(
      encryptionKey: encryptionKey,
      prefs: config.prefs,
      child: child,
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
      tokenValidation: tokenValidation,
      gamesAddress: gamesAddress,
      purpAndInter: purpAndInter,
      reportAddress: reportAddress,
      stickersAddress: stickersAddress,
      cityAddress: cityAddress,
      giftAddress: giftAddress,
      userStatsAddress: userStatsAddress,
      supportAddress: supportAddress,
      pushNotificationAddress: pushNotificationAddress,
    ).initializeRepository();
  }
}
