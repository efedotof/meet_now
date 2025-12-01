// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:meet_now_app_server/meet_now_app_server.dart';
// import 'package:meet_now_app/features/chat_message/cubit/chat/chat_message_cubit.dart';
// import 'package:meet_now_app/features/chat_message/cubit/sticker/sticker_cubit.dart';
// import 'package:meet_now_app/features/chat_message/cubit/user_activity/user_activity_cubit.dart';
// import 'package:meet_now_app/features/chat_message/cubit/sync_timer/sync_timer_cubit.dart';
// import 'package:meet_now_app/features/chat_message/cubit/media_selection/media_selection_cubit.dart';
// import 'package:meet_now_app/features/chat_message/widget/widget.dart';
// import 'package:meet_now_app/generated/l10n.dart';

// @RoutePage()
// class ChatMessageScreen extends StatefulWidget {
//   const ChatMessageScreen({
// required this.temporaryChatModel,
// this.chatModel,
//     super.key,
//   });

// final TemporaryChat? temporaryChatModel;
// final PermanentChatResponseDto? chatModel;

//   @override
//   State<ChatMessageScreen> createState() => _ChatMessageScreenState();
// }

// class _ChatMessageScreenState extends State<ChatMessageScreen> {
// final _messageController = TextEditingController();
// final _scrollController = ScrollController();
// late StreamSubscription<ChatMessageState> _subscription;
// late String _chatId;

// bool isTemporary = false;
// String senderID = '';
// String recipientId = '';
// late SyncTimerCubit _timerCubit;
// late MediaSelectionCubit _mediaSelectionCubit;

//   @override
//   void initState() {
//     super.initState();
//     final cubit = context.read<ChatMessageCubit>();
//     final currentUser = context.read<UserModelAppInterface>().user;

//     if (currentUser == null) throw Exception('Current user not available');

//     senderID = currentUser.id;
//     isTemporary = widget.chatModel == null;
//     _chatId =
//         isTemporary
//             ? widget.temporaryChatModel!.tempChatId
//             : widget.chatModel!.chatId;

//     recipientId =
//         isTemporary
//             ? _getTemporaryChatRecipient(currentUserId: currentUser.id)
//             : _getChatRecipient(currentUserId: currentUser.id);

//     context.read<UserActivityCubit>().subscribeAction(chatId: _chatId);
//     cubit.initialize(
//       context: context,
//       isTemporary: isTemporary,
//       chatId: _chatId,
//       senderId: senderID,
//       recipientId: recipientId,
//     );

//     _mediaSelectionCubit = MediaSelectionCubit();

//     _subscription = cubit.stream.listen((state) {
//       state.maybeMap(
//         loaded: (state) {
//           _scrollToBottom();
//           _checkForContinueRequest(context, state);
//         },
//         orElse: () {},
//       );
//     });

//     if (isTemporary) {
//       final totalTime = widget.temporaryChatModel!.durationMinutes * 60;

//       _timerCubit = SyncTimerCubit(
//         timerRepository: TimerRepository(
//           socketService: context.read<SocketServiceInterface>(),
//         ),
//         tempChatId: _chatId,
//         userId: senderID,
//         totalTime: totalTime,
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _subscription.cancel();
//     _messageController.dispose();
//     _scrollController.dispose();
//     _mediaSelectionCubit.close();
//     if (isTemporary) {
//       _timerCubit.close();
//     }
//     super.dispose();
//   }

//   void _checkForContinueRequest(BuildContext context, ChatMessageState state) {
//     state.maybeMap(
//       loaded: (state) {
//         if (state.showContinueRequest && !state.isWaitingForResponse) {
//           _showContinueChatDialog(context, state.agreeChatResponse);
//         } else if (state.isWaitingForResponse) {
//           _showWaitingForResponseDialog(context);
//         }
//         if (state.agreeChatResponse?.permanentChatCreated == true) {
//           _showPermanentChatCreatedDialog(context, state.agreeChatResponse!);
//         }
//       },
//       orElse: () {},
//     );
//   }

