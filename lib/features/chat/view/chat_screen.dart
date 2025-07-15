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
          appBar: AppBar(
            title: const Text("Чаты"),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  // Поиск чатов
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh:
                () => context.read<ChatCubit>().getChatsUser(context: context),
            color: Theme.of(context).colorScheme.primary,
            child: state.when(
              initial:
                  () => Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
              getChats:
                  (temporaryChat, permanentChat) => CustomScrollView(
                    slivers: [
                      // Временные чаты
                      if (temporaryChat.isNotEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: TemporaryChatsBanner(
                              count: temporaryChat.length,
                            ),
                          ),
                        ),

                      // Постоянные чаты
                      SliverPadding(
                        padding: const EdgeInsets.only(
                          top: 8,
                          left: 16,
                          right: 16,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: Text(
                            "Постоянные чаты",
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      if (permanentChat.isEmpty)
                        SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.forum_outlined,
                                  size: 64,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "У вас пока нет постоянных чатов",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Начните общение, чтобы добавить людей в друзья",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton(
                                  onPressed: () {
                                    // Начать поиск собеседника
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const Text('Начать общение'),
                                ),
                              ],
                            ),
                          ),
                        ),

                      if (permanentChat.isNotEmpty)
                        SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final chat = permanentChat[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: ChatTile(
                                name:
                                    "${chat.user1.firstname ?? 'Аноним'} ${chat.user1.subname ?? ''}",
                                lastMessage: "lastMessage",
                                unreadCount: 3,
                                avatar: chat.user1.avatar,
                              ),
                            );
                          }, childCount: permanentChat.length),
                        ),
                    ],
                  ),
            ),
          ),
        );
      },
    );
  }
}
