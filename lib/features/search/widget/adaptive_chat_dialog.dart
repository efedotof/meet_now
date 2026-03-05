import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meet_now_app/features/chat_message/view/chat_message_screen.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/chats/temporary/temporary_chat.dart';

class AdaptiveChatDialog extends StatefulWidget {
  final TemporaryChat chat;
  final VoidCallback onClose;

  const AdaptiveChatDialog({
    super.key,
    required this.chat,
    required this.onClose,
  });

  @override
  State<AdaptiveChatDialog> createState() => _AdaptiveChatDialogState();
}

class _AdaptiveChatDialogState extends State<AdaptiveChatDialog> {
  bool _isFullScreen = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWeb = kIsWeb;
    final screenWidth = MediaQuery.of(context).size.width;

    const breakpoint = 600;

    if (screenWidth < breakpoint && !_isFullScreen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _isFullScreen = true;
          });
        }
      });
    } else if (screenWidth >= breakpoint && _isFullScreen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _isFullScreen = false;
          });
        }
      });
    }

    return Dialog(
      insetPadding: _isFullScreen ? EdgeInsets.zero : const EdgeInsets.all(20),
      backgroundColor: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: _isFullScreen ? double.infinity : null,
        height: _isFullScreen ? double.infinity : null,
        constraints:
            _isFullScreen
                ? BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                  maxHeight: MediaQuery.of(context).size.height,
                )
                : BoxConstraints(
                  maxWidth: isWeb ? 800 : 500,
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius:
              _isFullScreen
                  ? BorderRadius.zero
                  : BorderRadius.circular(isWeb ? 16 : 12),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius:
                    _isFullScreen
                        ? BorderRadius.zero
                        : BorderRadius.only(
                          topLeft: Radius.circular(isWeb ? 16 : 12),
                          topRight: Radius.circular(isWeb ? 16 : 12),
                        ),
              ),
              child: Row(
                children: [
                  Icon(Icons.chat, color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      S.of(context).chat,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  if (!_isFullScreen)
                    IconButton(
                      onPressed: widget.onClose,
                      icon: Icon(
                        Icons.close,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                ],
              ),
            ),

            Expanded(
              child: ChatMessageScreen(
                temporaryChatModel: widget.chat,
                chatKey: widget.chat.tempChatId,
                onClose: widget.onClose,
                isEmbedded: true,
              ),
            ),

            if (_isFullScreen)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  border: Border(
                    top: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: widget.onClose,
                    icon: const Icon(Icons.close),
                    label: Text(S.of(context).closeTheChat),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
