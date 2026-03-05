import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_ui_package/media_ui_package.dart';
import 'package:meet_now_app/features/chat/cubit/chat_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/chat/chat_message_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/media_selection/media_selection_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/sticker/sticker_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/sync_timer/sync_timer_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/user_activity/user_activity_cubit.dart';
import 'package:meet_now_app/features/chat_message/widget/widget.dart';
import 'package:meet_now_app/generated/l10n.dart' show S;
import 'package:meet_now_app_server/meet_now_app_server.dart';

@RoutePage()
class ChatMessageScreen extends StatefulWidget {
  const ChatMessageScreen({
    super.key,
    required this.temporaryChatModel,
    this.chatModel,
    this.onClose,
    this.isEmbedded = false,
    required this.chatKey,
  });

  final TemporaryChat? temporaryChatModel;
  final PermanentChatResponseDto? chatModel;
  final VoidCallback? onClose;
  final bool isEmbedded;
  final String chatKey;

  @override
  State<ChatMessageScreen> createState() => _ChatMessageScreenState();
}

class _ChatMessageScreenState extends State<ChatMessageScreen> {
  late final _messageController = TextEditingController();
  late final _scrollController = ScrollController();
  StreamSubscription<ChatMessageState>? _subscription;
  StreamSubscription<SyncTimerState>? _timerSubscription;
  SyncTimerCubit? _timerCubit;
  MediaSelectionCubit? _mediaSelectionCubit;
  ChatCubit? _chatCubit;
  UserActivityCubit? _userActivityCubit;
  ChatMessageCubit? _chatMessageCubit;
  SocketServiceInterface? _socketService;

  String? _chatId;
  bool isTemporary = false;
  String senderID = '';
  String recipientId = '';
  bool _isDialogShowing = false;
  bool _isInitialized = false;
  bool _disposed = false;

  bool _isContinueProposalShown = false;
  bool _isWaitingDialogShown = false;
  bool _isPermanentChatDialogShown = false;
  bool _isTimerFinishedDialogShown = false;
  bool _isTimeOptionsDialogShown = false;
  bool _isAddTimeProposalDialogShown = false;
  bool _isExitConfirmationDialogShown = false;

