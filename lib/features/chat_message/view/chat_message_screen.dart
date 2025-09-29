import 'dart:async';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat_message/cubit/chat/chat_message_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/user_activity/user_activity_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/sync_timer/sync_timer_cubit.dart';
import 'package:meet_now_app/features/chat_message/widget/widget.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/server/model/chat/chat.dart';
import 'package:meet_now_app/server/model/temporary/temporary_chat.dart';
import 'package:meet_now_app/server/repository/timer/timer_repository.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';

@RoutePage()
class ChatMessageScreen extends StatefulWidget {
  const ChatMessageScreen({
    required this.temporaryChatModel,
    this.chatModel,
    super.key,
  });

  final TemporaryChat? temporaryChatModel;
  final Chat? chatModel;

  @override
  State<ChatMessageScreen> createState() => _ChatMessageScreenState();
}

class _ChatMessageScreenState extends State<ChatMessageScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  late StreamSubscription<ChatMessageState> _subscription;
  late String _chatId;

  bool isTemporary = false;
  String senderID = '';
  String recipientId = '';
  late SyncTimerCubit _timerCubit;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ChatMessageCubit>();
    final currentUser = context.read<UserModelAppInterface>().user;

    if (currentUser == null) throw Exception('Current user not available');

    senderID = currentUser.id;
    isTemporary = widget.chatModel == null;
    _chatId =
        isTemporary
            ? widget.temporaryChatModel!.tempChatId
            : widget.chatModel!.chatId;

    recipientId =
        isTemporary
            ? _getTemporaryChatRecipient(currentUserId: currentUser.id)
            : _getChatRecipient(currentUserId: currentUser.id);

    context.read<UserActivityCubit>().subscribeAction(chatId: _chatId);
    cubit.initialize(
      context: context,
      isTemporary: isTemporary,
      chatId: _chatId,
      senderId: senderID,
      recipientId: recipientId,
    );

    _subscription = cubit.stream.listen((state) {
      state.maybeMap(loaded: (_) => _scrollToBottom(), orElse: () {});
    });

    if (isTemporary) {
      _timerCubit = SyncTimerCubit(
        timerRepository: TimerRepository(userModelAppInterface: context.read<UserModelAppInterface>()),
        tempChatId: _chatId,
        userId: senderID,
        otherUserId: recipientId,
      );
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    if (isTemporary) {
      _timerCubit.close();
    }
    super.dispose();
  }

  void _checkForModal(BuildContext context, ChatMessageState state) {
  }

  String _getChatRecipient({required String currentUserId}) {
    final chat = widget.chatModel!;
    return chat.user1.id == currentUserId ? chat.user2.id : chat.user1.id;
  }

  String _getTemporaryChatRecipient({required String currentUserId}) {
    final tempChat = widget.temporaryChatModel!;
    return tempChat.senderId == currentUserId
        ? tempChat.recipientId
        : tempChat.senderId;
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    context.read<ChatMessageCubit>().sendTextMessage(text);
    _messageController.clear();
  }

  void _onBackPressed() {
    if (isTemporary) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text(S.of(context).finishTemporaryChat),
              content: Text(S.of(context).finishOrClose),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.router.pop();
                  },
                  child: Text(S.of(context).finish),
                ),
                TextButton(
                  onPressed: () {
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
    } else {
      context.router.pop();
    }
  }

  void _showAddTimeProposalDialog(
    BuildContext context,
    int additionalMinutes,
    String fromUserId,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Предложение добавить время'),
          content: Text(
            'Собеседник предлагает добавить $additionalMinutes минут к чату.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                _timerCubit.respondToProposal(false, additionalMinutes);
                Navigator.of(context).pop();
              },
              child: const Text('Отклонить'),
            ),
            ElevatedButton(
              onPressed: () {
                _timerCubit.respondToProposal(true, additionalMinutes);
                Navigator.of(context).pop();
              },
              child: const Text('Принять'),
            ),
          ],
        );
      },
    );
  }

  void _showTimeAddedDialog(BuildContext context, int additionalMinutes) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Добавлено $additionalMinutes минут к чату'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showTimeRejectedDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Предложение добавления времени отклонено'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showTimerFinishedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('Время вышло'),
            content: const Text('Время чата истекло. Чат будет завершен.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.router.pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUserId = context.read<UserModelAppInterface>().user!.id;

    return BlocListener<ChatMessageCubit, ChatMessageState>(
      listener: (context, state) {
        _checkForModal(context, state);
      },
      child:
          isTemporary
              ? BlocProvider.value(
                value: _timerCubit,
                child: BlocListener<SyncTimerCubit, SyncTimerState>(
                  listener: (context, state) {
                    state.whenOrNull(
                      addTimeProposed: (
                        remainingTime,
                        formattedTime,
                        additionalMinutes,
                        fromUserId,
                      ) {
                        _showAddTimeProposalDialog(
                          context,
                          additionalMinutes,
                          fromUserId,
                        );
                      },
                      timeAdded: (additionalMinutes) {
                        _showTimeAddedDialog(context, additionalMinutes);
                      },
                      timeRejected: () {
                        _showTimeRejectedDialog(context);
                      },
                      finished: () {
                        _showTimerFinishedDialog(context);
                      },
                    );
                  },
                  child: BuildScaffold(
                    theme: theme,
                    currentUserId: currentUserId,
                    onBackPressed: _onBackPressed,
                    isTemporary: isTemporary,
                    chatId: _chatId,
                    senderID: senderID,
                    recipientId: recipientId,
                    messageController: _messageController,
                    sendMessage: _sendMessage,
                    scrollController: _scrollController,
                    chatModel: widget.chatModel,
                  ),
                ),
              )
              : BuildScaffold(
                theme: theme,
                currentUserId: currentUserId,
                onBackPressed: _onBackPressed,
                isTemporary: isTemporary,
                chatId: _chatId,
                senderID: senderID,
                recipientId: recipientId,
                messageController: _messageController,
                sendMessage: _sendMessage,
                scrollController: _scrollController,
                chatModel: widget.chatModel,
              ),
    );
  }
}
