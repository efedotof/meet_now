import 'package:flutter/material.dart';
import 'package:meet_now_app/features/chat_message/view/chat_message_screen.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/chats/permanent_chat_response_dto/permanent_chat_response_dto.dart';
import 'package:meet_now_app_server/model/chats/temporary/temporary_chat.dart';

class RightPanel extends StatelessWidget {
  const RightPanel({
    super.key,
    PermanentChatResponseDto? selectedPermanentChat,
    TemporaryChat? selectedTemporaryChat,
    required void Function() clearSelectedChat,
  }) : _selectedPermanentChat = selectedPermanentChat,
       _selectedTemporaryChat = selectedTemporaryChat,
       _clearSelectedChat = clearSelectedChat;
  final PermanentChatResponseDto? _selectedPermanentChat;
  final TemporaryChat? _selectedTemporaryChat;
  final VoidCallback _clearSelectedChat;

  @override
  Widget build(BuildContext context) {
    if (_selectedPermanentChat == null && _selectedTemporaryChat == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_outlined,
              size: 80,
              color: Theme.of(
                context,
              ).colorScheme.secondary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              S.of(context).select_chat_to_start,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context).select_chat_hint,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    return ChatMessageScreen(
      key: ValueKey(
        _selectedPermanentChat?.chatId ?? _selectedTemporaryChat?.tempChatId,
      ),
      chatModel: _selectedPermanentChat,
      temporaryChatModel: _selectedTemporaryChat,
      onClose: _clearSelectedChat,
      isEmbedded: true,
      chatKey:
          _selectedPermanentChat?.chatId ??
          _selectedTemporaryChat?.tempChatId ??
          '',
    );
  }
}
