import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  });

  final TemporaryChat? temporaryChatModel;
  final PermanentChatResponseDto? chatModel;

  @override
  State<ChatMessageScreen> createState() => _ChatMessageScreenState();
}

class _ChatMessageScreenState extends State<ChatMessageScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  StreamSubscription<ChatMessageState>? _subscription;
  StreamSubscription<SyncTimerState>? _timerSubscription;
  SyncTimerCubit? _timerCubit;
  MediaSelectionCubit? _mediaSelectionCubit;
  String? _chatId;
  bool isTemporary = false;
  String senderID = '';
  String recipientId = '';
  bool _isDialogShowing = false;

  @override
  void initState() {
    super.initState();

    _mediaSelectionCubit = MediaSelectionCubit();

    if (widget.chatModel != null) {
      _chatId = widget.chatModel!.chatId;
      isTemporary = false;
    } else if (widget.temporaryChatModel != null) {
      _chatId = widget.temporaryChatModel!.tempChatId;
      isTemporary = true;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeChat();
    });
  }

  void _initializeChat() {
    if (!mounted) return;

    try {
      final currentUser = context.read<UserModelAppInterface>().user;
      if (currentUser == null) {
        debugPrint('Current user not available');
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

      if (_chatId == null) {
        debugPrint('Chat ID is null');
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

      final cubit = context.read<ChatMessageCubit>();
      senderID = currentUser.id;

      recipientId =
          isTemporary
              ? _getTemporaryChatRecipient(currentUserId: currentUser.id)
              : _getChatRecipient(currentUserId: currentUser.id);

      context.read<UserActivityCubit>().subscribeAction(chatId: _chatId!);

      cubit.initialize(
        context: context,
        isTemporary: isTemporary,
        chatId: _chatId!,
        senderId: senderID,
        recipientId: recipientId,
      );

      _subscription = cubit.stream.listen(_handleChatMessageState);

      if (isTemporary) {
        final totalTime = widget.temporaryChatModel!.durationMinutes * 60;
        _timerCubit = SyncTimerCubit(
          timerRepository: TimerRepository(
            socketService: context.read<SocketServiceInterface>(),
          ),
          tempChatId: _chatId!,
          userId: senderID,
          totalTime: totalTime,
        );

        _timerSubscription = _timerCubit?.stream.listen(_handleSyncTimerState);
      }

      if (mounted) setState(() {});
    } catch (e, stackTrace) {
      debugPrint('Error initializing chat: $e\n$stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${S.of(context).error_initializing_chat}: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _handleChatMessageState(ChatMessageState state) {
    if (!mounted) return;

    state.maybeMap(
      loaded: (state) {
        _scrollToBottom();
        _checkForContinueRequest(context, state);
      },
      orElse: () {},
    );
  }

  void _handleSyncTimerState(SyncTimerState state) {
    if (!mounted || _isDialogShowing) return;

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
    if (!mounted) return;

    state.maybeMap(
      loaded: (state) {
        if (state.showContinueRequest && !state.isWaitingForResponse) {
          _showContinueChatDialog(state.agreeChatResponse);
        } else if (state.isWaitingForResponse) {
          _showWaitingForResponseDialog();
        }
        if (state.agreeChatResponse?.permanentChatCreated == true) {
          _showPermanentChatCreatedDialog(state.agreeChatResponse!);
        }
      },
      orElse: () {},
    );
  }

  Future<void> _showDialog(
    Widget Function(BuildContext) builder, {
    bool barrierDismissible = true,
  }) async {
    if (_isDialogShowing || !mounted) return;

    _isDialogShowing = true;
    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => builder(context),
    );
    _isDialogShowing = false;
  }

  void _showContinueChatDialog(AgreeChatResponse? response) {
    _showDialog(
      (context) => AlertDialog(
        title: Text('${S.of(context).continue_communication}?'),
        content: Text(
          ' ${S.of(context).the_interlocutor_suggests_continuing_the_conversation_in_a_permanent_chat}'
          '${S.of(context).do_you_agree} ?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<ChatMessageCubit>().respondToContinueRequest(false);
              Navigator.of(context).pop();
            },
            child: Text(S.of(context).reject),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ChatMessageCubit>().respondToContinueRequest(true);
              Navigator.of(context).pop();
            },
            child: Text(S.of(context).accept),
          ),
        ],
      ),
      barrierDismissible: false,
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
              context.read<ChatMessageCubit>().hideContinueRequest();
              Navigator.of(context).pop();
            },
            child: Text(S.of(context).cancel),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _showContinueChatProposalDialog() {
    _showDialog(
      (context) => AlertDialog(
        title: Text(S.of(context).continue_communication),
        content: Text(
          S
              .of(context)
              .do_you_want_to_invite_your_conversation_partner_to_continue_chatting_in_a_permanent_chat_room,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(S.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ChatMessageCubit>().sendContinueRequest();
              Navigator.of(context).pop();
            },
            child: Text(S.of(context).offer),
          ),
        ],
      ),
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
              _showContinueChatProposalDialog();
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
    );
  }

  void _showAddTimeBottomSheet() {
    if (!mounted || _timerCubit == null) return;

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
                    GestureDetector(
                      onTap: () {
                        _timerCubit?.proposeAddTime(1);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.black87 : Colors.white70,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(10),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withAlpha(10),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.access_time,
                                size: 18,
                                color: theme.colorScheme.primary,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              '1 ${S.of(context).mines}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),

                            Text(
                              S.of(context).mines,
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _timerCubit?.proposeAddTime(3);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.black87 : Colors.white70,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(10),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withAlpha(10),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.access_time,
                                size: 18,
                                color: theme.colorScheme.primary,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              '3 ${S.of(context).mines}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),

                            Text(
                              S.of(context).mines,
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _timerCubit?.proposeAddTime(5);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.black87 : Colors.white70,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(10),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withAlpha(10),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.access_time,
                                size: 18,
                                color: theme.colorScheme.primary,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              '5 ${S.of(context).mines}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),

                            Text(
                              S.of(context).mines,
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
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
    );
  }

  void _showTimeAddedSnackBar(int additionalMinutes) {
    if (!mounted) return;

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
    if (!mounted) return;

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
              context.router.pop();
            },
            child: Text(S.of(context).ok),
          ),
        ],
      ),
      barrierDismissible: false,
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
      if (!mounted || !_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    final hasSelectedMedia = _mediaSelectionCubit?.hasSelectedMedia ?? false;

    if (text.isEmpty && !hasSelectedMedia) return;

    if (text.isNotEmpty) {
      context.read<ChatMessageCubit>().sendTextMessage(text);
    }
    if (hasSelectedMedia) {
      final selectedMedia = _mediaSelectionCubit?.state.selectedMedia ?? [];
      context.read<ChatMessageCubit>().sendMediaMessage(selectedMedia);
    }

    context.read<StickerCubit>().hideStickers();
    _messageController.clear();
    _mediaSelectionCubit?.clearMedia();
  }

  void _onBackPressed() {
    if (_chatId == null) {
      context.router.pop();
      return;
    }

    if (isTemporary) {
      _showExitConfirmationDialog();
    } else {
      context.read<ChatCubit>().closeChat(chatId: _chatId!);
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
              context.read<ChatMessageCubit>().finishTempChat(
                temporaryModel: widget.temporaryChatModel!,
              );
              context.read<ChatCubit>().closeTempChat(tempChatId: _chatId!);
              context.read<ChatCubit>().deleteTemporaryChat(_chatId!, true);
              Navigator.of(context).pop();
              context.router.pop();
            },
            child: Text(S.of(context).finish),
          ),
          TextButton(
            onPressed: () {
              context.read<ChatCubit>().closeTempChat(tempChatId: _chatId!);
              Navigator.of(context).pop();
              context.router.pop();
            },
            child: Text(S.of(context).close),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(S.of(context).cancel),
          ),
        ],
      ),
    );
  }

  void _showMediaPickerBottomSheet() {
    if (!mounted || _mediaSelectionCubit == null) return;

    _mediaSelectionCubit!.setPickerOpen(true);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => MediaPickerBottomSheet(
            initialSelection: _mediaSelectionCubit!.state.selectedMedia,
            maxSelection: 10,
            allowMultiple: true,
            showVideos: true,
            initialChildSize: 0.7,
            minChildSize: 0.4,
            showSelectionIndicators: true,
            maxChildSize: 0.9,
            onSelectionChanged: (selectedItems) {
              _mediaSelectionCubit?.clearMedia();
              _mediaSelectionCubit?.addMedia(selectedItems);
            },
            onConfirmed: (selectedItemsWithBytes) {
              _mediaSelectionCubit?.clearMedia();
              final mediaItems =
                  selectedItemsWithBytes.map((entry) {
                    final isVideo =
                        entry.key.toLowerCase().endsWith('.mp4') ||
                        entry.key.toLowerCase().endsWith('.mov') ||
                        entry.key.toLowerCase().endsWith('.avi');

                    return MediaItem(
                      id: entry.key,
                      name: entry.key.split('/').last,
                      uri: entry.key,
                      dateAdded: DateTime.now().millisecondsSinceEpoch,
                      size: entry.value.length,
                      width: 0,
                      height: 0,
                      albumId: '',
                      albumName: '',
                      type: isVideo ? 'video' : 'image',
                      duration: isVideo ? 0 : null,
                      thumbnail: entry.value,
                    );
                  }).toList();

              _mediaSelectionCubit?.addMedia(mediaItems);
              _mediaSelectionCubit?.setPickerOpen(false);
            },
          ),
    ).whenComplete(() {
      _mediaSelectionCubit?.setPickerOpen(false);
    });
  }

  // void _showReportUserDialog() {
  //   if (!mounted) return;

  //   final commentController = TextEditingController();
  //   final theme = Theme.of(context);
  //   String? selectedReason;

  //   showDialog(
  //     context: context,
  //     builder:
  //         (_) => StatefulBuilder(
  //           builder:
  //               (context, setState) => AlertDialog(
  //                 title: Text(S.of(context).reportuser),
  //                 content: SingleChildScrollView(
  //                   child: Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(S.of(context).reportuserdescription),
  //                       const SizedBox(height: 16),
  //                       Text(
  //                         S.of(context).selectreason,
  //                         style: theme.textTheme.titleSmall,
  //                       ),
  //                       const SizedBox(height: 8),
  //                       ..._getReportReasons().map(
  //                         (reason) => RadioListTile<String>(
  //                           title: Text(reason),
  //                           value: reason,
  //                           groupValue: selectedReason,
  //                           onChanged: (value) {
  //                             setState(() {
  //                               selectedReason = value;
  //                             });
  //                           },
  //                         ),
  //                       ),
  //                       const SizedBox(height: 8),
  //                       TextField(
  //                         controller: commentController,
  //                         decoration: InputDecoration(
  //                           labelText: S.of(context).additionalcomments,
  //                           border: const OutlineInputBorder(),
  //                         ),
  //                         maxLines: 3,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 actions: [
  //                   TextButton(
  //                     onPressed: () => Navigator.pop(context),
  //                     child: Text(S.of(context).cancel),
  //                   ),
  //                   ElevatedButton(
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: theme.colorScheme.error,
  //                       foregroundColor: theme.colorScheme.onError,
  //                     ),
  //                     onPressed: () {
  //                       if (selectedReason == null) {
  //                         ScaffoldMessenger.of(context).showSnackBar(
  //                           SnackBar(
  //                             content: Text(
  //                               S
  //                                   .of(context)
  //                                   .please_select_the_reason_for_the_complaint,
  //                             ),
  //                             backgroundColor: theme.colorScheme.error,
  //                           ),
  //                         );
  //                         return;
  //                       }
  //                       Navigator.pop(context);
  //                     },
  //                     child: Text(S.of(context).submitreport),
  //                   ),
  //                 ],
  //               ),
  //         ),
  //   );
  // }

  // List<String> _getReportReasons() {
  //   return [
  //     S.of(context).spam,
  //     S.of(context).harassment,
  //     S.of(context).inappropriatecontent,
  //     S.of(context).fakeprofile,
  //     S.of(context).other,
  //   ];
  // }

  @override
  void dispose() {
    _subscription?.cancel();
    _timerSubscription?.cancel();
    _timerCubit?.close();
    _messageController.dispose();
    _scrollController.dispose();
    _mediaSelectionCubit?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_mediaSelectionCubit == null) {
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

    return Scaffold(
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
                    onContinueChat: _showContinueChatProposalDialog,
                    onAddTimeChat: _showAddTimeBottomSheet,
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
                  onContinueChat: _showContinueChatProposalDialog,
                  onRequestFriend: () {
                    context.read<ChatMessageCubit>().friendRequest(
                      context: context,
                      toUserId: recipientId,
                    );
                  },
                ),
      ),
    );
  }
}
