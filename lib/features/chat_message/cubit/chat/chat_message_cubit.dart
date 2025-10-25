import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:media_ui_package/media_ui_package.dart';
import 'package:meet_now_app_server/model/message/message.dart';
import 'package:meet_now_app_server/model/message_media/message_media.dart';
import 'package:meet_now_app_server/model/sticker/sticker.dart';
import 'package:meet_now_app_server/repository/friend/friend_interface.dart';
import 'package:meet_now_app_server/repository/games/games_interface.dart';
import 'package:meet_now_app_server/repository/message/message_interface.dart';
import 'package:meet_now_app_server/repository/upload_image/upload_image_interface.dart';

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

  void sendStickerMessage(Sticker sticker) {
    final message = Message(
      senderId: _senderId,
      recipientId: _recipientId,
      text: "",
      createdAt: DateTime.now(),
      chatId: _isTemporary ? null : _currentChatId,
      tempChatId: _isTemporary ? _currentChatId : null,
      read: false,
      contentType: 'sticker',
      media: [
        MessageMedia(
          contentType: 'sticker',
          stickerId: sticker.id,
          mediaUrl: sticker.imageUrl,
          mimeType: 'image/jpeg',
          fileSize: 0,
          sortOrder: 0,
        ),
      ],
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

  void sendTextMessage(String text) {
    if (text.isEmpty) return;

    final message = Message(
      senderId: _senderId,
      recipientId: _recipientId,
      text: text,
      createdAt: DateTime.now(),
      chatId: _isTemporary ? null : _currentChatId,
      tempChatId: _isTemporary ? _currentChatId : null,
      read: false,
      contentType: 'text',
      media: [],
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

    debugPrint(
      '🔄 ChatMessageCubit: Начало отправки медиа-сообщения с ${mediaItems.length} файлами',
    );

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

    debugPrint(
      '📝 ChatMessageCubit: Создано временное сообщение: ${tempMessage.id}',
    );

    state.maybeMap(
      loaded: (state) {
        emit(state.copyWith(messages: [...state.messages, tempMessage]));
        debugPrint('📱 ChatMessageCubit: Временное сообщение добавлено в UI');
      },
      orElse: () {
        emit(ChatMessageState.loaded(messages: [tempMessage]));
        debugPrint(
          '📱 ChatMessageCubit: Временное сообщение установлено как начальное состояние',
        );
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
      debugPrint(
        '🔄 ChatMessageCubit: Начало загрузки медиафайлов для временного сообщения: ${tempMessage.id}',
      );

      // ЖДЕМ завершения загрузки медиафайлов
      final uploadedMedia = await _uploadMediaFiles(mediaItems);

      debugPrint(
        '✅ ChatMessageCubit: Загрузка медиафайлов завершена, получено ${uploadedMedia.length} медиа',
      );

      // Проверяем, что все медиафайлы были успешно загружены
      final failedUploads =
          uploadedMedia.where((media) => media.mediaUrl == null).toList();
      if (failedUploads.isNotEmpty) {
        debugPrint(
          '❌ ChatMessageCubit: Не все медиафайлы загружены успешно. Провалено: ${failedUploads.length}',
        );
        _updateTempMessageWithError(
          tempMessage.id!,
          'Не удалось загрузить ${failedUploads.length} файлов',
        );
        return;
      }

      debugPrint(
        '✅ ChatMessageCubit: Все медиафайлы загружены успешно, создаем финальное сообщение',
      );

      // Создаем финальное сообщение с загруженными медиа
      final finalMessage = Message(
        senderId: _senderId,
        recipientId: _recipientId,
        text: text,
        createdAt: DateTime.now(),
        chatId: _isTemporary ? null : _currentChatId,
        tempChatId: _isTemporary ? _currentChatId : null,
        read: false,
        contentType: _determineContentType(mediaItems),
        media: uploadedMedia,
      );

      debugPrint(
        '📤 ChatMessageCubit: Отправка финального сообщения с загруженными медиа через messageInterface',
      );

      // ОТПРАВЛЯЕМ сообщение только после того как все медиа загружены
      _messageInterface.sendMessage(finalMessage);

      debugPrint(
        '✅ ChatMessageCubit: Финальное сообщение отправлено успешно через messageInterface',
      );

      // Обновляем UI - заменяем временное сообщение на финальное
      _replaceTempMessage(tempMessage.id!, finalMessage);
    } catch (e) {
      debugPrint('❌ ChatMessageCubit: Ошибка при загрузке медиа: $e');
      _updateTempMessageWithError(tempMessage.id!, e.toString());
    }
  }

  Future<List<MessageMedia>> _uploadMediaFiles(
    List<MediaItem> mediaItems,
  ) async {
    final uploadedMedia = <MessageMedia>[];

    try {
      final uris = mediaItems.map((item) => item.uri).toList();

      debugPrint(
        '📤 ChatMessageCubit: Загрузка ${uris.length} медиафайлов через uploadMultipleMedia',
      );

      final fileUrls = await _uploadImageInterface.uploadMultipleMedia(uris);

      debugPrint(
        '✅ ChatMessageCubit: Получено ${fileUrls.length} URL от uploadMultipleMedia',
      );

      for (int i = 0; i < mediaItems.length; i++) {
        final mediaItem = mediaItems[i];
        final mediaUrl = i < fileUrls.length ? fileUrls[i] : '';

        if (mediaUrl.isNotEmpty) {
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
              sortOrder: i,
            ),
          );

          debugPrint(
            '✅ ChatMessageCubit: Медиа успешно загружено: ${mediaItem.name} -> $mediaUrl',
          );
        } else {
          debugPrint(
            '❌ ChatMessageCubit: Не удалось загрузить медиа: ${mediaItem.name}',
          );
          uploadedMedia.add(
            MessageMedia(
              contentType: _mapMediaTypeToContentType(mediaItem.type),
              mediaUrl: null,
              fileSize: mediaItem.size,
              mimeType: mediaItem.type,
              sortOrder: i,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('❌ ChatMessageCubit: Ошибка в _uploadMediaFiles: $e');
      // В случае ошибки создаем Media с null URL
      for (int i = 0; i < mediaItems.length; i++) {
        final mediaItem = mediaItems[i];
        uploadedMedia.add(
          MessageMedia(
            contentType: _mapMediaTypeToContentType(mediaItem.type),
            mediaUrl: null,
            fileSize: mediaItem.size,
            mimeType: mediaItem.type,
            sortOrder: i,
          ),
        );
      }
    }

    debugPrint(
      '📊 ChatMessageCubit: _uploadMediaFiles завершен. Успешно загружено: ${uploadedMedia.where((m) => m.mediaUrl != null).length}/${mediaItems.length}',
    );
    return uploadedMedia;
  }

  void _replaceTempMessage(String tempMessageId, Message finalMessage) {
    state.maybeMap(
      loaded: (state) {
        final updatedMessages =
            state.messages.map((message) {
              if (message.id == tempMessageId) {
                debugPrint(
                  '🔄 ChatMessageCubit: Заменяем временное сообщение $tempMessageId на финальное',
                );
                return finalMessage;
              }
              return message;
            }).toList();

        emit(state.copyWith(messages: updatedMessages));
      },
      orElse: () {
        debugPrint(
          '🔄 ChatMessageCubit: Устанавливаем финальное сообщение как начальное состояние',
        );
        emit(ChatMessageState.loaded(messages: [finalMessage]));
      },
    );
  }

  void _updateTempMessageWithError(String tempMessageId, String error) {
    state.maybeMap(
      loaded: (state) {
        final updatedMessages =
            state.messages.map((message) {
              if (message.id == tempMessageId) {
                debugPrint(
                  '❌ ChatMessageCubit: Обновляем временное сообщение $tempMessageId с ошибкой: $error',
                );
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