//   void _showContinueChatDialog(
//     BuildContext context,
//     AgreeChatResponse? response,
//   ) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder:
//           (context) => AlertDialog(
//             title: const Text('Продолжить общение?'),
//             content: const Text(
//               'Собеседник предлагает продолжить общение в постоянном чате. '
//               'Вы согласны?',
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   context.read<ChatMessageCubit>().respondToContinueRequest(
//                     false,
//                   );
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('Отклонить'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   context.read<ChatMessageCubit>().respondToContinueRequest(
//                     true,
//                   );
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('Принять'),
//               ),
//             ],
//           ),
//     );
//   }

//   void _showPermanentChatCreatedDialog(
//     BuildContext context,
//     AgreeChatResponse response,
//   ) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder:
//           (context) => AlertDialog(
//             title: const Text('Постоянный чат создан'),
//             content: const Text(
//               'Теперь вы можете продолжить общение в постоянном чате. '
//               'Все сообщения сохранены.',
//             ),
//             actions: [
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('Продолжить'),
//               ),
//             ],
//           ),
//     );
//   }

//   void _showWaitingForResponseDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder:
//           (context) => AlertDialog(
//             title: const Text('Ожидание ответа'),
//             content: const Text(
//               'Запрос на продолжение чата отправлен. '
//               'Ожидаем ответа от собеседника...',
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   context.read<ChatMessageCubit>().hideContinueRequest();
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('Отменить'),
//               ),
//             ],
//           ),
//     );
//   }

//   void _showContinueChatProposalDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             title: const Text('Продолжить общение?'),
//             content: const Text(
//               'Хотите предложить собеседнику продолжить общение в постоянном чате?',
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: const Text('Отмена'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   context.read<ChatMessageCubit>().sendContinueRequest();
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('Предложить'),
//               ),
//             ],
//           ),
//     );
//   }

//   void _showTimeOptionsDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder:
//           (context) => AlertDialog(
//             title: const Text('Время чата подходит к концу'),
//             content: const Text('Выберите действие:'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   _showAddTimeBottomSheet(context);
//                 },
//                 child: const Text('Добавить время'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   _showContinueChatProposalDialog(context);
//                 },
//                 child: const Text('Продолжить в постоянном чате'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   _showExitConfirmationDialog();
//                 },
//                 child: const Text('Завершить чат'),
//               ),
//             ],
//           ),
//     );
//   }

//   void _showAddTimeBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder:
//           (context) => Container(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text(
//                   'Добавить время к чату:',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         _timerCubit.proposeAddTime(1);
//                         Navigator.of(context).pop();
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         foregroundColor: Colors.white,
//                       ),
//                       child: const Text('1 мин'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         _timerCubit.proposeAddTime(3);
//                         Navigator.of(context).pop();
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         foregroundColor: Colors.white,
//                       ),
//                       child: const Text('3 мин'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         _timerCubit.proposeAddTime(5);
//                         Navigator.of(context).pop();
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         foregroundColor: Colors.white,
//                       ),
//                       child: const Text('5 мин'),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('Отмена'),
//                 ),
//               ],
//             ),
//           ),
//     );
//   }

//   String _getChatRecipient({required String currentUserId}) {
//     final chat = widget.chatModel!;
//     return chat.user1Id == currentUserId ? chat.user2Id : chat.user1Id;
//   }

//   String _getTemporaryChatRecipient({required String currentUserId}) {
//     final tempChat = widget.temporaryChatModel!;
//     return tempChat.senderId == currentUserId
//         ? tempChat.recipientId
//         : tempChat.senderId;
//   }

//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   void _sendMessage() {
//     final text = _messageController.text.trim();
//     final hasSelectedMedia = _mediaSelectionCubit.hasSelectedMedia;

//     if (text.isEmpty && !hasSelectedMedia) return;

//     if (text.isNotEmpty) {
//       context.read<ChatMessageCubit>().sendTextMessage(text);
//     }
//     if (hasSelectedMedia) {
//       final selectedMedia = _mediaSelectionCubit.state.selectedMedia;
//       debugPrint('Sending ${selectedMedia.length} media files');
//     }

//     context.read<StickerCubit>().hideStickers();
//     _messageController.clear();
//     _mediaSelectionCubit.clearMedia();
//   }

//   void _onBackPressed() {
//     if (isTemporary) {
//       _showExitConfirmationDialog();
//     } else {
//       context.router.pop();
//     }
//   }

//   void _showExitConfirmationDialog() {
//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             title: Text(S.of(context).finishTemporaryChat),
//             content: Text(S.of(context).finishOrClose),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   context.router.pop();
//                 },
//                 child: Text(S.of(context).finish),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   context.router.pop();
//                 },
//                 child: Text(S.of(context).close),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: Text(S.of(context).cancel),
//               ),
//             ],
//           ),
//     );
//   }

//   void _showAddTimeProposalDialog(
//     BuildContext context,
//     int additionalMinutes,
//     String fromUserId,
//   ) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Предложение добавить время'),
//           content: Text(
//             'Собеседник предлагает добавить $additionalMinutes минут к чату.',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 _timerCubit.respondToProposal(false, additionalMinutes);
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Отклонить'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 _timerCubit.respondToProposal(true, additionalMinutes);
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Принять'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showTimeAddedDialog(BuildContext context, int additionalMinutes) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Добавлено $additionalMinutes минут к чату'),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   void _showTimeRejectedDialog(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Предложение добавления времени отклонено'),
//         duration: Duration(seconds: 3),
//       ),
//     );
//   }

//   void _showMediaPickerBottomSheet() {
//     _mediaSelectionCubit.setPickerOpen(true);

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder:
//           (context) => MediaPickerBottomSheet(
//             initialSelection: _mediaSelectionCubit.state.selectedMedia,
//             maxSelection: 10,
//             allowMultiple: true,
//             showVideos: true,
//             initialChildSize: 0.7,
//             minChildSize: 0.4,
//             showSelectionIndicators: true,
//             maxChildSize: 0.9,
//             onSelectionChanged: (selectedItems) {
//               _mediaSelectionCubit.clearMedia();
//               _mediaSelectionCubit.addMedia(selectedItems);
//             },
//             onConfirmed: (selectedItems) {
//               _mediaSelectionCubit.clearMedia();
//               _mediaSelectionCubit.addMedia(selectedItems);
//               _mediaSelectionCubit.setPickerOpen(false);
//               debugPrint(
//                 'Bottom sheet selection: ${selectedItems.length} items',
//               );
//             },
//           ),
//     ).whenComplete(() {
//       _mediaSelectionCubit.setPickerOpen(false);
//     });
//   }

//   void _showTimerFinishedDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder:
//           (context) => AlertDialog(
//             title: const Text('Время вышло'),
//             content: const Text('Время чата истекло. Чат будет завершен.'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   context.router.pop();
//                 },
//                 child: const Text('OK'),
//               ),
//             ],
//           ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final currentUserId = context.read<UserModelAppInterface>().user!.id;

// return BlocProvider.value(
//   value: _mediaSelectionCubit,
//   child: BlocListener<ChatMessageCubit, ChatMessageState>(
//     listener: (context, state) {
//       state.maybeMap(
//         loaded: (state) => _checkForContinueRequest(context, state),
//         orElse: () {},
//       );
//     },
//     child:
//         isTemporary
//             ? BlocProvider.value(
//               value: _timerCubit,
//               child: BlocListener<SyncTimerCubit, SyncTimerState>(
//                 listener: (context, state) {
//                   state.whenOrNull(
//                     addTimeProposed: (
//                       remainingTime,
//                       formattedTime,
//                       additionalMinutes,
//                       fromUserId,
//                     ) {
//                       _showAddTimeProposalDialog(
//                         context,
//                         additionalMinutes,
//                         fromUserId,
//                       );
//                     },
//                     timeAdded: (additionalMinutes) {
//                       _showTimeAddedDialog(context, additionalMinutes);
//                     },
//                     timeRejected: () {
//                       _showTimeRejectedDialog(context);
//                     },
//                     finished: () {
//                       _showTimerFinishedDialog();
//                     },
//                     timeOptions: (remainingTime, formattedTime) {
//                       _showTimeOptionsDialog(context);
//                     },
//                   );
//                 },
// child: BuildScaffold(
//   theme: theme,
//   currentUserId: currentUserId,
//   onBackPressed: _onBackPressed,
//   isTemporary: isTemporary,
//   chatId: _chatId,
//   senderID: senderID,
//   recipientId: recipientId,
//   messageController: _messageController,
//   sendMessage: _sendMessage,
//   scrollController: _scrollController,
//   chatModel: widget.chatModel,
//   onAddAttach: _showMediaPickerBottomSheet,
//   onContinueChat:
//       () => _showContinueChatProposalDialog(context),
// ),
//               ),
//             )
//             : BuildScaffold(
//               theme: theme,
//               currentUserId: currentUserId,
//               onBackPressed: _onBackPressed,
//               isTemporary: isTemporary,
//               chatId: _chatId,
//               senderID: senderID,
//               recipientId: recipientId,
//               messageController: _messageController,
//               sendMessage: _sendMessage,
//               scrollController: _scrollController,
//               chatModel: widget.chatModel,
//               onAddAttach: _showMediaPickerBottomSheet,
//               onContinueChat:
//                   () => _showContinueChatProposalDialog(context),
//             ),
//   ),
// );
//   }
// }

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late StreamSubscription<ChatMessageState> _subscription;
  late String _chatId;

  bool isTemporary = false;
  String senderID = '';
  String recipientId = '';
  late SyncTimerCubit _timerCubit;
  late MediaSelectionCubit _mediaSelectionCubit;

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

    _mediaSelectionCubit = MediaSelectionCubit();

    _subscription = cubit.stream.listen((state) {
      state.maybeMap(
        loaded: (state) {
          _scrollToBottom();
          _checkForContinueRequest(context, state);
        },
        orElse: () {},
      );
    });

    if (isTemporary) {
      final totalTime = widget.temporaryChatModel!.durationMinutes * 60;

      _timerCubit = SyncTimerCubit(
        timerRepository: TimerRepository(
          socketService: context.read<SocketServiceInterface>(),
        ),
        tempChatId: _chatId,
        userId: senderID,
        totalTime: totalTime,
      );
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    _mediaSelectionCubit.close();
    if (isTemporary) {
      _timerCubit.close();
    }
    super.dispose();
  }

  void _checkForContinueRequest(BuildContext context, ChatMessageState state) {
    state.maybeMap(
      loaded: (state) {
        if (state.showContinueRequest && !state.isWaitingForResponse) {
          _showContinueChatDialog(context, state.agreeChatResponse);
        } else if (state.isWaitingForResponse) {
          _showWaitingForResponseDialog(context);
        }
        if (state.agreeChatResponse?.permanentChatCreated == true) {
          _showPermanentChatCreatedDialog(context, state.agreeChatResponse!);
        }
      },
      orElse: () {},
    );
  }

  void _showContinueChatDialog(
    BuildContext context,
    AgreeChatResponse? response,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('Продолжить общение?'),
            content: const Text(
              'Собеседник предлагает продолжить общение в постоянном чате. '
              'Вы согласны?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  context.read<ChatMessageCubit>().respondToContinueRequest(
                    false,
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('Отклонить'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<ChatMessageCubit>().respondToContinueRequest(
                    true,
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('Принять'),
              ),
            ],
          ),
    );
  }

  void _showPermanentChatCreatedDialog(
    BuildContext context,
    AgreeChatResponse response,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('Постоянный чат создан'),
            content: const Text(
              'Теперь вы можете продолжить общение в постоянном чате. '
              'Все сообщения сохранены.',
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Продолжить'),
              ),
            ],
          ),
    );
  }

  void _showWaitingForResponseDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('Ожидание ответа'),
            content: const Text(
              'Запрос на продолжение чата отправлен. '
              'Ожидаем ответа от собеседника...',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  context.read<ChatMessageCubit>().hideContinueRequest();
                  Navigator.of(context).pop();
                },
                child: const Text('Отменить'),
              ),
            ],
          ),
    );
  }

  void _showContinueChatProposalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Продолжить общение?'),
            content: const Text(
              'Хотите предложить собеседнику продолжить общение в постоянном чате?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Отмена'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<ChatMessageCubit>().sendContinueRequest();
                  Navigator.of(context).pop();
                },
                child: const Text('Предложить'),
              ),
            ],
          ),
    );
  }

  void _showTimeOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => AlertDialog(
            title: const Text('Время чата подходит к концу'),
            content: const Text('Выберите действие:'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showAddTimeBottomSheet(context);
                },
                child: const Text('Добавить время'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showContinueChatProposalDialog(context);
                },
                child: const Text('Продолжить в постоянном чате'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showExitConfirmationDialog();
                },
                child: const Text('Завершить чат'),
              ),
            ],
          ),
    );
  }

  void _showAddTimeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Добавить время к чату:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _timerCubit.proposeAddTime(1);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('1 мин'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _timerCubit.proposeAddTime(3);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('3 мин'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _timerCubit.proposeAddTime(5);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('5 мин'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Отмена'),
                ),
              ],
            ),
          ),
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
    final hasSelectedMedia = _mediaSelectionCubit.hasSelectedMedia;

    if (text.isEmpty && !hasSelectedMedia) return;

    if (text.isNotEmpty) {
      context.read<ChatMessageCubit>().sendTextMessage(text);
    }
    if (hasSelectedMedia) {
      final selectedMedia = _mediaSelectionCubit.state.selectedMedia;
      debugPrint('Sending ${selectedMedia.length} media files');
    }

    context.read<StickerCubit>().hideStickers();
    _messageController.clear();
    _mediaSelectionCubit.clearMedia();
  }

  void _onBackPressed() {
    if (isTemporary) {
      _showExitConfirmationDialog();
    } else {
      context.router.pop();
    }
  }

  void _showExitConfirmationDialog() {
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

  void _showMediaPickerBottomSheet() {
    _mediaSelectionCubit.setPickerOpen(true);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => MediaPickerBottomSheet(
            initialSelection: _mediaSelectionCubit.state.selectedMedia,
            maxSelection: 10,
            allowMultiple: true,
            showVideos: true,
            initialChildSize: 0.7,
            minChildSize: 0.4,
            showSelectionIndicators: true,
            maxChildSize: 0.9,
            onSelectionChanged: (selectedItems) {
              _mediaSelectionCubit.clearMedia();
              _mediaSelectionCubit.addMedia(selectedItems);
            },
            onConfirmed: (selectedItems) {
              _mediaSelectionCubit.clearMedia();
              _mediaSelectionCubit.addMedia(selectedItems);
              _mediaSelectionCubit.setPickerOpen(false);
              debugPrint(
                'Bottom sheet selection: ${selectedItems.length} items',
              );
            },
          ),
    ).whenComplete(() {
      _mediaSelectionCubit.setPickerOpen(false);
    });
  }

  void _showTimerFinishedDialog() {
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
    final currentUserId = context.read<UserModelAppInterface>().user!.id;
    return Scaffold(
      body: BlocProvider.value(
        value: _mediaSelectionCubit,
        child: BlocListener<ChatMessageCubit, ChatMessageState>(
          listener: (context, state) {
            state.maybeMap(
              loaded: (state) => _checkForContinueRequest(context, state),
              orElse: () {},
            );
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
                            _showTimerFinishedDialog();
                          },
                          timeOptions: (remainingTime, formattedTime) {
                            _showTimeOptionsDialog(context);
                          },
                        );
                      },
                      child: BuildScaffold(
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
                        onAddAttach: _showMediaPickerBottomSheet,
                        onContinueChat:
                            () => _showContinueChatProposalDialog(context),
                      ),
                    ),
                  )
                  : BuildScaffold(
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
                    onAddAttach: _showMediaPickerBottomSheet,
                    onContinueChat:
                        () => _showContinueChatProposalDialog(context),
                  ),
        ),
      ),
    );
  }
}
