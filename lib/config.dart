import 'package:encrypt/encrypt.dart';

String serverAddress = "mnapp.ru";
String authAddress = "https://$serverAddress/api/v1/auth";
String searchAddress = "https://$serverAddress/api/v1/search";
String chatAddress = "https://$serverAddress/api/v1/chat";
String friendAddress = "https://$serverAddress/api/v1/friend";
String userAddress = "https://$serverAddress/api/v1/user";
String uploadsAddress = "https://$serverAddress/api/v1/uploads";
String uploadGetAddress = "https://$serverAddress";
String socketAddress = "https://$serverAddress/ws";
String iceBreakerAddress = "https://$serverAddress/api/v1/icebreaker";
String tokenValidation = "https://$serverAddress/api/v1/auth/token/validate-token";
String tokenAddressToAdmin =  "https://$serverAddress/api/v1/auth/token";


String gamesAddress = "https://$serverAddress/api/v1/games";
String purpAndInter = "https://$serverAddress/api/v1/purpAndInt";
String reportAddress = "https://$serverAddress/api/v1/reports";
String stickersAddress = "https://$serverAddress/api/v1/stickers";
String cityAddress = "https://$serverAddress/api/v1/cities";

String giftAddress = 'https://$serverAddress/api/v1/gifts';
String userStatsAddress = 'https://$serverAddress/api/v1/admin/statistics';
String supportAddress = 'https://$serverAddress/api/v1/support';
String pushNotificationAddress = 'https://$serverAddress/api/v1/notifications';
String mqttAddress = 'https://$serverAddress:1883';

Key encryptionKey = Key.fromUtf8('my32lengthsupersecretnooneknows!');
IV iv = IV.fromLength(16);
