import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat_message/cubit/sticker/sticker_cubit.dart';

class InputBottomBar extends StatelessWidget {
  const InputBottomBar({
    required this.controller,
    required this.chatId,
    required this.onAddAttach,
    required this.onSend,
    required this.stickerCubit,
    required this.textFieldFocusNode,
    required this.isTemporary,
    super.key,
  });

  final TextEditingController controller;
  final String chatId;
  final VoidCallback? onAddAttach;
  final VoidCallback onSend;
  final StickerCubit stickerCubit;
  final FocusNode textFieldFocusNode;
  final bool isTemporary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: theme.colorScheme.outline, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isTemporary && onAddAttach != null)
            IconButton(
              icon: Icon(Icons.attach_file, color: theme.colorScheme.primary),
              onPressed: onAddAttach,
            ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: controller,
                focusNode: textFieldFocusNode,
                decoration: InputDecoration(
                  hintText: 'Сообщение...',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  suffixIcon: BlocBuilder<StickerCubit, StickerState>(
                    builder: (context, state) {
                      return IconButton(
                        icon: Icon(Icons.emoji_emotions_outlined),
                        onPressed: () {
                          stickerCubit.toggleStickers();
                          FocusScope.of(context).unfocus();
                        },
                      );
                    },
                  ),
                ),
                style: theme.textTheme.bodyMedium,
                minLines: 1,
                maxLines: 5,
                onSubmitted: (_) => onSend(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary,
            ),
            margin: const EdgeInsets.only(bottom: 8),
            child: IconButton(
              icon: Icon(Icons.send, color: theme.colorScheme.onPrimary),
              onPressed: onSend,
            ),
          ),
        ],
      ),
    );
  }
}
