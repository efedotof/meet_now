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
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withAlpha(5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          hintText: S.of(context).messageHint,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          suffixIcon: BlocBuilder<StickerCubit, StickerState>(
            builder: (context, state) {
              final color = state.maybeWhen(
                visible: () => theme.colorScheme.primary,
                orElse: () => theme.colorScheme.onSurfaceVariant,
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
        ),
        onChanged: (value) {
          context.read<UserActivityCubit>().sendActivity(
            type: ActivityType.TYPING,
            chatId: chatId,
          );
          context.read<CommandSuggestionsCubit>().showSuggestionsVisible(value);
        },
        style: theme.textTheme.bodyMedium,
        minLines: 1,
        maxLines: 5,
        onSubmitted: (_) => onSend(),
      ),
    );
  }
}
