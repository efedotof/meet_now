import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:media_ui_package/media_ui_package.dart';
import 'package:meet_now_app/server/model/message/message.dart';
import 'package:meet_now_app/server/model/message_media/message_media.dart';
import 'package:meet_now_app/server/repository/friend/friend_interface.dart';
import 'package:meet_now_app/server/repository/games/games_interface.dart';
import 'package:meet_now_app/server/repository/message/message_interface.dart';
import 'package:meet_now_app/server/repository/upload_image/upload_image_interface.dart';

part 'chat_message_state.dart';
part 'chat_message_cubit.freezed.dart';

class ChatMessageCubit extends Cubit<ChatMessageState> {
  StreamSubscription<List<Message>>? _messagesSubscription;
  StreamSubscription<Message>? _singleMessageSubscription;
  final MessageInterface _messageInterface;
  final FriendInterface _friendInterface;
  final UploadImageInterface _uploadImageInterface;

  String? _currentChatId;
  late String _senderId;
  late String _recipientId;
  late bool _isTemporary;

  ChatMessageCubit({
    required UploadImageInterface uploadImageInterface,
    required GamesInterface gamesInterface,
    required FriendInterface friendInterface,
    required MessageInterface messageInterface,
  }) : _uploadImageInterface = uploadImageInterface,
       _friendInterface = friendInterface,
       _messageInterface = messageInterface,
       super(const ChatMessageState.initial());

  void initialize({
    required BuildContext context,
    required bool isTemporary,
    required String chatId,
    required String senderId,
    required String recipientId,
  }) {
    if (_currentChatId == chatId) return;

    _isTemporary = isTemporary;
    _currentChatId = chatId;
    _senderId = senderId;
    _recipientId = recipientId;

    _disposeSubscriptions();
    emit(const ChatMessageState.loading());

    _messagesSubscription = _messageInterface.messagesStream.listen(
      (messages) => emit(ChatMessageState.loaded(messages: messages)),
      onError: (e) => emit(ChatMessageState.error(e.toString())),
    );

    _singleMessageSubscription = _messageInterface.singleMessageStream.listen((
      newMessage,
    ) {
      state.maybeMap(
        loaded: (state) {
          final updatedMessages =
              state.messages.map((existingMessage) {
                if (existingMessage.id?.startsWith('temp') ?? false) {
                  return newMessage;
                }
                return existingMessage;
              }).toList();

          emit(state.copyWith(messages: updatedMessages));
        },
        orElse: () => emit(ChatMessageState.loaded(messages: [newMessage])),
      );
    });

    _messageInterface.requestMessages(chatId);
  }

  void sendTextMessage(String text) {
    if (text.isEmpty) return;

    final message = Message(
      senderId: _senderId,
      recipientId: _recipientId,
      text: text,
      createdAt: DateTime.now(),
      chatId: _isTemporary ? null : _currentChatId,
      tempChatId: _isTemporary ? _currentChatId : null,
      read: false, // Исправлено: было null
      contentType: 'text', // Исправлено: добавлено значение
      media: [], // Исправлено: добавлен пустой список
    );

    state.maybeMap(
      loaded: (state) {
        final optimisticMessage = message.copyWith(createdAt: DateTime.now());
        emit(state.copyWith(messages: [...state.messages, optimisticMessage]));
        _messageInterface.sendMessage(message);
      },
      orElse: () => _messageInterface.sendMessage(message),
    );
  }

  void sendMediaMessage(List<MediaItem> mediaItems, {String text = ''}) {
    if (mediaItems.isEmpty) return;

    // Создаем временное сообщение без ссылок на медиа
    final tempMessage = Message(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      senderId: _senderId,
      recipientId: _recipientId,
      text: text,
      createdAt: DateTime.now(),
      chatId: _isTemporary ? null : _currentChatId,
      tempChatId: _isTemporary ? _currentChatId : null,
      read: false,
      contentType: _determineContentType(mediaItems),
      media:
          mediaItems
              .map(
                (mediaItem) => MessageMedia(
                  id:
                      'temp_media_${DateTime.now().millisecondsSinceEpoch}_${mediaItems.indexOf(mediaItem)}',
                  contentType: _mapMediaTypeToContentType(mediaItem.type),
                  mimeType: mediaItem.type,
                  fileSize: mediaItem.size,
                  mediaUrl: null,
                  thumbnailUrl: null,
                  sortOrder: mediaItems.indexOf(mediaItem),
                ),
              )
              .toList(),
    );

    state.maybeMap(
      loaded: (state) {
        emit(state.copyWith(messages: [...state.messages, tempMessage]));
      },
      orElse: () {
        emit(ChatMessageState.loaded(messages: [tempMessage]));
      },
    );

    _uploadAndSendMediaMessage(mediaItems, tempMessage, text);
  }

