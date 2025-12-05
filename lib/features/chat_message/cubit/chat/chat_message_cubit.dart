import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';

part 'chat_message_state.dart';
part 'chat_message_cubit.freezed.dart';

class ChatMessageCubit extends Cubit<ChatMessageState> {
  StreamSubscription<List<Message>>? _messagesSubscription;
  StreamSubscription<Message>? _singleMessageSubscription;
  StreamSubscription<AgreeChatResponse>? _chatAgreeNotificationSubscription;
  StreamSubscription<AgreeChatResponse>? _chatAgreeResponseSubscription;
  StreamSubscription<AgreeChatResponse>? _chatPermanentCreatedSubscription;

  final MessageInterface _messageInterface;
  final FriendInterface _friendInterface;
  final UploadImageInterface _uploadImageInterface;
  final SocketServiceInterface _socketInterface;
  final ChatInterface _chatInterface;
  String? _currentChatId;
  String? _senderId;
  String? _recipientId;
  bool? _isTemporary;

  ChatMessageCubit({
    required ChatInterface chatInterface,
    required UploadImageInterface uploadImageInterface,
    required SocketServiceInterface socketInterface,
    required GamesInterface gamesInterface,
    required FriendInterface friendInterface,
    required MessageInterface messageInterface,
  }) : _chatInterface = chatInterface,
       _socketInterface = socketInterface,
       _uploadImageInterface = uploadImageInterface,
       _friendInterface = friendInterface,
       _messageInterface = messageInterface,
       super(const ChatMessageState.initial()) {
    _setupChatAgreeSubscriptions();
  }

  void initialize({
    required BuildContext context,
    required bool isTemporary,
    required String chatId,
    required String senderId,
    required String recipientId,
  }) {
    if (_currentChatId == chatId) {
      return;
    }

    _isTemporary = isTemporary;
    _currentChatId = chatId;
    _senderId = senderId;
    _recipientId = recipientId;

    _disposeSubscriptions();
    emit(const ChatMessageState.loading());

    try {
      _messagesSubscription = _messageInterface.messagesStream.listen(
        (messages) {
          if (!isClosed) {
            emit(
              ChatMessageState.loaded(
                messages: messages,
                isTemporary: isTemporary,
              ),
            );
          }
        },
        onError: (e) {
          if (!isClosed) {
            emit(ChatMessageState.error(e.toString()));
          }
        },
        cancelOnError: false,
      );

      _singleMessageSubscription = _messageInterface.singleMessageStream.listen(
        (newMessage) {
          debugPrint(
            '🆕 ChatMessageCubit: Получено новое сообщение: ${newMessage.id} от ${newMessage.senderId}',
          );
          debugPrint('📝 Текст: ${newMessage.text}');
          if (!isClosed) {
            state.maybeMap(
              loaded: (state) {
                final existingIndex = state.messages.indexWhere(
                  (msg) => msg.id == newMessage.id,
                );

                List<Message> updatedMessages;
                if (existingIndex != -1) {
                  updatedMessages = List<Message>.from(state.messages);
                  updatedMessages[existingIndex] = newMessage;
                } else {
                  updatedMessages = [...state.messages, newMessage];
                }

                emit(state.copyWith(messages: updatedMessages));
              },
              orElse:
                  () => emit(
                    ChatMessageState.loaded(
                      messages: [newMessage],
                      isTemporary: isTemporary,
                    ),
                  ),
            );
          }
        },
        onError: (e) {
          debugPrint('Single message stream error: $e');
          _reconnectMessageSubscriptions();
        },
        cancelOnError: false,
      );

      _messageInterface.requestMessages(chatId);
    } catch (e) {
      if (!isClosed) {
        emit(ChatMessageState.error('Failed to initialize: $e'));
      }
    }
  }

  void _setupChatAgreeSubscriptions() {
    _chatAgreeNotificationSubscription = _socketInterface
        .chatAgreeNotificationStream
        .listen(_handleChatAgreeNotification);
    _chatAgreeResponseSubscription = _socketInterface.chatAgreeResponseStream
        .listen(_handleChatAgreeResponse);
    _chatPermanentCreatedSubscription = _socketInterface
        .chatPermanentCreatedStream
        .listen(_handleChatPermanentCreated);
  }

  void _handleChatAgreeNotification(AgreeChatResponse response) {
    if (response.tempChatId == _currentChatId) {
      debugPrint(
        '🔄 ChatMessageCubit: Получено уведомление о запросе продолжения чата от пользователя ${response.userId}',
      );
      state.maybeMap(
        loaded: (state) {
          emit(
            state.copyWith(
              showContinueRequest: true,
              agreeChatResponse: response,
            ),
          );
        },
        orElse: () {},
      );
    }
  }

