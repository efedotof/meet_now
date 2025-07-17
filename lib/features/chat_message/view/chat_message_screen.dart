import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat_message/cubit/chat_message_cubit.dart';
import 'package:meet_now_app/features/chat_message/widget/widget.dart';
import 'package:meet_now_app/server/model/chat/chat.dart';
import 'package:meet_now_app/server/model/message/message.dart';
import 'package:meet_now_app/server/model/temporary/temporary_chat.dart';

@RoutePage()
class ChatMessageScreen extends StatefulWidget {
  const ChatMessageScreen({
    required this.chatModel,
    required this.temporaryChatModel,
    super.key,
  });

  final TemporaryChat temporaryChatModel;
  final Chat? chatModel;

  @override
  State<ChatMessageScreen> createState() => _ChatMessageScreenState();
}

class _ChatMessageScreenState extends State<ChatMessageScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatMessageCubit>().connect(
      widget.temporaryChatModel.senderId,
      widget.temporaryChatModel.tempChatId,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    context.read<ChatMessageCubit>().disconnect();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    final message = Message(
      text: text,
      senderId: widget.temporaryChatModel.senderId,
      chatId: widget.temporaryChatModel.tempChatId,
      recipientId: widget.temporaryChatModel.recipientId,
    );

    context.read<ChatMessageCubit>().sendMessage(message);
    _messageController.clear();
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(chatModel: widget.chatModel),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatMessageCubit, ChatMessageState>(
              builder: (context, state) {
                final messages = state.maybeWhen<List<Message>>(
                  loaded: (msgs) => msgs,
                  orElse: () => [],
                );

                return MessagesList(
                  messages: messages,
                  scrollController: _scrollController,
                  currentUserId: widget.temporaryChatModel.senderId,
                );
              },
            ),
          ),
          InputArea(controller: _messageController, onSend: _sendMessage),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed:
      //       () => context.read<ChatMessageCubit>().getMessages(
      //         widget.temporaryChatModel.tempChatId,
      //       ),
      // ),
    );
  }
}