  @override
  void initState() {
    super.initState();
    _mediaSelectionCubit = MediaSelectionCubit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeChat();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_chatCubit == null) {
      _chatCubit = context.read<ChatCubit>();
      _userActivityCubit = context.read<UserActivityCubit>();
      _chatMessageCubit = context.read<ChatMessageCubit>();
      _socketService = context.read<SocketServiceInterface>();
    }
  }

  @override
  void didUpdateWidget(ChatMessageScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.chatKey != widget.chatKey) {
      _cleanup();
      _initializeChat();
    }
  }

  void _initializeChat() {
    if (!mounted || _disposed) return;

    try {
      final currentUser = context.read<UserModelAppInterface>().user;
      if (currentUser == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).userNotAvailable),
              duration: const Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      if (widget.chatModel != null) {
        _chatId = widget.chatModel!.chatId;
        isTemporary = false;
      } else if (widget.temporaryChatModel != null) {
        _chatId = widget.temporaryChatModel!.tempChatId;
        isTemporary = true;
      }

      if (_chatId == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).chat_id_not_available),
              duration: const Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      senderID = currentUser.id;

      recipientId =
          isTemporary
              ? _getTemporaryChatRecipient(currentUserId: currentUser.id)
              : _getChatRecipient(currentUserId: currentUser.id);

      _userActivityCubit?.subscribeAction(chatId: _chatId!);

      _chatMessageCubit?.initialize(
        context: context,
        isTemporary: isTemporary,
        chatId: _chatId!,
        senderId: senderID,
        recipientId: recipientId,
      );

      _subscription = _chatMessageCubit?.stream.listen(_handleChatMessageState);

      if (isTemporary) {
        final totalTime = widget.temporaryChatModel!.durationMinutes * 60;
        _timerCubit = SyncTimerCubit(
          timerRepository: TimerRepository(socketService: _socketService!),
          tempChatId: _chatId!,
          userId: senderID,
          totalTime: totalTime,
        );

        _timerSubscription = _timerCubit?.stream.listen(_handleSyncTimerState);
      }

      _isInitialized = true;
      if (mounted && !_disposed) setState(() {});
    } catch (e) {
      if (mounted && !_disposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).error_initializing_chat),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _cleanup() {
    if (_disposed) return;

    _subscription?.cancel();
    _subscription = null;
    _timerSubscription?.cancel();
    _timerSubscription = null;
    _timerCubit?.close();
    _timerCubit = null;
    _mediaSelectionCubit?.close();
    _mediaSelectionCubit = null;
    _messageController.clear();
    _isInitialized = false;

    _resetAllDialogFlags();

    if (_chatId != null) {
      if (isTemporary) {
        _chatCubit?.closeTempChat(tempChatId: _chatId!);
      } else {
        _chatCubit?.closeChat(chatId: _chatId!);
      }
      _userActivityCubit?.unsubscribeAction(chatId: _chatId!);
    }
  }

  void _resetAllDialogFlags() {
    _isDialogShowing = false;
    _isContinueProposalShown = false;
    _isWaitingDialogShown = false;
    _isPermanentChatDialogShown = false;
    _isTimerFinishedDialogShown = false;
    _isTimeOptionsDialogShown = false;
    _isAddTimeProposalDialogShown = false;
    _isExitConfirmationDialogShown = false;
  }

  void _handleChatMessageState(ChatMessageState state) {
    if (!mounted || _disposed) return;

    state.maybeMap(
      loaded: (state) {
        _scrollToBottom();
        _checkForContinueRequest(context, state);
      },
      orElse: () {},
    );
  }

  void _handleSyncTimerState(SyncTimerState state) {
    if (!mounted || _disposed) return;

    state.whenOrNull(
      addTimeProposed: (
        remainingTime,
        formattedTime,
        additionalMinutes,
        fromUserId,
      ) {
        _showAddTimeProposalDialog(additionalMinutes, fromUserId);
      },
      timeAdded: (additionalMinutes) {
        _showTimeAddedSnackBar(additionalMinutes);
      },
      timeRejected: () {
        _showTimeRejectedSnackBar();
      },
      finished: () {
        _showTimerFinishedDialog();
      },
      timeOptions: (remainingTime, formattedTime) {
        _showTimeOptionsDialog();
      },
    );
  }

  void _checkForContinueRequest(BuildContext context, ChatMessageState state) {
    if (!mounted || _disposed) return;

    state.maybeMap(
      loaded: (state) {
        if (state.showContinueProposal &&
            !state.isWaitingForResponse &&
            !_isContinueProposalShown) {
          _showContinueProposalDialog(state.agreeChatResponse);
        } else if (state.isWaitingForResponse && !_isWaitingDialogShown) {
          _showWaitingForResponseDialog();
        }
        if (state.agreeChatResponse?.permanentChatCreated == true &&
            !_isPermanentChatDialogShown) {
          _showPermanentChatCreatedDialog(state.agreeChatResponse!);
        }
      },
      orElse: () {},
    );
  }

  Future<void> _showDialog(
    Widget Function(BuildContext) builder, {
    bool barrierDismissible = true,
    required String dialogType,
  }) async {
    if (_isDialogShowing || !mounted || _disposed) return;

    switch (dialogType) {
      case 'continueProposal':
        if (_isContinueProposalShown) return;
        _isContinueProposalShown = true;
        break;
      case 'waiting':
        if (_isWaitingDialogShown) return;
        _isWaitingDialogShown = true;
        break;
      case 'permanentChat':
        if (_isPermanentChatDialogShown) return;
        _isPermanentChatDialogShown = true;
        break;
      case 'timerFinished':
        if (_isTimerFinishedDialogShown) return;
        _isTimerFinishedDialogShown = true;
        break;
      case 'timeOptions':
        if (_isTimeOptionsDialogShown) return;
        _isTimeOptionsDialogShown = true;
        break;
      case 'addTimeProposal':
        if (_isAddTimeProposalDialogShown) return;
        _isAddTimeProposalDialogShown = true;
        break;
      case 'exitConfirmation':
        if (_isExitConfirmationDialogShown) return;
        _isExitConfirmationDialogShown = true;
        break;
    }

    _isDialogShowing = true;
    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => builder(context),
    ).then((_) {
      if (mounted && !_disposed) {
        _isDialogShowing = false;
        switch (dialogType) {
          case 'continueProposal':
            _isContinueProposalShown = false;
            break;
          case 'waiting':
            _isWaitingDialogShown = false;
            break;
          case 'permanentChat':
            _isPermanentChatDialogShown = false;
            break;
          case 'timerFinished':
            _isTimerFinishedDialogShown = false;
            break;
          case 'timeOptions':
            _isTimeOptionsDialogShown = false;
            break;
          case 'addTimeProposal':
            _isAddTimeProposalDialogShown = false;
            break;
          case 'exitConfirmation':
            _isExitConfirmationDialogShown = false;
            break;
        }
      }
    });
  }

  void _showContinueProposalDialog(AgreeChatResponse? response) {
    _showDialog(
      (context) => AlertDialog(
        title: Text('${S.of(context).continue_communication}?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S
                  .of(context)
                  .the_interlocutor_suggests_continuing_the_conversation_in_a_permanent_chat,
            ),
            const SizedBox(height: 8),
            Text('${S.of(context).do_you_agree}?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _chatMessageCubit?.respondToContinueProposal(false);
              Navigator.of(context).pop();
            },
            child: Text(S.of(context).reject),
          ),
          ElevatedButton(
            onPressed: () {
              _chatMessageCubit?.respondToContinueProposal(true);
              Navigator.of(context).pop();
            },
            child: Text(S.of(context).accept),
          ),
        ],
      ),
      barrierDismissible: false,
      dialogType: 'continueProposal',
    );
  }

  void _showPermanentChatCreatedDialog(AgreeChatResponse response) {
    _showDialog(
      (context) => AlertDialog(
        title: Text(S.of(context).permanent_chat_has_been_created),
        content: Text(
          "${S.of(context).now_you_can_continue_chatting_in_a_permanent_chat_room}"
          "${S.of(context).all_messages_are_saved}",
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(S.of(context).continues),
          ),
        ],
      ),
      barrierDismissible: false,
      dialogType: 'permanentChat',
    );
  }

  void _showWaitingForResponseDialog() {
    _showDialog(
      (context) => AlertDialog(
        title: Text(S.of(context).waiting_for_a_response),
        content: Text(
          '${S.of(context).the_request_to_continue_the_chat_has_been_sent}'
          '${S.of(context).we_are_waiting_for_a_response_from_the_interlocutor}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              _chatMessageCubit?.hideContinueProposal();
              Navigator.of(context).pop();
            },
            child: Text(S.of(context).cancel),
          ),
        ],
      ),
      barrierDismissible: false,
      dialogType: 'waiting',
    );
  }

  void _showSendProposalDialog() {
    final messageController = TextEditingController();

    _showDialog(
      (context) => AlertDialog(
        title: Text(S.of(context).continue_communication),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              S
                  .of(context)
                  .do_you_want_to_invite_your_conversation_partner_to_continue_chatting_in_a_permanent_chat_room,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: S.of(context).do_you_want_to_send_an_optional_message,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(S.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () {
              _chatMessageCubit?.sendContinueProposal(messageController.text);
              Navigator.of(context).pop();
            },
            child: Text(S.of(context).offer),
          ),
        ],
      ),
      dialogType: 'sendProposal',
    );
  }

  void _showTimeOptionsDialog() {
    _showDialog(
      (context) => AlertDialog(
        title: Text(S.of(context).the_chat_time_is_coming_to_an_end),
        content: Text(S.of(context).select_an_action),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showAddTimeBottomSheet();
            },
            child: Text(S.of(context).add_time),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSendProposalDialog();
            },
            child: Text(S.of(context).continue_in_constant_chat),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showExitConfirmationDialog();
            },
            child: Text(S.of(context).end_the_chat),
          ),
        ],
      ),
      dialogType: 'timeOptions',
    );
  }

  void _showAddTimeBottomSheet() {
    if (!mounted || _timerCubit == null || _disposed || _isDialogShowing) {
      return;
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  S.of(context).add_time_to_the_chat,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TimeOption(
                      timerCubit: _timerCubit,
                      minutes: 1,

                      isDark: isDark,
                    ),
                    TimeOption(
                      timerCubit: _timerCubit,
                      minutes: 3,

                      isDark: isDark,
                    ),
                    TimeOption(
                      timerCubit: _timerCubit,
                      minutes: 5,

                      isDark: isDark,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: isDark ? Colors.black87 : Colors.white70,
                  ),
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      S.of(context).cancel,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
    );
  }

  void _showAddTimeProposalDialog(int additionalMinutes, String fromUserId) {
    _showDialog(
      (context) => AlertDialog(
        title: Text(S.of(context).suggestion_to_add_time),
        content: Text(
          '${S.of(context).the_interlocutor_suggests_adding} $additionalMinutes ${S.of(context).minutes_to_chat}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              _timerCubit?.respondToProposal(false, additionalMinutes);
              Navigator.of(context).pop();
            },
            child: Text(S.of(context).reject),
          ),
          ElevatedButton(
            onPressed: () {
              _timerCubit?.respondToProposal(true, additionalMinutes);
              Navigator.of(context).pop();
            },
            child: Text(S.of(context).to_accept),
          ),
        ],
      ),
      dialogType: 'addTimeProposal',
    );
  }

  void _showTimeAddedSnackBar(int additionalMinutes) {
    if (!mounted || _disposed) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${S.of(context).added} $additionalMinutes ${S.of(context).minutes_to_chat}',
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showTimeRejectedSnackBar() {
    if (!mounted || _disposed) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.of(context).the_suggestion_of_adding_time_is_rejected),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showTimerFinishedDialog() {
    _showDialog(
      (context) => AlertDialog(
        title: Text(S.of(context).times_up),
        content: Text(
          S.of(context).chat_time_has_expired_the_chat_will_be_terminated,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _onBackPressed();
            },
            child: Text(S.of(context).ok),
          ),
        ],
      ),
      barrierDismissible: false,
      dialogType: 'timerFinished',
    );
  }

  String _getChatRecipient({required String currentUserId}) {
    final chat = widget.chatModel!;
    return chat.user1Id == currentUserId ? chat.user2Id : chat.user1Id;
  }

  String _getTemporaryChatRecipient({required String currentUserId}) {
    final tempChat = widget.temporaryChatModel!;
    return tempChat.senderId == currentUserId
        ? tempChat.recipientId
        : tempChat.senderId;
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _disposed) return;
      if (!_scrollController.hasClients) return;

      final position = _scrollController.position;
      if (!position.hasContentDimensions) return;

      try {
        _scrollController.animateTo(
          position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } catch (e) {
        //
      }
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    final hasSelectedMedia = _mediaSelectionCubit?.hasSelectedMedia ?? false;

    if (text.isEmpty && !hasSelectedMedia) return;

    if (text.isNotEmpty) {
      _chatMessageCubit?.sendTextMessage(text);
    }
    if (hasSelectedMedia) {
      final selectedMedia = _mediaSelectionCubit?.state.selectedMedia ?? [];
      _chatMessageCubit?.sendMediaMessage(selectedMedia);
    }

    context.read<StickerCubit>().hideStickers();
    _messageController.clear();
    _mediaSelectionCubit?.clearMedia();
  }

  void _onBackPressed() {
    if (!mounted || _disposed) return;

    if (_chatId == null) {
      _navigateBack();
      return;
    }

    if (isTemporary) {
      _showExitConfirmationDialog();
    } else {
      _chatCubit?.closeChat(chatId: _chatId!);
      _navigateBack();
    }
  }

  void _navigateBack() {
    if (!mounted || _disposed) return;

    if (widget.onClose != null) {
      widget.onClose!();
    } else {
      context.router.pop();
    }
  }

  void _showExitConfirmationDialog() {
    _showDialog(
      (context) => AlertDialog(
        title: Text(S.of(context).finishTemporaryChat),
        content: Text(S.of(context).finishOrClose),
        actions: [
          TextButton(
            onPressed: () {
              _chatMessageCubit?.finishTempChat(
                temporaryModel: widget.temporaryChatModel!,
              );
              _chatCubit?.closeTempChat(tempChatId: _chatId!);
              _chatCubit?.deleteTemporaryChat(_chatId!, true);
              Navigator.of(context).pop();
              _navigateBack();
            },
            child: Text(S.of(context).finish),
          ),
          TextButton(
            onPressed: () {
              _chatCubit?.closeTempChat(tempChatId: _chatId!);
              Navigator.of(context).pop();
              _navigateBack();
            },
            child: Text(S.of(context).close),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(S.of(context).cancel),
          ),
        ],
      ),
      dialogType: 'exitConfirmation',
    );
  }

  void _showMediaPickerBottomSheet() {
    if (!mounted ||
        _mediaSelectionCubit == null ||
        _disposed ||
        _isDialogShowing) {
      return;
    }

    final isWeb = kIsWeb;
    final isDesktop =
        !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
    final isWebOrDesktop = isWeb || isDesktop;

    _isDialogShowing = true;
    _mediaSelectionCubit!.setPickerOpen(true);

    MediaPickerBottomSheet.open(
      context: context,
      initialSelection: _mediaSelectionCubit!.state.selectedMedia,
      maxSelection: 10,
      allowMultiple: true,
      showVideos: true,
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      showSelectionIndicators: true,
      config: const MediaPickerConfig(),
      mediaLibrary: DeviceMediaLibrary(),
      onSelectionChanged: (selectedItems) {
        _mediaSelectionCubit?.clearMedia();
        _mediaSelectionCubit?.addMedia(selectedItems);
      },
      onConfirmed:
          isWebOrDesktop
              ? null
              : (selectedItems) async {
                _mediaSelectionCubit?.clearMedia();
                final mediaItems = await _processMediaItemsForAndroidIOS(
                  selectedItems,
                );
                _mediaSelectionCubit?.addMedia(mediaItems);
                _mediaSelectionCubit?.setPickerOpen(false);
                if (mounted && !_disposed) {
                  _isDialogShowing = false;
                }
              },
      onConfirmedWithBytes:
          isWebOrDesktop
              ? (selectedItemsWithBytes) {
                _mediaSelectionCubit?.clearMedia();
                final mediaItems =
                    selectedItemsWithBytes
                        .map(
                          (entry) => _createMediaItem(entry.key, entry.value),
                        )
                        .toList();
                _mediaSelectionCubit?.addMedia(mediaItems);
                _mediaSelectionCubit?.setPickerOpen(false);
                if (mounted && !_disposed) {
                  _isDialogShowing = false;
                }
              }
              : null,
    ).then((_) {
      if (mounted && !_disposed) {
        _isDialogShowing = false;
      }
    });
  }

  Future<List<MediaItem>> _processMediaItemsForAndroidIOS(
    List<MediaItem> selectedItems,
  ) async {
    final mediaItems = <MediaItem>[];

    for (final mediaItem in selectedItems) {
      try {
        final bytes = await DeviceMediaLibrary().getFileBytes(mediaItem.uri);
        mediaItems.add(_createMediaItem(mediaItem, bytes));
      } catch (e) {
        mediaItems.add(_createMediaItem(mediaItem, null));
      }
    }

    return mediaItems;
  }

  MediaItem _createMediaItem(MediaItem originalItem, Uint8List? bytes) {
    final isVideo =
        originalItem.type.toLowerCase().contains('video') ||
        originalItem.uri.toLowerCase().endsWith('.mp4') ||
        originalItem.uri.toLowerCase().endsWith('.mov') ||
        originalItem.uri.toLowerCase().endsWith('.avi');

    return MediaItem(
      id: originalItem.id,
      name: originalItem.name,
      uri: originalItem.uri,
      dateAdded: originalItem.dateAdded,
      size: originalItem.size,
      width: originalItem.width,
      height: originalItem.height,
      albumId: originalItem.albumId,
      albumName: originalItem.albumName,
      type: isVideo ? 'video' : 'image',
      duration: originalItem.duration,
    );
  }

  void _showReportUserDialog() {
    if (!mounted || _disposed || _isDialogShowing) return;

    _isDialogShowing = true;
    final commentController = TextEditingController();
    final theme = Theme.of(context);
    String? selectedReason;

    showDialog(
      context: context,
      builder:
          (_) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: Text(S.of(context).reportuser),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S.of(context).reportuserdescription),
                        const SizedBox(height: 16),
                        Text(
                          S.of(context).selectreason,
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        RadioGroup<String>(
                          groupValue: selectedReason,
                          onChanged: (value) {
                            setState(() {
                              selectedReason = value;
                            });
                          },
                          child: Column(
                            children:
                                _getReportReasons()
                                    .map(
                                      (reason) => RadioListTile<String>(
                                        title: Text(reason),
                                        value: reason,
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            labelText: S.of(context).additionalcomments,
                            border: const OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (mounted && !_disposed) {
                          _isDialogShowing = false;
                        }
                      },
                      child: Text(S.of(context).cancel),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.error,
                        foregroundColor: theme.colorScheme.onError,
                      ),
                      onPressed: () {
                        if (selectedReason == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                S
                                    .of(context)
                                    .please_select_the_reason_for_the_complaint,
                              ),
                              backgroundColor: theme.colorScheme.error,
                            ),
                          );
                          return;
                        }
                        Navigator.pop(context);
                        if (mounted && !_disposed) {
                          _isDialogShowing = false;
                        }
                      },
                      child: Text(S.of(context).submitreport),
                    ),
                  ],
                ),
          ),
    ).then((_) {
      if (mounted && !_disposed) {
        _isDialogShowing = false;
      }
    });
  }

  List<String> _getReportReasons() {
    return [
      S.of(context).spam,
      S.of(context).harassment,
      S.of(context).inappropriatecontent,
      S.of(context).fakeprofile,
      S.of(context).other,
    ];
  }

  @override
  void dispose() {
    _disposed = true;
    _cleanup();
    _messageController.dispose();
    _scrollController.dispose();
    _chatCubit = null;
    _userActivityCubit = null;
    _chatMessageCubit = null;
    _socketService = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_mediaSelectionCubit == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_chatId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (senderID.isEmpty || recipientId.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (isTemporary && _timerCubit == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final currentUser = context.read<UserModelAppInterface>().user;
    if (currentUser == null) {
      return Scaffold(
        body: Center(child: Text(S.of(context).userNotAvailable)),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _onBackPressed();
      },
      child: Scaffold(
        body: BlocProvider.value(
          value: _mediaSelectionCubit!,
          child:
              isTemporary
                  ? BlocProvider.value(
                    value: _timerCubit!,
                    child: BuildScaffold(
                      currentUserId: currentUser.id,
                      onBackPressed: _onBackPressed,
                      isTemporary: isTemporary,
                      chatId: _chatId!,
                      senderID: senderID,
                      recipientId: recipientId,
                      messageController: _messageController,
                      sendMessage: _sendMessage,
                      scrollController: _scrollController,
                      chatModel: widget.chatModel,
                      onAddAttach: _showMediaPickerBottomSheet,
                      onContinueChat: _showSendProposalDialog,
                      onAddTimeChat: _showAddTimeBottomSheet,
                      onReportUser: _showReportUserDialog,
                    ),
                  )
                  : BuildScaffold(
                    currentUserId: currentUser.id,
                    onBackPressed: _onBackPressed,
                    isTemporary: isTemporary,
                    chatId: _chatId!,
                    senderID: senderID,
                    recipientId: recipientId,
                    messageController: _messageController,
                    sendMessage: _sendMessage,
                    scrollController: _scrollController,
                    chatModel: widget.chatModel,
                    onAddAttach: _showMediaPickerBottomSheet,
                    onContinueChat: _showSendProposalDialog,
                    onRequestFriend: () {
                      _chatMessageCubit?.friendRequest(
                        context: context,
                        toUserId: recipientId,
                      );
                    },
                    onReportUser: _showReportUserDialog,
                  ),
        ),
      ),
    );
  }
}
