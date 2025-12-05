import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat_message/cubit/command_suggestions/command_suggestions_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/sticker/sticker_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/user_activity/user_activity_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/social/user_activity/user_activity.dart';

class MessageTextField extends StatelessWidget {
  const MessageTextField({
    required this.controller,
    required this.chatId,
    required this.focusNode,
    required this.stickerCubit,
    required this.onSend,
    super.key,
  });

  final TextEditingController controller;
  final String chatId;
  final FocusNode focusNode;
  final StickerCubit stickerCubit;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.black87 : Colors.white70,
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: S.of(context).messageHint,
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  isCollapsed: false,
                  fillColor: Colors.transparent,
                  filled: false,
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.white : Colors.black,
                ),
                minLines: 1,
                maxLines: 5,
                onChanged: (value) {
                  context.read<UserActivityCubit>().sendActivity(
                    type: ActivityType.TYPING,
                    chatId: chatId,
                  );
                  context
                      .read<CommandSuggestionsCubit>()
                      .showSuggestionsVisible(value);
                },
                onSubmitted: (_) => onSend(),
              ),
            ),
            BlocBuilder<StickerCubit, StickerState>(
              builder: (context, state) {
                final color = state.maybeWhen(
                  visible: () => isDark ? Colors.white : Colors.black,
                  orElse: () => isDark ? Colors.white : Colors.black,
                );
                return IconButton(
                  icon: Icon(Icons.emoji_emotions_outlined, color: color),
                  onPressed: () {
                    stickerCubit.toggleStickers();
                    FocusScope.of(context).unfocus();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
