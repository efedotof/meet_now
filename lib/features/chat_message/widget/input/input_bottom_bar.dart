import 'package:flutter/material.dart';
import 'package:meet_now_app/features/chat_message/cubit/sticker/sticker_cubit.dart';

import 'send_button.dart';
import 'message_text_field.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant.withAlpha(1),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!isTemporary && onAddAttach != null)
            Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.black87 : Colors.white70,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(6),
              child: GestureDetector(
                onTap: onAddAttach,
                child: Icon(
                  Icons.add_circle_outline,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
          const SizedBox(width: 8),
          MessageTextField(
            controller: controller,
            chatId: chatId,
            focusNode: textFieldFocusNode,
            stickerCubit: stickerCubit,
            onSend: onSend,
          ),
          const SizedBox(width: 8),
          SendButton(onPressed: onSend),
        ],
      ),
    );
  }
}
