import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat/cubit/chat_cubit.dart';

@RoutePage()
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ChatCubit>().getChatsUser(context: context);
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text("UserChat")),
          body: RefreshIndicator(
            onRefresh:
                () => context.read<ChatCubit>().getChatsUser(context: context),
            child: state.when(
              initial: () => Center(child: CircularProgressIndicator()),
              getChats:
                  (temporaryChat, permomentChat) => SingleChildScrollView(
                    child: Wrap(
                      children: [
                        Text("Temporary Chats"),
                        ...List.generate(
                          temporaryChat.length,
                          (index) => SizedBox(
                            child: Column(
                              children: [
                                Text(
                                  temporaryChat[index].recipientId,
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text(
                                  temporaryChat[index].senderId,
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text(
                                  temporaryChat[index].tempChatId,
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text(
                                  temporaryChat[index].bothAgreed.toString(),
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text(
                                  temporaryChat[index].createdAt.toString(),
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text(
                                  temporaryChat[index].durationMinutes
                                      .toString(),
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text(
                                  temporaryChat[index].isFinished.toString(),
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text("Chats"),
                        ...List.generate(
                          permomentChat.length,
                          (index) => SizedBox(
                            child: Column(
                              children: [
                                Text(
                                  permomentChat[index].user1.username,
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text(
                                  permomentChat[index].chatId,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            ),
          ),
        );
      },
    );
  }
}