  Future<void> _uploadAndSendMediaMessage(
    List<MediaItem> mediaItems,
    Message tempMessage,
    String text,
  ) async {
    try {
      final uploadedMedia = await _uploadMediaFiles(mediaItems);

      final finalMessage = tempMessage.copyWith(id: null, media: uploadedMedia);

      _messageInterface.sendMessage(finalMessage);
    } catch (e) {
      _updateTempMessageWithError(tempMessage.id!, e.toString());
      debugPrint('Error uploading media: $e');
    }
  }

  Future<List<MessageMedia>> _uploadMediaFiles(
    List<MediaItem> mediaItems,
  ) async {
    final uploadedMedia = <MessageMedia>[];

    for (final mediaItem in mediaItems) {
      try {
        final fileUrls = await _uploadImageInterface.uploadsImages([
          mediaItem.uri,
        ]);

        if (fileUrls.isNotEmpty) {
          final mediaUrl = fileUrls.first;

          String? thumbnailUrl;
          if (mediaItem.type == 'video') {
            thumbnailUrl = await _generateVideoThumbnail(mediaItem, mediaUrl);
          }

          uploadedMedia.add(
            MessageMedia(
              contentType: _mapMediaTypeToContentType(mediaItem.type),
              mediaUrl: mediaUrl,
              thumbnailUrl: thumbnailUrl,
              fileSize: mediaItem.size,
              mimeType: mediaItem.type,
              sortOrder: mediaItems.indexOf(mediaItem),
            ),
          );
        }
      } catch (e) {
        debugPrint('Failed to upload media item: $e');
        uploadedMedia.add(
          MessageMedia(
            contentType: _mapMediaTypeToContentType(mediaItem.type),
            mediaUrl: null,
            fileSize: mediaItem.size,
            mimeType: mediaItem.type,
          ),
        );
      }
    }

    return uploadedMedia;
  }

  void _updateTempMessageWithError(String tempMessageId, String error) {
    state.maybeMap(
      loaded: (state) {
        final updatedMessages =
            state.messages.map((message) {
              if (message.id == tempMessageId) {
                return message.copyWith(text: 'Ошибка загрузки: $error');
              }
              return message;
            }).toList();

        emit(state.copyWith(messages: updatedMessages));
      },
      orElse: () {},
    );
  }

  String _determineContentType(List<MediaItem> mediaItems) {
    if (mediaItems.length == 1) {
      return _mapMediaTypeToContentType(mediaItems.first.type);
    }
    return 'file';
  }

  String _mapMediaTypeToContentType(String mediaType) {
    switch (mediaType) {
      case 'image':
        return 'image';
      case 'video':
        return 'video';
      default:
        return 'file';
    }
  }

  Future<String?> _generateVideoThumbnail(
    MediaItem videoItem,
    String videoUrl,
  ) async {
    // TODO: Реализовать генерацию превью для видео
    return null;
  }

  void reconnect({
    required BuildContext context,
    required bool isTemporary,
    required String chatId,
    required String senderId,
    required String recipientId,
  }) {
    if (_currentChatId != null) {
      _disposeSubscriptions();
      emit(const ChatMessageState.loading());
      initialize(
        isTemporary: isTemporary,
        chatId: chatId,
        senderId: senderId,
        recipientId: recipientId,
        context: context,
      );
    }
  }

  void _disposeSubscriptions() {
    _messagesSubscription?.cancel();
    _messagesSubscription = null;
    _singleMessageSubscription?.cancel();
    _singleMessageSubscription = null;
  }

  @override
  Future<void> close() {
    _disposeSubscriptions();
    return super.close();
  }

  Future<void> friendRequest({
    required BuildContext context,
    required String toUserId,
  }) async {
    if (toUserId == "") return;

    try {
      final result = await _friendInterface.sendFriendRequest(
        toUserId: toUserId,
      );
      debugPrint("запрос выполнен, данные получены: $result");
    } catch (e) {
      debugPrint("Произошла ошибка: $e");
    }
  }
}