  void _handleChatAgreeResponse(AgreeChatResponse response) {
    if (response.tempChatId == _currentChatId) {
      debugPrint(
        '🔄 ChatMessageCubit: Получен ответ на запрос продолжения чата: bothAgreed=${response.bothAgreed}, success=${response.success}',
      );

      if (response.bothAgreed == true &&
          response.permanentChatCreated == true) {
        _handleSuccessfulAgreement(response);
      } else if (response.errorMessage != null) {
        _handleAgreementError(response);
      }
    }
  }

  void _handleChatPermanentCreated(AgreeChatResponse response) {
    if (response.tempChatId == _currentChatId &&
        response.permanentChatCreated == true) {
      debugPrint(
        '🔄 ChatMessageCubit: Постоянный чат создан: ${response.permanentChat?.chatId}',
      );
      _handleSuccessfulAgreement(response);
    }
  }

  void _handleSuccessfulAgreement(AgreeChatResponse response) {
    _isTemporary = false;
    _currentChatId = response.permanentChat?.chatId;

    state.maybeMap(
      loaded: (state) {
        emit(
          state.copyWith(
            showContinueRequest: false,
            isTemporary: false,
            agreeChatResponse: response,
          ),
        );
      },
      orElse: () {},
    );
  }

  void _handleAgreementError(AgreeChatResponse response) {
    state.maybeMap(
      loaded: (state) {
        emit(
          state.copyWith(
            showContinueRequest: false,
            isWaitingForResponse: false,
            agreeChatResponse: response,
          ),
        );
      },
      orElse: () {},
    );
  }

  void sendContinueRequest() {
    if (_currentChatId == null || _isTemporary == false) return;

    debugPrint('🔄 ChatMessageCubit: Отправка запроса на продолжение чата');
    _socketInterface.agreeToContinue(_currentChatId!);

    state.maybeMap(
      loaded: (state) {
        emit(
          state.copyWith(
            showContinueRequest: false,
            isWaitingForResponse: true,
          ),
        );
      },
      orElse: () {},
    );
  }

  void respondToContinueRequest(bool agree) {
    if (_currentChatId == null) return;

    debugPrint('🔄 ChatMessageCubit: Ответ на запрос продолжения: $agree');
    if (agree) {
      _socketInterface.agreeToContinue(_currentChatId!);
    }

    state.maybeMap(
      loaded: (state) {
        emit(
          state.copyWith(
            showContinueRequest: false,
            isWaitingForResponse: false,
          ),
        );
      },
      orElse: () {},
    );
  }

  void hideContinueRequest() {
    state.maybeMap(
      loaded: (state) {
        emit(
          state.copyWith(
            showContinueRequest: false,
            isWaitingForResponse: false,
          ),
        );
      },
      orElse: () {},
    );
  }

