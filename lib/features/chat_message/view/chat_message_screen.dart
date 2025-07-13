import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:meet_now_app/server/model/chat/chat.dart';
import 'package:meet_now_app/server/model/temporary/temporary_chat.dart';

@RoutePage()
class ChatMessageScreen extends StatelessWidget {
  const ChatMessageScreen({
    required this.chatModel,
    super.key,
    required this.temporaryChatModel,
  });
  final TemporaryChat temporaryChatModel;
  final Chat? chatModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Пользователь")),
      body: Center(
        child: Text(
          "recipientId:${temporaryChatModel.recipientId} bothAgreed: ${temporaryChatModel.bothAgreed} isFinished: ${temporaryChatModel.isFinished} senderId:${temporaryChatModel.senderId} tempChatId: ${temporaryChatModel.tempChatId}",
        ),
      ),
    );
  }
}
