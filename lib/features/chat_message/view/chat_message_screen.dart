import 'dart:async';

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat_message/cubit/chat/chat_message_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/user_activity/user_activity_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/chat_timer/chat_timer_cubit.dart';
import 'package:meet_now_app/features/chat_message/widget/widget.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/server/model/chat/chat.dart';
import 'package:meet_now_app/server/model/temporary/temporary_chat.dart';
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
  late ChatTimerCubit _timerCubit;

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
      _timerCubit = ChatTimerCubit(
        durationMinutes: widget.temporaryChatModel!.durationMinutes,
        onTimerFinished: () => Navigator.maybePop(context),
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
    state.maybeWhen(
      loaded: (messages, isLoadingMore) {
        if (isTemporary && messages.isEmpty) {
          _timerCubit.startModalTimer();
        }
      },
      orElse: () {},
    );
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

  void _showOneThirdModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).chatTimeEnding),
          content: Text(S.of(context).extendOrQuestionnaire),
          actions: [
            TextButton(
              onPressed: () {
                _timerCubit.addTime(3 * 60);
                Navigator.of(context).pop();
              },
              child: Text(S.of(context).add3Minutes),
            ),
            TextButton(
              onPressed: () {
                context.read<ChatMessageCubit>().friendRequest(
                  context: context,
                  toUserId: recipientId,
                );
                Navigator.of(context).pop();
              },
              child: Text(S.of(context).openQuestionnaire),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(S.of(context).close),
            ),
          ],
        );
      },
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
                child: BlocListener<ChatTimerCubit, ChatTimerState>(
                  listener: (context, state) {
                    state.maybeMap(
                      oneThirdReached: (_) => _showOneThirdModal(context),
                      orElse: () {},
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
              ),
    );
  }
}
