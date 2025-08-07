import 'dart:async';

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat_message/cubit/chat/chat_message_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/user_activity/user_activity_cubit.dart';
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
  bool _isModalShown = false;
  Timer? _modalTimer;
  int _secondsRemaining = 30;

  Timer? _countdownTimer;
  int _remainingSeconds = 0;
  int _totalSeconds = 0;
  bool _isOneThirdModalShown = false;

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
      _totalSeconds = widget.temporaryChatModel!.durationMinutes * 60;
      _remainingSeconds = _totalSeconds;
      _startCountdownTimer();
    }
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
        if (!_isOneThirdModalShown && _remainingSeconds <= _totalSeconds ~/ 3) {
          _isOneThirdModalShown = true;
          if (mounted) {
            _showOneThirdModal(context);
          }
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _showModal(BuildContext context) {
    _isModalShown = true;
    _secondsRemaining = 30;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: Text(S.of(context).stopThink),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                Text(
                  "${S.of(context).timerSeconds} $_secondsRemaining ${S.of(context).seconds}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                const CircularProgressIndicator(),
              ],
            ),
            actions: [
              TextButton(
                onPressed:
                    _secondsRemaining <= 0
                        ? () => Navigator.of(context).pop()
                        : null,
                child: Text(S.of(context).continues),
              ),
            ],
          ),
        );
      },
    );

    _modalTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          timer.cancel();
          Navigator.of(context).pop();
        }
      });
    });
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
                setState(() {
                  _remainingSeconds += 3 * 60;
                  _totalSeconds += 3 * 60;
                });
                Navigator.of(context).pop();
              },
              child: Text(S.of(context).add3Minutes),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(S.of(context).openQuestionnaire),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(S.of(context).close),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    _modalTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _checkForModal(BuildContext context, ChatMessageState state) {
    state.maybeWhen(
      loaded: (messages, isLoadingMore) {
        if (isTemporary && messages.isEmpty && !_isModalShown) {
          _showModal(context);
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUserId = context.read<UserModelAppInterface>().user!.id;

    return BlocListener<ChatMessageCubit, ChatMessageState>(
      listener: (context, state) {
        _checkForModal(context, state);
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBarWidget(
          chatModel: widget.chatModel,
          userId: currentUserId,
          onBackPressed: _onBackPressed,
          isTemporary: isTemporary,
          remainingSeconds: isTemporary ? _remainingSeconds : null,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.surface,
                theme.colorScheme.surface,
                theme.colorScheme.surfaceContainerHighest,
              ],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<ChatMessageCubit, ChatMessageState>(
                  builder: (context, state) {
                    final cubit = context.read<ChatMessageCubit>();

                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: state.when(
                        initial: () => const LoadingMessages(),
                        loading: () => const LoadingMessages(),
                        error:
                            (message) => ErrorMessage(
                              message: message,
                              onRetry:
                                  () => cubit.reconnect(
                                    context: context,
                                    isTemporary: isTemporary,
                                    chatId: _chatId,
                                    senderId: senderID,
                                    recipientId: recipientId,
                                  ),
                            ),
                        loaded:
                            (messages, isLoadingMore) => Column(
                              children: [
                                if (isLoadingMore)
                                  const LinearProgressIndicator(
                                    minHeight: 2,
                                    color: Colors.blueAccent,
                                  ),
                                Expanded(
                                  child: MessagesList(
                                    messages: messages,
                                    scrollController: _scrollController,
                                    currentUserId: currentUserId,
                                  ),
                                ),
                              ],
                            ),
                      ),
                    );
                  },
                ),
              ),
              InputArea(
                controller: _messageController,
                onSend: _sendMessage,
                onCommandResult: (result) {
                  context.read<ChatMessageCubit>().sendTextMessage(result);
                },
                chatId: _chatId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
