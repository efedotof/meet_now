import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat/cubit/chat_cubit.dart';
import 'package:meet_now_app/features/search/widget/anon_search/search_progress_bar.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';

import 'my_body.dart';
import 'right_panel.dart';
import 'search_field.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({
    super.key,
    required this.state,
    required this.selectedPermanentChat,
    required this.selectedTemporaryChat,
    required this.selectChat,
    required this.clearSelectedChat,
    required this.searchController,
    required this.refreshIndicatorKey,
  });

  final ChatState state;
  final PermanentChatResponseDto? selectedPermanentChat;
  final TemporaryChat? selectedTemporaryChat;
  final Function({
    PermanentChatResponseDto? permanentChat,
    TemporaryChat? temporaryChat,
  })
  selectChat;
  final VoidCallback clearSelectedChat;
  final TextEditingController searchController;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(S.of(context).chats),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: SearchField(
                      controller: searchController,
                      onChanged: (value) {
                        context.read<ChatCubit>().updateSearchQuery(value);
                      },
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      key: refreshIndicatorKey,
                      onRefresh: () async {
                        await context.read<ChatCubit>().refresh();
                      },
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: MyBody(
                            state: state,
                            onChatSelected: selectChat,
                            selectedPermanentChat: selectedPermanentChat,
                            selectedTemporaryChat: selectedTemporaryChat,
                            forceShowAll: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SearchProgressBar(),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: RightPanel(
              selectedPermanentChat: selectedPermanentChat,
              selectedTemporaryChat: selectedTemporaryChat,
              clearSelectedChat: clearSelectedChat,
            ),
          ),
        ],
      ),
    );
  }
}
