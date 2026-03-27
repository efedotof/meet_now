import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat/cubit/chat_cubit.dart';
import 'package:meet_now_app/features/search/widget/anon_search/search_progress_bar.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app_server/model/chats/permanent_chat_response_dto/permanent_chat_response_dto.dart';
import 'package:meet_now_app_server/model/chats/temporary/temporary_chat.dart';

import 'my_body.dart';
import 'search_field.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({
    super.key,
    required this.state,
    required this.isDark,
    required this.searchController,
    required this.refreshIndicatorKey,
    required this.selectChat,
  });

  final ChatState state;
  final bool isDark;
  final TextEditingController searchController;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
  final Function({
    PermanentChatResponseDto? permanentChat,
    TemporaryChat? temporaryChat,
  })
  selectChat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        actions: [
          RawMaterialButton(
            fillColor: isDark ? Colors.white : Colors.black,
            onPressed: () => context.pushRoute(FriendsRoute()),
            elevation: 2.0,
            shape: const CircleBorder(),
            constraints: const BoxConstraints(minWidth: 0.0),
            child: Icon(Icons.add, color: isDark ? Colors.black : Colors.white),
          ),
        ],
      ),
      body: RefreshIndicator(
        key: refreshIndicatorKey,
        onRefresh: () async {
          await context.read<ChatCubit>().refresh();
        },
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchField(
                      controller: searchController,
                      onChanged: (value) {
                        context.read<ChatCubit>().updateSearchQuery(value);
                      },
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children:
                          [
                            (ChatType.all, S.of(context).all),
                            (ChatType.permanent, S.of(context).permanent),
                            (ChatType.temporary, S.of(context).temporary),
                          ].map((type) {
                            return ChoiceChip(
                              label: Text(type.$2),
                              selected: state.selectedChatType == type.$1,
                              iconTheme: IconThemeData(
                                color: isDark ? Colors.black : Colors.white,
                              ),
                              checkmarkColor:
                                  isDark ? Colors.black : Colors.white,
                              onSelected: (selected) {
                                if (selected) {
                                  context.read<ChatCubit>().changeChatType(
                                    type.$1,
                                  );
                                }
                              },
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 10),
                    MyBody(state: state, onChatSelected: selectChat),
                  ],
                ),
              ),
            ),

            const SearchProgressBar(),
          ],
        ),
      ),
    );
  }
}