  void sendStickerMessage(Sticker sticker) {
    if (_senderId == null || _recipientId == null || _isTemporary == null) {
      debugPrint('ChatMessageCubit not initialized');
      return;
    }

    final message = Message(
      senderId: _senderId!,
      recipientId: _recipientId!,
      text: "",
      createdAt: DateTime.now(),
      chatId: _isTemporary! ? null : _currentChatId,
      tempChatId: _isTemporary! ? _currentChatId : null,
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
    if (_senderId == null || _recipientId == null || _isTemporary == null) {
      debugPrint('ChatMessageCubit not initialized');
      return;
    }

    final message = Message(
      senderId: _senderId!,
      recipientId: _recipientId!,
      text: text,
      createdAt: DateTime.now(),
      chatId: _isTemporary! ? null : _currentChatId,
      tempChatId: _isTemporary! ? _currentChatId : null,
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
    if (_senderId == null || _recipientId == null || _isTemporary == null) {
      debugPrint('ChatMessageCubit not initialized');
      return;
    }

    debugPrint(
      '🔄 ChatMessageCubit: Начало отправки медиа-сообщения с ${mediaItems.length} файлами',
    );

    final tempMessage = Message(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      senderId: _senderId!,
      recipientId: _recipientId!,
      text: text,
      createdAt: DateTime.now(),
      chatId: _isTemporary! ? null : _currentChatId,
      tempChatId: _isTemporary! ? _currentChatId : null,
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
        emit(
          ChatMessageState.loaded(
            messages: [tempMessage],
            isTemporary: _isTemporary!,
          ),
        );
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
    if (_senderId == null || _recipientId == null || _isTemporary == null) {
      debugPrint('ChatMessageCubit not initialized during media upload');
      return;
    }

    try {
      debugPrint('🔄 ChatMessageCubit: Начало загрузки медиафайлов');

      final uploadedMedia = await _uploadMediaFiles(mediaItems);

      debugPrint('✅ ChatMessageCubit: Загрузка медиафайлов завершена');

      final failedUploads =
          uploadedMedia.where((media) => media.mediaUrl == null).toList();
      if (failedUploads.isNotEmpty && !isClosed) {
        _updateTempMessageWithError(
          tempMessage.id!,
          'Не удалось загрузить ${failedUploads.length} файлов',
        );
        return;
      }

      final finalMessage = Message(
        senderId: _senderId!,
        recipientId: _recipientId!,
        text: text,
        createdAt: DateTime.now(),
        chatId: _isTemporary! ? null : _currentChatId,
        tempChatId: _isTemporary! ? _currentChatId : null,
        read: false,
        contentType: _determineContentType(mediaItems),
        media: uploadedMedia,
      );

      try {
        _messageInterface.sendMessage(finalMessage);
        if (!isClosed) {
          _replaceTempMessage(tempMessage.id!, finalMessage);
        }
      } catch (e) {
        if (!isClosed) {
          _updateTempMessageWithError(
            tempMessage.id!,
            'Failed to send message: $e',
          );
        }
      }
    } catch (e) {
      debugPrint('❌ ChatMessageCubit: Ошибка при загрузке медиа: $e');
      if (!isClosed) {
        _updateTempMessageWithError(tempMessage.id!, e.toString());
      }
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
        emit(
          ChatMessageState.loaded(
            messages: [finalMessage],
            isTemporary: _isTemporary!,
          ),
        );
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

  Future<void> finishTempChat({required TemporaryChat? temporaryModel}) async {
    try {
      if (temporaryModel != null) {
        _chatInterface.finistTemporaryChat(tempChat: temporaryModel);
      }
    } catch (e) {
      debugPrint("Ошибка завершения чата: $e");
    }
  }

  Future<String?> _generateVideoThumbnail(
    MediaItem videoItem,
    String videoUrl,
  ) async {
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
        context: context,
        isTemporary: isTemporary,
        chatId: chatId,
        senderId: senderId,
        recipientId: recipientId,
      );
    }
  }

  void _reconnectMessageSubscriptions() {
    _disposeMessageSubscriptions();

    _messagesSubscription = _messageInterface.messagesStream.listen(
      (messages) {
        if (!isClosed) {
          emit(
            ChatMessageState.loaded(
              messages: messages,
              isTemporary: _isTemporary!,
            ),
          );
        }
      },
      onError: (e) {
        debugPrint('Messages stream error: $e');
        Future.delayed(Duration(seconds: 3), () {
          if (!isClosed) _reconnectMessageSubscriptions();
        });
      },
      cancelOnError: false,
    );

    _singleMessageSubscription = _messageInterface.singleMessageStream.listen(
      (newMessage) {
        if (!isClosed) {
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
            orElse:
                () => emit(
                  ChatMessageState.loaded(
                    messages: [newMessage],
                    isTemporary: _isTemporary!,
                  ),
                ),
          );
        }
      },
      onError: (e) {
        debugPrint('Single message stream error: $e');
        Future.delayed(Duration(seconds: 3), () {
          if (!isClosed) _reconnectMessageSubscriptions();
        });
      },
      cancelOnError: false,
    );

    if (_currentChatId != null) {
      _messageInterface.requestMessages(_currentChatId!);
    }
  }

  void _disposeMessageSubscriptions() {
    _messagesSubscription?.cancel();
    _messagesSubscription = null;
    _singleMessageSubscription?.cancel();
    _singleMessageSubscription = null;
  }

  void _disposeSubscriptions() {
    _messagesSubscription?.cancel();
    _messagesSubscription = null;
    _singleMessageSubscription?.cancel();
    _singleMessageSubscription = null;
    _chatAgreeNotificationSubscription?.cancel();
    _chatAgreeNotificationSubscription = null;
    _chatAgreeResponseSubscription?.cancel();
    _chatAgreeResponseSubscription = null;
    _chatPermanentCreatedSubscription?.cancel();
    _chatPermanentCreatedSubscription = null;
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
    if (toUserId.isEmpty) return;

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
