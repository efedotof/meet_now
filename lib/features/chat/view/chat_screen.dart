import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat/cubit/chat_cubit.dart';
import 'package:meet_now_app/features/chat/widget/widget.dart';

@RoutePage()
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ChatCubit>().getChatsUser(context: context);

    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text("Чаты")),
          body: RefreshIndicator(
            onRefresh:
                () => context.read<ChatCubit>().getChatsUser(context: context),
            child: state.when(
              initial: () => const Center(child: CircularProgressIndicator()),
              getChats:
                  (temporaryChat, permanentChat) => SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (temporaryChat.isNotEmpty)
                          TemporaryChatsBanner(count: temporaryChat.length),

                        const SizedBox(height: 24),

                        if (permanentChat.isEmpty)
                          Center(
                            child: Text(
                              "Постоянных чатов нет",
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),

                        if (permanentChat.isNotEmpty)
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: permanentChat.length,
                            separatorBuilder:
                                (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final chat = permanentChat[index];
                              return ChatTile(
                                name:
                                    "${chat.user1.firstname!} ${chat.user1.subname!}",
                                lastMessage: "lastMessage",
                                unreadCount: 3,
                              );
                            },
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
